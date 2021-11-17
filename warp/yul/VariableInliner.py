from __future__ import annotations

from typing import Dict, List, Optional, Tuple, Union

import yul.yul_ast as ast
from yul.AstMapper import AstMapper

Scope = Dict[str, ast.Literal]


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
        if node.variables:
            current_scope = self.scope[-1]
            # We only care about the cases where the rhs is either a implicit
            # literal (rhs is None and value is 0) explicit literal or an
            # identifier. In the latter two cases only one variable can be
            # declared.
            var_name = node.variables[0].name
            if isinstance(node.value, ast.Literal):
                current_scope[var_name] = node.value
            elif isinstance(node.value, ast.Identifier):
                val_and_scope = self.scope_lookup(node.value.name)
                current_scope[var_name] = val_and_scope[0] if val_and_scope else None
            elif node.value is None:
                for var in node.variables:
                    current_scope[var.name] = ast.Literal(0)

        return ast.VariableDeclaration(
            variables=node.variables,
            value=self.visit(node.value) if node.value is not None else None,
        )

    def visit_assignment(self, node: ast.Assignment) -> ast.Assignment:
        if node.variable_names:
            current_scope = self.scope[-1]
            # We only care about the cases where the rhs is either explicit literal
            # or an identifier. In these cases only one variable can be assigned to.
            var_name = node.variable_names[0].name
            val_and_scope = self.scope_lookup(var_name)
            # Invalidate |var_name| in |definition_scope| if it was not declared in the
            # current scope.
            if var_name not in current_scope and val_and_scope:
                (_, definition_scope) = val_and_scope
                definition_scope[var_name] = None

            if isinstance(node.value, ast.Literal):
                current_scope[var_name] = node.value
            elif isinstance(node.value, ast.Identifier):
                current_scope[var_name] = val_and_scope[0] if val_and_scope else None

        return ast.Assignment(
            variable_names=node.variable_names,
            value=self.visit(node.value),
        )

    def visit_identifier(
        self, node: ast.Identifier
    ) -> Union[ast.Literal, ast.Identifier]:
        val_and_scope = self.scope_lookup(node.name)
        return val_and_scope[0] if val_and_scope else node

    def scope_lookup(self, var_name: str) -> Optional[Tuple[ast.Literal, Scope]]:
        for scope in reversed(self.scope):
            value = scope.get(var_name)
            if value:
                return (value, scope)

        return None
