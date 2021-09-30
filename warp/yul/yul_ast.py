from __future__ import annotations

from abc import ABC
from dataclasses import dataclass
from functools import lru_cache
from typing import Union, Optional, Iterable

from yul.utils import snakify


class Node(ABC):
    pass


@dataclass(eq=False, frozen=True)
class TypedName(Node):
    name: str
    type: str = "Uint256"


@dataclass(eq=True, frozen=True)
class Literal(Node):
    value: Union[int, bool]


@dataclass(eq=True, order=True, frozen=True)
class Identifier(Node):
    name: str


@dataclass(eq=False, frozen=True)
class Assignment(Node):
    variable_names: list[Identifier]
    value: "Expression"


@dataclass(eq=False, frozen=True)
class FunctionCall(Node):
    function_name: Identifier
    arguments: list["Expression"]


@dataclass(eq=False, frozen=True)
class ExpressionStatement(Node):
    """According to
    https://docs.soliditylang.org/en/latest/yul.html#restrictions-on-the-grammar,
    only top-level expressions can be statements. Furthermore, they
    must evaluate to zero values. That only leaves function calls
    that return zero values. Weird.

    """

    expression: "Expression"


@dataclass(eq=False, frozen=True)
class VariableDeclaration(Node):
    variables: list[TypedName]
    value: Optional["Expression"]  # None means all variables initialize to 0


@dataclass(eq=False, frozen=True)
class Block(Node):
    statements: tuple["Statement"] = ()

    @property
    @lru_cache(None)
    def scope(self) -> "Scope":
        return ScopeResolver().compute_uncached_scope(self)


@dataclass(eq=False, frozen=True)
class FunctionDefinition(Node):
    name: str
    parameters: list[TypedName]
    return_variables: list[TypedName]
    body: Block

    @property
    @lru_cache(None)
    def scope(self) -> "Scope":
        return ScopeResolver().compute_uncached_scope(self)


@dataclass(eq=False, frozen=True)
class If(Node):
    condition: "Expression"
    body: Block
    # ↓ doesn't exist in Yul, convenient for mapping to cairo
    else_body: Optional[Block] = None


@dataclass(eq=False, frozen=True)
class Case(Node):
    value: Optional[Literal]  # None for the default case
    body: Block


@dataclass(eq=False, frozen=True)
class Switch(Node):
    expression: "Expression"
    cases: list[Case]


@dataclass(eq=False, frozen=True)
class ForLoop(Node):
    pre: Block
    condition: "Expression"
    post: Block
    body: Block


@dataclass(eq=False, frozen=True)
class Break(Node):
    pass


@dataclass(eq=False, frozen=True)
class Continue(Node):
    pass


@dataclass(eq=False, frozen=True)
class Leave(Node):
    pass


# No two nodes of this class should be different from each
# other. Thus, it's cheaper to create one object and use it in all
# contexts, rather than create new `Leave()` each time.
LEAVE = Leave()

Expression = Union[Literal, Identifier, FunctionCall]
Statement = Union[
    ExpressionStatement,
    Assignment,
    VariableDeclaration,
    FunctionDefinition,
    If,
    Switch,
    ForLoop,
    Break,
    Continue,
    Leave,
    Block,
]

NODE_TYPES = frozenset(
    (
        Literal,
        Identifier,
        FunctionCall,
        ExpressionStatement,
        Assignment,
        VariableDeclaration,
        FunctionDefinition,
        If,
        Switch,
        ForLoop,
        Break,
        Continue,
        Leave,
        Block,
    )
)


@dataclass
class Scope:
    """'Scope' represents symbols encountered in a particular scope.

    - 'bound_variables' maps names of variables assigned in the scope
    to their types.

    - 'read_variables' is a set of undeclared ("free") identifiers
      encountered in the scope that were read from.

    - 'modified_variables' is a set of undeclared ("free") identifiers
      encountered in the scope that were written to.

    """

    bound_variables: dict[str, TypedName]
    read_variables: frozenset[Identifier]
    modified_variables: frozenset[Identifier]


EMPTY_SCOPE = Scope({}, frozenset(), frozenset())


