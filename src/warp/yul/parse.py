from __future__ import annotations

import warp.yul.ast as ast
from warp.yul.utils import camelize, remove_prefix
from warp.yul.WarpException import WarpException, warp_assert, warp_assert_statement

_node_to_parser = {}


def register_parser(parser):
    fun_name = parser.__name__
    assert fun_name.startswith("parse_"), (
        "A parsing function should start with 'parse_' "
        "and end with the node type written in snake case"
    )
    node_type = "Yul" + camelize(remove_prefix(fun_name, "parse_"))
    _node_to_parser[node_type] = parser

    def inner(yul_ast):
        warp_assert(
            yul_ast["nodeType"] == node_type,
            f'Expected {node_type}, got {yul_ast["nodeType"]}',
        )

        return parser(yul_ast)

    return inner


def parse_node(yul_ast) -> ast.Node:
    node_type = yul_ast["nodeType"]
    parser = _node_to_parser.get(node_type)
    if parser is None:
        raise WarpException(f"Don't know how to handle {node_type}")
    else:
        return parser(yul_ast)


def parse_expression(yul_ast) -> ast.Expression:
    if yul_ast["nodeType"] == "YulIdentifier":
        return parse_identifier(yul_ast)
    elif yul_ast["nodeType"] == "YulLiteral":
        return parse_literal(yul_ast)
    else:
        return parse_function_call(yul_ast)


def parse_statement(yul_ast) -> ast.Statement:
    node = parse_node(yul_ast)
    return warp_assert_statement(node, f"Expected yul_ast.Statement, got {type(node)}")


@register_parser
def parse_typed_name(yul_ast) -> ast.TypedName:
    name_ = yul_ast["name"]
    type_ = yul_ast["type"]
    if not type_:
        type_ = "Uint256"
    return ast.TypedName(name_, type_)


def read_int(x: str) -> int:
    return int(x, 16) if x.startswith("0x") else int(x)


@register_parser
def parse_literal(yul_ast) -> ast.Literal:
    kind = yul_ast["kind"]
    if kind == "number":
        return ast.Literal(read_int(yul_ast["value"]))
    elif kind == "bool":
        return ast.Literal(yul_ast["value"] == "true")
    elif kind == "string":
        yul_string = yul_ast["hexValue"]
        string_length = len(yul_string)
        encoded_string = read_int("0x" + yul_string + "0" * (64 - string_length))
        return ast.Literal(encoded_string)
    else:
        assert False, "Invalid Literal node"


@register_parser
def parse_identifier(yul_ast) -> ast.Identifier:
    return ast.Identifier(yul_ast["name"])


@register_parser
def parse_assignment(yul_ast) -> ast.Assignment:
    var_names = [parse_identifier(var) for var in yul_ast["variableNames"]]
    value = parse_expression(yul_ast["value"])
    return ast.Assignment(var_names, value)


@register_parser
def parse_function_call(yul_ast) -> ast.FunctionCall:
    fun_name = parse_identifier(yul_ast["functionName"])
    args = [parse_expression(x) for x in yul_ast["arguments"]]
    return ast.FunctionCall(fun_name, args)


@register_parser
def parse_expression_statement(yul_ast) -> ast.ExpressionStatement:
    return ast.ExpressionStatement(parse_expression(yul_ast["expression"]))


@register_parser
def parse_variable_declaration(yul_ast) -> ast.VariableDeclaration:
    variables = [parse_typed_name(x) for x in yul_ast.get("variables", [])]
    value = parse_expression(yul_ast["value"]) if yul_ast["value"] else None
    return ast.VariableDeclaration(variables, value)


@register_parser
def parse_block(yul_ast) -> ast.Block:
    statements = tuple(parse_statement(x) for x in yul_ast["statements"])
    return ast.Block(statements=statements)


@register_parser
def parse_function_definition(yul_ast) -> ast.FunctionDefinition:
    fun_name = yul_ast["name"]
    params = [parse_typed_name(x) for x in yul_ast.get("parameters", [])]
    returns = [parse_typed_name(x) for x in yul_ast.get("returnVariables", [])]
    body = parse_block(yul_ast["body"])
    return ast.FunctionDefinition(fun_name, params, returns, body)


@register_parser
def parse_if(yul_ast) -> ast.If:
    condition = parse_expression(yul_ast["condition"])
    body = parse_block(yul_ast["body"])
    return ast.If(condition, body)


@register_parser
def parse_case(yul_ast) -> ast.Case:
    return ast.Case(
        parse_literal(yul_ast["value"]) if yul_ast["value"] != "default" else None,
        parse_block(yul_ast["body"]),
    )


@register_parser
def parse_switch(yul_ast) -> ast.Switch:
    return ast.Switch(
        parse_expression(yul_ast["expression"]),
        [parse_case(x) for x in yul_ast["cases"]],
    )


@register_parser
def parse_for_loop(yul_ast) -> ast.ForLoop:
    return ast.ForLoop(
        parse_block(yul_ast["pre"]),
        parse_expression(yul_ast["condition"]),
        parse_block(yul_ast["post"]),
        parse_block(yul_ast["body"]),
    )


@register_parser
def parse_break(yul_ast) -> ast.Break:
    return ast.Break()


@register_parser
def parse_continue(yul_ast) -> ast.Continue:
    return ast.Continue()


@register_parser
def parse_leave(yul_ast) -> ast.Leave:
    return ast.LEAVE
