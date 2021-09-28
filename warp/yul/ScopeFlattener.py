from typing import Optional

import yul.yul_ast as ast
from yul.AstMapper import AstMapper


class ScopeFlattener(AstMapper):
    def __init__(self):
        super().__init__()
        self.n_names: int = 0
        self.block_functions: list[ast.FunctionDefinition] = []
        self.revert_function_name: str = "__warp_block_00"
        self.call_revert: bool = False

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
        if self.is_leave_if(node):
            return ast.If(
                condition=self.visit(node.condition),
                body=self.visit(node.body),
                else_body=self.visit(node.else_body) if node.else_body else None,
            )

        if_block_scope = ast.Block((node,)).scope

        free_vars = sorted(if_block_scope.free_variables)
        mod_vars = sorted(if_block_scope.modified_variables)

        typed_free_vars = [ast.TypedName(x.name) for x in free_vars]
        typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]

        revert_if = self.is_revert_if(node)

        fun_name = (
            self.revert_function_name
            if revert_if
            else self._request_fresh_name() + "_if"
        )
        if not revert_if or not self.call_revert:
            if_fun = ast.FunctionDefinition(
                name=fun_name,
                parameters=typed_free_vars,
                return_variables=typed_mod_vars,
                body=ast.Block((node,)),
            )
            self.block_functions.append(if_fun)

        self.call_revert |= revert_if

        if mod_vars == []:
            return_assignment = ast.FunctionCall(
                function_name=ast.Identifier(fun_name),
                arguments=free_vars,
            )
        else:
            return_assignment = ast.Assignment(
                variable_names=mod_vars,
                value=ast.FunctionCall(
                    function_name=ast.Identifier(fun_name),
                    arguments=free_vars,
                ),
            )

        return self.visit(return_assignment)

    def is_revert_if(self, node: ast.If):
        return self._is_revert(node.body) or self._is_revert(node.else_body)

    def is_leave_if(self, node: ast.If):
        body_stmt = node.body.statements[0] if node.body.statements else None
        else_stmt = (
            node.else_body.statements[0]
            if (node.else_body and node.else_body.statements)
            else None
        )

        return isinstance(body_stmt, ast.Leave) or isinstance(else_stmt, ast.Leave)

    def _request_fresh_name(self):
        name = f"__warp_block_{self.n_names}"
        self.n_names += 1
        return name

    def _is_revert(self, node: Optional[ast.Node]):
        if isinstance(node, ast.FunctionCall):
            return node.function_name.name == "revert"
        if isinstance(node, ast.ExpressionStatement):
            return self._is_revert(node.expression)
        if isinstance(node, ast.Block):
            return len(node.statements) == 1 and self._is_revert(node.statements[0])
        return False