def get_children(node: Node) -> Iterable[Node]:
    if isinstance(node, Assignment):
        return node.variable_names + [node.value]
    elif isinstance(node, FunctionCall):
        return node.arguments + [node.function_name]
    elif isinstance(node, ExpressionStatement):
        return [node.expression]
    elif isinstance(node, VariableDeclaration):
        return node.variables + ([] if node.value is None else [node.value])
    elif isinstance(node, Block):
        return node.statements
    elif isinstance(node, FunctionDefinition):
        return node.parameters + node.return_variables + [node.body]
    elif isinstance(node, If):
        return [node.condition, node.body] + (
            [] if node.else_body is None else [node.else_body]
        )
    elif isinstance(node, Case):
        return [node.value, node.body]
    elif isinstance(node, Switch):
        return node.cases + [node.expression]
    elif isinstance(node, ForLoop):
        return [node.pre, node.condition, node.post, node.body]
    else:
        return []


class AstVisitor:
    def __init__(self):
        self.path = []
        # ↑ path of nodes from the AST root down to the current node,
        # inclusively

        def path_decorator(method):
            def new_method(node, *args, **kwargs):
                self.path.append(node)
                res = method(node, *args, **kwargs)
                self.path.pop()
                return res

            return new_method

        for node_type in NODE_TYPES:
            visitor_name = "visit_" + snakify(node_type.__name__)
            method = getattr(self, visitor_name, None)
            if method is None:
                method = self.common_visit
            setattr(self, visitor_name, path_decorator(method))

    def visit(self, node: Node, *args, **kwargs):
        method_name = "visit_" + snakify(type(node).__name__)
        method = getattr(self, method_name, self.common_visit)
        return method(node, *args, **kwargs)

    def common_visit(self, node, *args, **kwargs):
        self.visit_list(get_children(node))

    def visit_list(self, nodes: Iterable[Node], *args, **kwargs) -> list:
        return [self.visit(x, *args, **kwargs) for x in nodes]


class ScopeResolver(AstVisitor):
    def __init__(self):
        super().__init__()
        self.bound_variables: dict[str, TypedName] = {}
        self.known_variables: set[Identifier] = set()
        # ↑ variables, whose value is known at this point and doesn't
        # need passing from the outside.
        self.read_variables: list[Identifier] = []
        self.modified_variables: list[Identifier] = []

    def compute_uncached_scope(self, node: Union[Block, FunctionDefinition]) -> Scope:
        if isinstance(node, Block):
            self.common_visit(node)
        else:
            assert isinstance(node, FunctionDefinition)
            print(node.name)
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

    def visit_typed_name(self, node: TypedName):
        self.bound_variables[node.name] = node
        self.known_variables.add(Identifier(node.name))

    def visit_identifier(self, node: Identifier, is_function: bool = False):
        if not is_function:
            self._register_read(node)

    def visit_assignment(self, node: Assignment):
        for var in node.variable_names:
            self._register_modification(var)
        self.visit(node.value)

    def visit_function_call(self, node: FunctionCall):
        self.visit(node.function_name, is_function=True)
        self.visit_list(node.arguments)

    def visit_block(self, node: Block):
        for var in node.scope.read_variables:
            self._register_read(var)
        for var in node.scope.modified_variables:
            self._register_modification(var)

    def visit_function_definition(self, node: FunctionDefinition):
        for var in node.scope.read_variables:
            self._register_read(var)
        for var in node.scope.modified_variables:
            self._register_modification(var)

    def visit_if(self, node: If):
        self.visit(node.condition)
        scope1 = node.body.scope
        scope2 = node.else_body.scope if node.else_body else EMPTY_SCOPE
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
        new_known = scope1.modified_variables & scope2.modified_variables
        self.read_variables.extend(new_read)
        self.modified_variables.extend(new_mod)
        self.known_variables.update(new_known)

    def _register_modification(self, var: Identifier):
        if var not in self.known_variables:
            self.modified_variables.append(var)
            self.known_variables.add(var)

    def _register_read(self, var: Identifier):
        if var not in self.known_variables:
            self.read_variables.append(var)
