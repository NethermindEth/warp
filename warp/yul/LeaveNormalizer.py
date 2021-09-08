from __future__ import annotations

import yul.yul_ast as ast
from yul.AstMapper import AstMapper


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


def normalize_statements(statements: tuple[ast.Statement]) -> tuple[ast.Statement]:
    statements = strip_trailing_leaves(statements)
    if len(statements) == 1 and isinstance(statements[0], ast.If):
        return (normalize_if(statements[0]),)
    else:
        return (*statements, ast.LEAVE)


def normalize_if(if_node: ast.If) -> ast.If:
    return ast.If(
        condition=if_node.condition,
        body=normalize_block(if_node.body),
        else_body=normalize_block(if_node.else_body)
        if if_node.else_body
        else ast.Block((ast.LEAVE,)),
    )


def strip_trailing_leaves(statements: tuple[ast.Statement]) -> tuple[ast.Statement]:
    leave_no = len(statements)
    while leave_no > 0 and isinstance(statements[leave_no - 1], ast.Leave):
        leave_no -= 1
    return statements[:leave_no]
