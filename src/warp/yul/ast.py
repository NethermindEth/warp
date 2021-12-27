"""This module contains definitions of Yul AST nodes, mostly following
the specification here:
https://docs.soliditylang.org/en/v0.8.7/yul.html#specification-of-yul.

"""

from __future__ import annotations

from abc import ABC
from dataclasses import dataclass
from typing import Optional, Tuple, Union


class Node(ABC):
    pass


@dataclass(eq=False, frozen=True)
class TypedName(Node):
    name: str
    type: str = "Uint256"


@dataclass(eq=True, frozen=True)
class Literal(Node):
    value: Union[int, bool, str]


@dataclass(eq=True, order=True, frozen=True)
class Identifier(Node):
    name: str


@dataclass(eq=False, frozen=True)
class Assignment(Node):
    variable_names: list[Identifier]
    value: "Expression"

    def __post_init__(self):
        assert (
            self.variable_names
        ), "Each assignment should assign to at least one variable"


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

    def __post_init__(self):
        assert (
            self.variables
        ), "Each variable declaration should declare at least one variable"


@dataclass(eq=False, frozen=True)
class Block(Node):
    statements: "Statements" = ()


@dataclass(eq=False, frozen=True)
class FunctionDefinition(Node):
    name: str
    parameters: list[TypedName]
    return_variables: list[TypedName]
    body: Block


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
LEAVE: Leave = Leave()

LEAVE_BLOCK: Block = Block(statements=((LEAVE,)))


def yul_log_not(argument: Expression) -> FunctionCall:
    return FunctionCall(Identifier("iszero"), [argument])


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

Statements = Tuple[Statement, ...]

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


# The following block is needed because 'isinstance(x, Union[bla,
# bla])' doesn't work in Python 3.7, so working around.
def as_expression(x: Node) -> Optional[Expression]:
    if isinstance(x, (Literal, Identifier, FunctionCall)):
        return x
    return None


# pytype: disable=bad-return-type
def as_statement(x: Node) -> Optional[Statement]:
    expr = as_expression(x)
    if expr:
        return None
    return x


# pytype: enable=bad-return-type


def assert_expression(x: Node) -> Expression:
    expr = as_expression(x)
    assert expr
    return expr


def assert_statement(x: Node) -> Statement:
    stmt = as_statement(x)
    assert stmt
    return stmt
