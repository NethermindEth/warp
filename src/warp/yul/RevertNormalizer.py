from __future__ import annotations

from collections import defaultdict
from contextlib import contextmanager
from typing import Mapping, Optional

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper
from warp.yul.BuiltinHandler import BuiltinHandler
from warp.yul.top_sort import top_sort_ast

REVERT = ast.FunctionCall(
    function_name=ast.Identifier("revert"), arguments=[ast.Literal(0), ast.Literal(0)]
)
REVERT_STMT = ast.ExpressionStatement(REVERT)


class RevertNormalizer(AstMapper):
    """Prerequisites: LeaveNormalizer"""

    def __init__(self, builtins: Mapping[str, BuiltinHandler]):
        super().__init__()
        self.builtins = builtins
        self.revert_functions: set[str] = set()
        self.terminating_functions: defaultdict[str, bool] = defaultdict(lambda: True)
        # Meaningfully terminating functions are functions that break
        # control flow and return some result. The most basic example
        # is 'return'. In theory, 'revert' should also return some
        # result, but we don't support it. The reason is that it's
        # impossible right now to rollback a transaction while
        # returning something on StarkNet.
        # The default value is 'True', so that when we encounter a
        # function we haven't yet marked as terminating (even if it
        # is), we wouldn't throw it away.
        self.terminates_execution: bool = False
        self.terminates_function: bool = False

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        if isinstance(node, ast.Block):
            node = top_sort_ast(node)
        return self.visit(node)

    def visit_assignment(self, node: ast.Assignment) -> ast.Statement:
        value = self.visit(node.value)
        if _is_revert(value):
            return REVERT_STMT
        else:
            return ast.Assignment(variable_names=node.variable_names, value=node.value)

    def visit_function_call(self, node: ast.FunctionCall) -> ast.FunctionCall:
        name = node.function_name.name
        if name in self.revert_functions:
            return REVERT
        self.terminates_execution = self._is_function_terminating(name)
        return node

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration
    ) -> ast.Statement:
        value = self.visit(node.value) if node.value else None
        if _is_revert(value):
            return REVERT_STMT
        else:
            return ast.VariableDeclaration(variables=node.variables, value=value)

    def visit_block(self, node: ast.Block) -> ast.Block:
        checkpoint: list[ast.Statement] = []
        new_stmts = []
        for stmt in node.statements:
            with self._new_context():
                new_stmt = self.visit(stmt)
                new_stmts.append(new_stmt)
                if _is_revert(new_stmt):
                    return ast.Block((*checkpoint, REVERT_STMT))
                stmt_terminates_execution = self.terminates_execution
                stmt_terminates_function = self.terminates_function
                if self.terminates_execution or self.terminates_function:
                    checkpoint.extend(new_stmts)
                    new_stmts = []
            self.terminates_execution |= stmt_terminates_execution
            self.terminates_function |= stmt_terminates_function
        checkpoint.extend(new_stmts)
        return ast.Block(tuple(checkpoint))

    def visit_function_definition(
        self, node: ast.FunctionDefinition
    ) -> ast.FunctionDefinition:
        with self._new_context():
            body = self.visit(node.body)
            if _is_revert(body):
                self.revert_functions.add(node.name)
            self.terminating_functions[node.name] = self.terminates_execution
            return ast.FunctionDefinition(
                name=node.name,
                parameters=node.parameters,
                return_variables=node.return_variables,
                body=body,
            )

    def visit_if(self, node: ast.If) -> ast.Statement:
        condition = self.visit(node.condition)
        if _is_revert(condition):
            return ast.ExpressionStatement(REVERT)
        body = self.visit(node.body)
        else_body = self.visit(node.else_body) if node.else_body else None
        if _is_revert(body) and _is_revert(else_body):
            return REVERT_STMT
        return ast.If(condition, body, else_body)

    def visit_leave(self, node: ast.Leave) -> ast.Leave:
        self.terminates_function = True
        return node

    @contextmanager
    def _new_context(self):
        old_terminates_execution = self.terminates_execution
        old_terminates_function = self.terminates_function
        self.terminates_execution = False
        self.terminates_function = False
        try:
            yield None
        finally:
            self.terminates_execution = old_terminates_execution
            self.terminates_function = old_terminates_function

    def _is_function_terminating(self, function_name: str) -> bool:
        handler = self.builtins.get(function_name)
        if handler:
            return handler.is_terminating()
        return self.terminating_functions[function_name]


def _is_revert(node: Optional[ast.Node]) -> bool:
    if isinstance(node, ast.FunctionCall):
        return node.function_name.name == "revert"
    if isinstance(node, ast.ExpressionStatement):
        return _is_revert(node.expression)
    if isinstance(node, ast.Block):
        return len(node.statements) == 1 and _is_revert(node.statements[0])
    return False
