from typing import Optional

import yul.yul_ast as ast
from yul.AstVisitor import AstMapper
from yul.ScopeResolver import get_scope, ScopeResolver


class ScopeFlattener(AstMapper):
    def __init__(self):
        self.n_names: int = 0
        self.block_functions: list[ast.FunctionDefinition] = []

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node)
        all_statements = []
        statements = node.statements
        while statements:
            block: ast.Block = self.visit(ScopeResolver().map(ast.Block(statements)))
            all_statements.extend(block.statements)
            statements = self.block_functions
            self.block_functions = []
        return ast.Block(tuple(all_statements))

    def visit_block(self, node: ast.Block, inline: Optional[bool] = None):
        if inline or get_scope(node).is_global():
            return super().visit_block(node)
        if not get_scope(node).bound_variables and inline is not False:
            return super().visit_block(node)

        free_vars = sorted(get_scope(node).free_variables)  # to ensure order
        mod_vars = sorted(get_scope(node).modified_variables)
        typed_free_vars = [get_scope(node).resolve(x.name) for x in free_vars]
        typed_mod_vars = [get_scope(node).resolve(x.name) for x in mod_vars]
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
