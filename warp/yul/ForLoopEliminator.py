from contextlib import contextmanager
from typing import Optional

import yul.yul_ast as ast
from yul.AstMapper import AstMapper


class ForLoopEliminator(AstMapper):
    """This class removes for-loops from Yul AST. Loops are replaced by
    recursive functions.

    Furthermore, it replaces breaks and continues with leaves.
    "breaking" from a loop requires an additional condition variable.

    """

    def __init__(self):
        super().__init__()
        self.n_loops = 0
        self.body_name: Optional[str] = None
        self.loop_name: Optional[str] = None
        self.break_name: Optional[str] = None
        self.aux_functions: [ast.FunctionDefinition] = []

    def map(self, node: ast.Node, **kwargs):
        if not isinstance(node, ast.Block):
            return self.visit(node)

        block = self.visit(node)
        return ast.Block(block.statements + tuple(self.aux_functions))

    def visit_for_loop(self, node: ast.ForLoop):
        assert not node.pre.statements, "Loop not simplified"
        assert not node.post.statements, "Loop not simplified"

        with self._new_for_loop():
            body = self.visit(node.body)
            break_id = ast.Identifier(self.break_name)

            free_vars = sorted(body.scope.free_variables)
            mod_vars = sorted(body.scope.modified_variables)
            # ↓ default Uint256 type for everything
            typed_free_vars = [ast.TypedName(x.name) for x in free_vars]
            typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]

            body_call = ast.Assignment(
                variable_names=mod_vars,
                value=ast.FunctionCall(
                    function_name=ast.Identifier(self.body_name), arguments=free_vars
                ),
            )
            body_fun = ast.FunctionDefinition(
                name=self.body_name,
                parameters=typed_free_vars,
                return_variables=typed_mod_vars,
                body=body,
            )

            has_break = break_id in body.scope.free_variables
            if has_break:
                free_vars = sorted(body.scope.free_variables - {break_id})
                mod_vars = sorted(body.scope.modified_variables - {break_id})
                typed_free_vars = [ast.TypedName(x.name) for x in free_vars]
                typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]

            loop_call = ast.Assignment(
                variable_names=mod_vars,
                value=ast.FunctionCall(
                    function_name=ast.Identifier(self.loop_name),
                    arguments=free_vars,
                ),
            )

            if has_break:
                loop_statements = (
                    ast.VariableDeclaration(
                        variables=[ast.TypedName(self.break_name)],
                        value=ast.Literal(False),
                    ),
                    body_call,
                    ast.If(
                        condition=break_id,
                        body=ast.Block((ast.LEAVE,)),
                        else_body=ast.Block((loop_call,)),
                    ),
                )
            else:
                loop_statements = (body_call, loop_call)

            loop_fun = ast.FunctionDefinition(
                name=self.loop_name,
                parameters=typed_free_vars,
                return_variables=typed_mod_vars,
                body=ast.Block(
                    (
                        ast.If(
                            condition=node.condition,
                            body=ast.Block(loop_statements),
                        ),
                    )
                ),
            )
            self.aux_functions.extend((body_fun, loop_fun))
            return ast.Block((loop_call,))

    def visit_break(self, node: ast.Break):
        return ast.Block(
            (
                ast.Assignment(
                    variable_names=[ast.Identifier(self.break_name)],
                    value=ast.Literal(True),
                ),
                ast.LEAVE,
            )
        )

    def visit_continue(self, node: ast.Continue):
        return ast.LEAVE

    @contextmanager
    def _new_for_loop(self):
        old_names = (self.body_name, self.loop_name, self.break_name)
        self.body_name = f"__warp_loop_body_{self.n_loops}"
        self.loop_name = f"__warp_loop_{self.n_loops}"
        self.break_name = f"__warp_break_{self.n_loops}"
        self.n_loops += 1
        try:
            yield None
        finally:
            self.body_name, self.loop_name, self.break_name = old_names
