"""This module contains definitions of Yul AST nodes, mostly following
the specification here:
https://docs.soliditylang.org/en/v0.8.7/yul.html#specification-of-yul.

"""

from __future__ import annotations

from abc import ABC
from dataclasses import dataclass
from functools import lru_cache
from typing import Iterable, Optional, Union

from yul.utils import snakify


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
    statements: tuple["Statement", ...] = ()


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
