from __future__ import annotations

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper


class LeaveNormalizer(AstMapper):
    """This class puts a 'leave' statement at the end of each function. If
    the function consists of a single 'if', it puts 'leave' at the end of
    each branch.

    After this transformation, the only thing required to correctly
    place cairo 'return's during the transpilation process is to just
    replace yul 'leave's.

    """

    def visit_function_definition(self, node: ast.FunctionDefinition):
        return ast.FunctionDefinition(
            name=node.name,
            parameters=node.parameters,
            return_variables=node.return_variables,
            body=normalize_block(node.body),
        )


def normalize_block(block: ast.Block) -> ast.Block:
    return ast.Block(normalize_statements(block.statements))


def normalize_statements(statements: ast.Statements) -> ast.Statements:
    statements = strip_trailing_leaves(statements)
    if statements and isinstance(statements[-1], ast.If):
        return (*statements[:-1], normalize_if(statements[-1]))
    else:
        return (*statements, ast.LEAVE)


def normalize_if(if_node: ast.If) -> ast.If:
    return ast.If(
        condition=if_node.condition,
        body=normalize_block(if_node.body),
        else_body=normalize_block(if_node.else_body)
        if if_node.else_body
        else ast.LEAVE_BLOCK,
    )


def strip_trailing_leaves(statements: ast.Statements) -> ast.Statements:
    leave_no = len(statements)
    while leave_no > 0 and isinstance(statements[leave_no - 1], ast.Leave):
        leave_no -= 1
    return statements[:leave_no]
