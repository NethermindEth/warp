from __future__ import annotations

from dataclasses import dataclass
from typing import Union
from weakref import WeakKeyDictionary

import warp.yul.ast as ast
from warp.yul.AstVisitor import AstVisitor


@dataclass
class Scope:
    """'Scope' represents symbols encountered in a particular scope.

    - 'bound_variables' maps names of variables declared in the scope
      to their types.

    - 'read_variables' is a set of undeclared ("free") identifiers
      whose value has been required at some point, but couldn't be
      derived from the scope at that point

    - 'modified_variables' is a set of undeclared ("free") identifiers
      which have been modified at some point, but they weren't
      declared in the scope at that point.

    An intuition for how this groups can be used is the following. If
    this scopes is to be extracted into a separate function,
    'read_variables' is the minimal set of parameters of that
    function. 'modified_variables' is the minimal set of return
    variables of that function.

    NOTE: when there is a 'leave' instruction in the scope, it leads
    to ambiguity regarding 'read_variables'. 'leave' means that a
    function should return (thus, read) values of all of its "return
    variables". If the scope is being computed for an 'ast.Block', the
    set of return variables is unknown.

    """

    bound_variables: dict[str, ast.TypedName]
    read_variables: frozenset[ast.Identifier]
    modified_variables: frozenset[ast.Identifier]


EMPTY_SCOPE = Scope({}, frozenset(), frozenset())


class ScopeResolver(AstVisitor):
    """Gathers information necessary to create a 'Scope'."""

    def __init__(self):
        super().__init__()
        self.bound_variables: dict[str, ast.TypedName] = {}
        self.known_variables: set[ast.Identifier] = set()
        # ↑ variables, whose value is known at this point and doesn't
        # need passing from the outside.
        self.read_variables: list[ast.Identifier] = []
        self.modified_variables: list[ast.Identifier] = []

    def compute_uncached_scope(
        self, node: Union[ast.Block, ast.FunctionDefinition]
    ) -> Scope:
        """Computes 'Scope' for the 'node' without attempting to access
        cache (to avoid infinite recursion).

        """
        if isinstance(node, ast.Block):
            self.common_visit(node)
        else:
            assert isinstance(node, ast.FunctionDefinition)
            # Not visiting return_variables, they are not bound or
            # mentioned semantically.
            self.visit_list(node.parameters)
            self.visit(node.body)

        read = frozenset(self.read_variables)
        modified = frozenset(self.modified_variables)
        return Scope(
            bound_variables=self.bound_variables,
            read_variables=read,
            modified_variables=modified,
        )

    def visit_typed_name(self, node: ast.TypedName):
        self.bound_variables[node.name] = node
        self.known_variables.add(ast.Identifier(node.name))

    def visit_identifier(self, node: ast.Identifier, is_function: bool = False):
        if not is_function:
            self._register_read(node)

    def visit_assignment(self, node: ast.Assignment):
        # assigned vars are registered _after_ the assignment is complete
        self.visit(node.value)
        for var in node.variable_names:
            self._register_modification(var)

    def visit_function_call(self, node: ast.FunctionCall):
        self.visit(node.function_name, is_function=True)
        self.visit_list(node.arguments)

    def visit_variable_declaration(self, node: ast.VariableDeclaration):
        # declared vars are registered _after_ the declaration is complete
        if node.value:
            self.visit(node.value)
        self.visit_list(node.variables)

    def visit_block(self, node: ast.Block):
        for var in get_scope(node).read_variables:
            self._register_read(var)
        for var in get_scope(node).modified_variables:
            self._register_modification(var)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        for var in get_scope(node).read_variables:
            self._register_read(var)
        for var in get_scope(node).modified_variables:
            self._register_modification(var)

    def visit_if(self, node: ast.If):
        self.visit(node.condition)
        scope1 = get_scope(node.body)
        scope2 = get_scope(node.else_body) if node.else_body else EMPTY_SCOPE
        # If a variable has been modified in only one branch, it still
        # means that we need a read access to know it's value after
        # the if. For that reason, we include symmetric difference of
        # modified variables to the set of the read ones.
        new_read = (
            scope1.read_variables
            | scope2.read_variables
            | (scope1.modified_variables ^ scope2.modified_variables)
        )
        new_mod = scope1.modified_variables | scope2.modified_variables
        # only variables that have been modified on both possible code
        # paths are fully determined in the scope
        new_known = scope1.modified_variables & scope2.modified_variables
        for var in new_read:
            self._register_read(var)
        for var in new_mod:
            self._register_modification(var)
        self.known_variables.update(new_known)

    def _register_modification(self, var: ast.Identifier):
        if var not in self.known_variables:
            self.modified_variables.append(var)
            self.known_variables.add(var)

    def _register_read(self, var: ast.Identifier):
        if var not in self.known_variables:
            self.read_variables.append(var)


_scope_cache: WeakKeyDictionary = WeakKeyDictionary()


def get_scope(node: Union[ast.Block, ast.FunctionDefinition]) -> Scope:
    """Retrieves node's 'Scope'.

    Doesn't recompute the scope if it's already been computed. Caching
    is performed using weak references, so it doesn't extend nodes'
    lifetimes.

    """
    scope = _scope_cache.get(node)
    if scope:
        return scope
    scope = ScopeResolver().compute_uncached_scope(node)
    _scope_cache[node] = scope
    return scope
