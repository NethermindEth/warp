from typing import Optional

import yul.yul_ast as ast
from yul.AstMapper import AstMapper


class ScopeFlattener(AstMapper):
    def __init__(self):
        super().__init__()
        self.n_names: int = 0
        self.block_functions: list[ast.FunctionDefinition] = []

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node)
        all_statements = []
        statements = node.statements
        while statements:
            all_statements.extend(self.visit_list(statements))
            statements = self.block_functions
            self.block_functions = []
        return ast.Block(tuple(all_statements))

    def visit_block(self, node: ast.Block, inline: Optional[bool] = None):
        if inline:
            return super().visit_block(node)
        if not node.scope.bound_variables and inline is not False:
            return super().visit_block(node)

        free_vars = sorted(node.scope.free_variables)  # to ensure order
        mod_vars = sorted(node.scope.modified_variables)
        # ↓ default Uint256 type for everything
        typed_free_vars = [ast.TypedName(x.name) for x in free_vars]
        typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]
        block_fun = ast.FunctionDefinition(
            name=self._request_fresh_name(),
            parameters=typed_free_vars,
            return_variables=typed_mod_vars,
            body=node,
        )
        self.block_functions.append(block_fun)
        block_call = ast.Assignment(
            variable_names=mod_vars,
            value=ast.FunctionCall(
                function_name=ast.Identifier(block_fun.name),
                arguments=free_vars,
            ),
        )
        return self.visit(block_call)

    def visit_for_loop(self, node: ast.ForLoop):
        assert not node.pre.statements, "Loop not simplified"
        assert not node.post.statements, "Loop not simplified"
        fun_call = self.visit(node.body, inline=False)
        typed_free_vars = self.block_functions[-1].parameters
        typed_mod_vars = self.block_functions[-1].return_variables
        free_vars = [ast.Identifier(x.name) for x in typed_free_vars]
        mod_vars = [ast.Identifier(x.name) for x in typed_mod_vars]
        fun_name = self._request_fresh_name()
        loop_call = ast.Assignment(
            variable_names=mod_vars,
            value=ast.FunctionCall(
                function_name=ast.Identifier(fun_name),
                arguments=free_vars,
            ),
        )
        loop_fun = ast.FunctionDefinition(
            name=fun_name,
            parameters=typed_free_vars,
            return_variables=typed_free_vars,
            body=ast.Block(
                (
                    ast.If(
                        condition=node.condition,
                        body=ast.Block((fun_call, loop_call)),
                    ),
                )
            ),
        )
        self.block_functions.append(loop_fun)
        return self.visit(loop_call)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        return ast.FunctionDefinition(
            name=node.name,
            parameters=self.visit_list(node.parameters),
            return_variables=self.visit_list(node.return_variables),
            body=self.visit(node.body, inline=True),
        )

    def _request_fresh_name(self):
        name = f"__warp_block_{self.n_names}"
        self.n_names += 1
        return name
