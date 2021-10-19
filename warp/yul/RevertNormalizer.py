from __future__ import annotations

from typing import Optional

import yul.yul_ast as ast
from yul.AstMapper import AstMapper
from yul.storage_access import extract_var_from_getter, extract_var_from_setter
from yul.top_sort import top_sort_ast

REVERT = ast.FunctionCall(
    function_name=ast.Identifier("revert"), arguments=[ast.Literal(0), ast.Literal(0)]
)
REVERT_STMT = ast.ExpressionStatement(REVERT)


class RevertNormalizer(AstMapper):
    def __init__(self):
        super().__init__()
        self.revert_functions: set[str] = set()

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        if isinstance(node, ast.Block):
            node = top_sort_ast(node)
        return self.visit(node)

    def visit_assignment(self, node: ast.Assignment) -> ast.Statement:
        value = self.visit(node.value)
        if self._is_revert(value):
            return REVERT_STMT
        else:
            return ast.Assignment(variable_names=node.variable_names, value=node.value)

    def visit_function_call(self, node: ast.FunctionCall) -> ast.FunctionCall:
        if node.function_name.name in self.revert_functions:
            return REVERT
        else:
            return node

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration
    ) -> ast.Statement:
        value = self.visit(node.value) if node.value else None
        if self._is_revert(value):
            return REVERT_STMT
        else:
            return ast.VariableDeclaration(variables=node.variables, value=value)

    def visit_block(self, node: ast.Block) -> ast.Block:
        stmts = self.visit_list(node.statements)
        if any(self._is_revert(x) for x in stmts):
            return ast.Block((REVERT_STMT,))
        else:
            return ast.Block(tuple(x for x in stmts if not self._is_revert_function(x)))

    def visit_function_definition(
        self, node: ast.FunctionDefinition
    ) -> ast.FunctionDefinition:
        body = self.visit(node.body)
        if not _is_untouchable(node) and self._is_revert(body):
            self.revert_functions.add(node.name)
        return ast.FunctionDefinition(
            name=node.name,
            parameters=node.parameters,
            return_variables=node.return_variables,
            body=body,
        )

    def visit_if(self, node: ast.If) -> ast.Statement:
        condition = self.visit(node.condition)
        if self._is_revert(condition):
            return ast.ExpressionStatement(REVERT)
        body = self.visit(node.body)
        else_body = self.visit(node.else_body) if node.else_body else None
        if self._is_revert(body) and self._is_revert(else_body):
            return REVERT_STMT
        return ast.If(condition, body, else_body)

    def _is_revert(self, node: Optional[ast.Node]):
        if isinstance(node, ast.FunctionCall):
            return node.function_name.name == "revert"
        if isinstance(node, ast.ExpressionStatement):
            return self._is_revert(node.expression)
        if isinstance(node, ast.Block):
            return len(node.statements) == 1 and self._is_revert(node.statements[0])
        return False

    def _is_revert_function(self, node: ast.Node):
        return (
            isinstance(node, ast.FunctionDefinition)
            and node.name in self.revert_functions
        )


def _is_untouchable(function: ast.FunctionDefinition) -> bool:
    name = function.name
    if name == "fun_ENTRY_POINT":
        return True
    if extract_var_from_getter(name) or extract_var_from_setter(name):
        return True
    return False
