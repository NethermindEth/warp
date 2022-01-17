from __future__ import annotations

from typing import Dict, List, Optional, Tuple, Union

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper

Scope = Dict[str, Optional[ast.Literal]]


class VariableInliner(AstMapper):
    """This class inlines the value of variables by tracking their values
    across declarations and assignments.
    """

    def __init__(self):
        super().__init__()
        self.scope: List[Scope] = []

    def visit_block(self, node: ast.Block) -> ast.Block:
        self.scope.append(dict())
        visited_node = super().visit_block(node)
        self.scope.pop()
        return visited_node

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration
    ) -> ast.VariableDeclaration:
        current_scope = self.scope[-1]
        if isinstance(node.value, ast.Literal):
            assert len(node.variables) == 1
            current_scope[node.variables[0].name] = node.value
        elif isinstance(node.value, ast.Identifier):
            assert len(node.variables) == 1
            current_scope[node.variables[0].name] = self._val_lookup(node.value.name)
        elif node.value is None:
            for var in node.variables:
                current_scope[var.name] = ast.Literal(0)
        else:
            assert isinstance(node.value, ast.FunctionCall)

        return ast.VariableDeclaration(
            variables=node.variables,
            value=self.visit(node.value) if node.value is not None else None,
        )

    def visit_assignment(self, node: ast.Assignment) -> ast.Assignment:
        if isinstance(node.value, ast.Literal):
            assert len(node.variable_names) == 1
            var_name = node.variable_names[0].name
            self._assign_value(var_name, node.value)
        elif isinstance(node.value, ast.Identifier):
            assert len(node.variable_names) == 1
            var_name = node.variable_names[0].name
            ident_value = self._val_lookup(node.value.name)
            self._assign_value(var_name, ident_value)
        else:
            assert isinstance(node.value, ast.FunctionCall)
            for var in node.variable_names:
                # Can't calculate the value, invalidate the old one
                self._assign_value(var.name, None)
        return ast.Assignment(
            variable_names=node.variable_names,
            value=self.visit(node.value),
        )

    def visit_identifier(
        self, node: ast.Identifier
    ) -> Union[ast.Literal, ast.Identifier]:
        return self._val_lookup(node.name) or node

    def _info_lookup(self, var_name: str) -> Optional[Tuple[ast.Literal, Scope]]:
        for scope in reversed(self.scope):
            value = scope.get(var_name)
            if value:
                return (value, scope)
        return None

    def _val_lookup(self, var_name: str) -> Optional[ast.Literal]:
        val_and_scope = self._info_lookup(var_name)
        if val_and_scope:
            return val_and_scope[0]
        return None

    def _scope_lookup(self, var_name: str) -> Optional[Scope]:
        val_and_scope = self._info_lookup(var_name)
        if val_and_scope:
            return val_and_scope[1]
        return None

    def _assign_value(self, var_name: str, value: Optional[ast.Literal]):
        definition_scope = self._scope_lookup(var_name)
        if definition_scope:
            definition_scope[var_name] = None
        self.scope[-1][var_name] = value
