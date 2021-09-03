from __future__ import annotations
from typing import Iterable

import yul.yul_ast as ast
from yul.utils import snakify


def get_children(node: ast.Node) -> list[ast.Node]:
    if isinstance(node, ast.Assignment):
        return node.variable_names + [node.value]
    elif isinstance(node, ast.FunctionCall):
        return node.arguments + [node.function_name]
    elif isinstance(node, ast.ExpressionStatement):
        return [node.expression]
    elif isinstance(node, ast.VariableDeclaration):
        return node.variables + ([] if node.value is None else [node.value])
    elif isinstance(node, ast.Block):
        return node.statements
    elif isinstance(node, ast.FunctionDefinition):
        return node.parameters + node.return_variables + [node.body]
    elif isinstance(node, ast.If):
        return [node.condition, node.body] + (
            [] if node.else_body is None else [node.else_body]
        )
    elif isinstance(node, ast.Case):
        return [node.value, node.body]
    elif isinstance(node, ast.Switch):
        return node.cases + [node.expression]
    elif isinstance(node, ast.ForLoop):
        return [node.pre, node.condition, node.post, node.body]
    else:
        return []


class AstVisitor:
    def visit(self, node: ast.Node, *args, **kwargs):
        method_name = "visit_" + snakify(type(node).__name__)
        try:
            return getattr(self, method_name)(node, *args, **kwargs)
        except AttributeError:
            return self.common_visit(node, *args, **kwargs)

    def common_visit(self, node, *args, **kwargs):
        for child in get_children(node):
            self.visit(child, *args, **kwargs)

    def visit_list(self, nodes: Iterable[ast.Node], *args, **kwargs) -> list:
        return [self.visit(x) for x in nodes]


class AstMapper(AstVisitor):
    def map(self, node: ast.Node, *args, **kwargs) -> ast.Node:
        return self.visit(node, *args, **kwargs)

    def visit_typed_name(self, node: ast.TypedName):
        return node

    def visit_literal(self, node: ast.Literal):
        return node

    def visit_identifier(self, node: ast.Identifier):
        return node

    def visit_assignment(self, node: ast.Assignment):
        return ast.Assignment(
            variable_names=self.visit_list(node.variable_names),
            value=self.visit(node.value),
        )

    def visit_function_call(self, node: ast.FunctionCall):
        return ast.FunctionCall(
            function_name=self.visit(node.function_name),
            arguments=self.visit_list(node.arguments),
        )

    def visit_expression_statement(self, node: ast.ExpressionStatement):
        return ast.ExpressionStatement(self.visit(node.expression))

    def visit_variable_declaration(self, node: ast.VariableDeclaration):
        return ast.VariableDeclaration(
            variables=self.visit_list(node.variables),
            value=self.visit(node.value) if node.value is not None else None,
        )

    def visit_block(self, node: ast.Block):
        return ast.Block(tuple(self.visit_list(node.statements)))

    def visit_function_definition(self, node: ast.FunctionDefinition):
        return ast.FunctionDefinition(
            name=node.name,
            parameters=self.visit_list(node.parameters),
            return_variables=self.visit_list(node.return_variables),
            body=self.visit(node.body),
        )

    def visit_if(self, node: ast.If):
        return ast.If(
            condition=self.visit(node.condition),
            body=self.visit(node.body),
            else_body=self.visit(node.else_body)
            if node.else_body is not None
            else None,
        )

    def visit_case(self, node: ast.Case):
        return ast.Case(
            value=self.visit(node.value) if node.value is not None else None,
            body=self.visit(node.body),
        )

    def visit_switch(self, node: ast.Switch):
        return ast.Switch(
            expression=self.visit(node.expression),
            cases=self.visit_list(node.cases),
        )

    def visit_for_loop(self, node: ast.ForLoop):
        return ast.ForLoop(
            pre=self.visit(node.pre),
            condition=self.visit(node.condition),
            post=self.visit(node.post),
            body=self.visit(node.body),
        )

    def visit_break(self, node: ast.Break):
        return node

    def visit_continue(self, node: ast.Continue):
        return node

    def visit_leave(self, node: ast.Leave):
        return node
