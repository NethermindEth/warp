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

    def visit_block(self, node: ast.Block, inline: Optional[bool] = None) -> ast.Block:
        if inline or not node.scope.bound_variables:
            stmts = []
            for stmt in node.statements:
                new_stmt = self.visit(stmt)
                if isinstance(new_stmt, ast.Block):
                    stmts.extend(new_stmt.statements)
                else:
                    stmts.append(new_stmt)
            return ast.Block(tuple(stmts))

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
        if mod_vars == []:
            self.block_functions.append(block_fun)
            block_call = ast.FunctionCall(
                function_name=ast.Identifier(block_fun.name),
                arguments=free_vars,
            )

        else:
            self.block_functions.append(block_fun)
            block_call = ast.Assignment(
                variable_names=mod_vars,
                value=ast.FunctionCall(
                    function_name=ast.Identifier(block_fun.name),
                    arguments=free_vars,
                ),
            )
        return ast.Block((self.visit(block_call),))

    def visit_function_definition(self, node: ast.FunctionDefinition):
        # We do not want to flatten an if-block if it is the only statement in
        # the function body. Skip visit_if in such cases and instead visit all
        # the branches of the if-block.
        if len(node.body.statements) == 1 and isinstance(
            node.body.statements[0], ast.If
        ):
            if_statement = node.body.statements[0]

            return ast.FunctionDefinition(
                name=node.name,
                parameters=self.visit_list(node.parameters),
                return_variables=self.visit_list(node.return_variables),
                body=ast.Block(
                    (
                        ast.If(
                            condition=self.visit(if_statement.condition),
                            body=self.visit(if_statement.body),
                            else_body=self.visit(if_statement.else_body)
                            if if_statement.else_body
                            else None,
                        ),
                    )
                ),
            )

        return ast.FunctionDefinition(
            name=node.name,
            parameters=self.visit_list(node.parameters),
            return_variables=self.visit_list(node.return_variables),
            body=self.visit(node.body, inline=True),
        )

    def visit_if(self, node: ast.If):
        if_block_scope = ast.Block((node,)).scope

        free_vars = sorted(if_block_scope.free_variables)
        mod_vars = sorted(if_block_scope.modified_variables)

        typed_free_vars = [ast.TypedName(x.name) for x in free_vars]
        typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]

        fun_name = self._request_fresh_name() + "_if"
        if_fun = ast.FunctionDefinition(
            name=fun_name,
            parameters=typed_free_vars,
            return_variables=typed_mod_vars,
            body=ast.Block((node,)),
        )
        self.block_functions.append(if_fun)

        if mod_vars == []:
            return_assignment = ast.FunctionCall(
                function_name=ast.Identifier(if_fun.name),
                arguments=free_vars,
            )
        else:
            return_assignment = ast.Assignment(
                variable_names=mod_vars,
                value=ast.FunctionCall(
                    function_name=ast.Identifier(if_fun.name),
                    arguments=free_vars,
                ),
            )

        return self.visit(return_assignment)

    def _request_fresh_name(self):
        name = f"__warp_block_{self.n_names}"
        self.n_names += 1
        return name
