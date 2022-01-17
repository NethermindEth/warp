from warp.yul.ast import Expression, Node, Statement, as_expression, as_statement


class WarpException(Exception):
    def __init__(self, msg):
        super().__init__(msg)


def warp_assert(condition, msg):
    if not condition:
        raise WarpException(msg)


def warp_assert_expression(x: Node, msg: str) -> Expression:
    expr = as_expression(x)
    if not expr:
        raise WarpException(msg)
    return expr


def warp_assert_statement(x: Node, msg: str) -> Statement:
    stmt = as_statement(x)
    if not stmt:
        raise WarpException(msg)
    return stmt
