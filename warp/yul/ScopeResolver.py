from contextlib import contextmanager
from typing import Optional, Union

import yul.yul_ast as ast
from yul.AstVisitor import AstMapper
from yul.WarpException import WarpException


# Should be replaced with a cached property
class Scope:
    def __init__(self, parent: Optional["Scope"] = None):
        self.parent: Optional["Scope"] = parent
        self.free_variables: set[ast.Identifier] = set()
        self.bound_variables: dict[str, ast.TypedName] = {}
        self.modified_variables: set[ast.Identifier] = set()

    def register_encounter(self, var: ast.Identifier):
        if var.name not in self.bound_variables:
            self.free_variables.add(var)

    def register_modification(self, var: ast.Identifier):
        if var.name not in self.bound_variables:
            self.modified_variables.add(var)

    def resolve(self, name: str) -> ast.TypedName:
        found = self.bound_variables.get(name)
        if found is not None:
            return found
        elif self.parent is not None:
            return self.parent.resolve(name)
        else:
            raise WarpException(f"Variable {name} not found")

    def is_global(self) -> bool:
        return self.parent is None


class ScopeResolver(AstMapper):
    def __init__(self):
        super().__init__()
        self.scope = Scope()  # the global scope
        self.n_names: int = 0

    def visit_typed_name(self, node: ast.TypedName):
        self.scope.bound_variables[node.name] = node
        return super().visit_typed_name(node)

    def visit_identifier(self, node: ast.Identifier, is_function: bool = False):
        if not is_function:
            self.scope.register_encounter(node)
        return super().visit_identifier(node)

    def visit_assignment(self, node: ast.Assignment):
        for var in node.variable_names:
            self.scope.register_modification(var)
        return super().visit_assignment(node)

    def visit_function_call(self, node: ast.FunctionCall):
        return ast.FunctionCall(
            function_name=self.visit(node.function_name, is_function=True),
            arguments=self.visit_list(node.arguments),
        )

    def visit_block(self, node: ast.Block):
        with self._new_scope():
            res = super().visit_block(node)
            res.scope = self.scope
            return res

    def visit_function_definition(self, node: ast.FunctionDefinition):
        with self._new_scope():
            res = super().visit_function_definition(node)
            res.scope = self.scope
            return res

    @contextmanager
    def _new_scope(self):
        new_scope = Scope(parent=self.scope)
        self.scope = new_scope
        try:
            yield None
        finally:
            self.scope = new_scope.parent
            for var in new_scope.free_variables:
                self.scope.register_encounter(var)
            for var in new_scope.modified_variables:
                self.scope.register_modification(var)


def get_scope(node: Union[ast.Block, ast.FunctionDefinition]) -> Scope:
    scope = getattr(node, "scope", None)
    if scope is None:
        raise WarpException(
            "Scopes has not yet been resolved, please run ScopeResolver first"
        )
    return scope
