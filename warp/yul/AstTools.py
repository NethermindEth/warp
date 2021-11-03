from __future__ import annotations

import re
from typing import List, Optional

import yul.yul_ast as ast
from yul.AstVisitor import AstVisitor
from yul.WarpException import WarpException


class AstPrinter(AstVisitor):
    def format(self, node: ast.Node, tabs: int = 0) -> str:
        res = self.visit(node, tabs)
        return "\n".join(res)

    def visit_typed_name(self, node: ast.TypedName, tabs: int) -> List(str):
        node_type = "\t" * tabs + "TypedName:"
        res = "\t" * (tabs + 1) + f"{node.name}:{node.type}"
        return [node_type, res]

    def visit_literal(self, node: ast.Literal, tabs: int) -> List(str):
        return ["\t" * tabs + f"Literal:{node.value}"]

    def visit_identifier(self, node: ast.Identifier, tabs: int) -> List(str):
        return ["\t" * tabs + f"Identifier:{node.name}"]

    def visit_assignment(self, node: ast.Assignment, tabs: int) -> List(str):
        res = ["\t" * tabs + "Assignment:"]
        res.append("\t" * (tabs + 1) + "Variables:")
        for item in self.visit_list(node.variable_names, tabs + 2):
            res.extend(item)
        res.append("\t" * (tabs + 1) + "Value:")
        res.extend(self.visit(node.value, tabs + 2))
        return res

    def visit_function_call(self, node: ast.FunctionCall, tabs: int) -> List(str):
        res = ["\t" * tabs + "FunctionCall:"]
        res.extend(self.visit(node.function_name, tabs + 1))
        for item in self.visit_list(node.arguments, tabs + 1):
            res.extend(item)
        return res

    def visit_expression_statement(
        self, node: ast.ExpressionStatement, tabs: int
    ) -> List(str):
        res = ["\t" * tabs + "ExpressionStatement:"]
        res.extend(self.visit(node.expression, tabs + 1))
        return res

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration, tabs: int
    ) -> List(str):
        res = ["\t" * tabs + "VariableDeclaration:"]
        res.append("\t" * (tabs + 1) + "Variables:")
        for item in self.visit_list(node.variables, tabs + 2):
            res.extend(item)

        if node.value is not None:
            res.append("\t" * (tabs + 1) + "Value:")
            res.extend(self.visit(node.value, tabs + 2))
        else:
            res.append("\t" * (tabs + 1) + "Value: None")

        return res

    def visit_block(self, node: ast.Block, tabs: int) -> List(str):
        res = ["\t" * tabs + "Block:"]
        for item in self.visit_list(node.statements, tabs + 1):
            res.extend(item)
        return res

    def visit_function_definition(
        self, node: ast.FunctionDefinition, tabs: int
    ) -> List(str):
        res = ["\t" * tabs + "FunctionDefinition:"]
        res.append("\t" * (tabs + 1) + f"Name: {node.name}")
        res.append("\t" * (tabs + 1) + "Parameters:")
        for item in self.visit_list(node.parameters, tabs + 2):
            res.extend(item)
        res.append("\t" * (tabs + 1) + "Return Variables:")
        for item in self.visit_list(node.return_variables, tabs + 2):
            res.extend(item)
        res.append("\t" * (tabs + 1) + "Body:")
        res.extend(self.visit(node.body, tabs + 2))
        return res

    def visit_if(self, node: ast.If, tabs: int) -> List(str):
        res = ["\t" * tabs + "If:"]
        res.extend(self.visit(node.condition, tabs + 1))
        res.extend(self.visit(node.body, tabs + 1))
        if node.else_body is not None:
            res.extend(self.visit(node.else_body, tabs + 1))
        return res

    def visit_case(self, node: ast.Case, tabs: int) -> List(str):
        res = ["\t" * tabs + "Case:"]
        if node.value is not None:
            res.extend(self.visit(node.value, tabs + 1))
        else:
            res.append("\t" * (tabs + 1) + "Default")
        res.extend(self.visit(node.body, tabs + 1))
        return res

    def visit_switch(self, node: ast.Switch, tabs: int) -> List(str):
        res = ["\t" * tabs + "Switch:"]
        res.extend(self.visit(node.expression, tabs + 1))
        for item in self.visit_list(node.cases, tabs + 1):
            res.extend(item)
        return res

    def visit_for_loop(self, node: ast.ForLoop, tabs: int) -> List(str):
        res = ["\t" * tabs + "ForLoop:"]
        res.extend(self.visit(node.pre, tabs + 1))
        res.extend(self.visit(node.condition, tabs + 1))
        res.extend(self.visit(node.post, tabs + 1))
        res.extend(self.visit(node.body, tabs + 1))
        return res

    def visit_break(self, node: ast.Break, tabs: int) -> List(str):
        return ["\t" * tabs + "Break"]

    def visit_continue(self, node: ast.Continue, tabs: int) -> List(str):
        return ["\t" * tabs + "Continue"]

    def visit_leave(self, node: ast.Leave, tabs: int) -> List(str):
        return ["\t" * tabs + "Leave"]


class AstParser:
    def __init__(self, text: str):
        self.lines = text.splitlines()
        if len(self.lines) == 0:
            raise WarpException("Text should not be empty")
        self.pos = 0

    def parse_typed_name(self) -> ast.TypedName:
        tabs = self.get_tabs()
        node_type_name = self.get_word(tabs)
        assert node_type_name == "TypedName:", "This node should be of type TypedNode"
        self.pos += 1

        assert self.get_tabs() == tabs + 1, "Wrong indentation"
        node_name, node_type = self.get_word(tabs + 1).split(":")
        self.pos += 1

        return ast.TypedName(name=node_name, type=node_type)

    def parse_literal(self) -> ast.Literal:
        tabs = self.get_tabs()
        assert self.get_word(tabs).startswith(
            "Literal:"
        ), "This node should be of type Literal"
        value = self.get_word(tabs + 8)
        self.pos += 1

        try:
            value = int(value)
        except ValueError:
            pass

        return ast.Literal(value=value)

    def parse_identifier(self) -> ast.Identifier:
        tabs = self.get_tabs()
        assert self.get_word(tabs).startswith(
            "Identifier:"
        ), "This node should be of type Identifier"
        name = self.get_word(tabs + 11)
        self.pos += 1

        return ast.Identifier(name=name)

    def parse_assignment(self) -> ast.Assignment:
        tabs = self.get_tabs()
        assert (
            self.get_word(tabs) == "Assignment:"
        ), "This node should be of type Assignment"
        self.pos += 1
        assert self.get_word(tabs + 1) == "Variables:"
        self.pos += 1

        variables_list = self.parse_list(tabs + 1, self.parse_identifier)
        assert self.get_word(tabs + 1) == "Value:"
        self.pos += 1

        return ast.Assignment(
            variable_names=variables_list, value=self.parse_expression()
        )

    def parse_function_call(self) -> ast.FunctionCall:
        tabs = self.get_tabs()
        assert (
            self.get_word(tabs) == "FunctionCall:"
        ), "This node should be of type FunctionCall"
        self.pos += 1

        return ast.FunctionCall(
            function_name=self.parse_identifier(),
            arguments=self.parse_list(tabs, self.parse_expression),
        )

    def parse_expression_statement(self) -> ast.Statement:
        tabs = self.get_tabs()
        assert (
            self.get_word(tabs) == "ExpressionStatement:"
        ), "This node should be of type ExpressionStatement"
        self.pos += 1

        return ast.ExpressionStatement(expression=self.parse_expression())

    def parse_variable_declaration(self) -> ast.VariableDeclaration:
        tabs = self.get_tabs()
        assert (
            self.get_word(tabs) == "VariableDeclaration:"
        ), "This node should be of type VariableDeclaration"
        self.pos += 1

        assert self.get_tabs() == tabs + 1
        assert self.get_word(tabs + 1) == "Variables:"
        self.pos += 1
        variables = self.parse_list(tabs + 1, self.parse_typed_name)

        assert self.get_tabs() == tabs + 1
        word = self.get_word(tabs + 1)
        self.pos += 1
        assert word.startswith("Value")
        if word.endswith("None"):
            value = None
        else:
            value = self.parse_expression()

        return ast.VariableDeclaration(variables=variables, value=value)

    def parse_block(self) -> ast.Block:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Block:", "This node should be of type Block"
        self.pos += 1

        return ast.Block(statements=self.parse_list(tabs, self.parse_statement))

    def parse_function_definition(self) -> ast.FunctionDefinition:
        tabs = self.get_tabs()
        assert (
            self.get_word(tabs) == "FunctionDefinition:"
        ), "This node should be of type FunctionDefinition"
        self.pos += 1

        assert self.get_tabs() == tabs + 1 and self.get_word(tabs + 1).startswith(
            "Name:"
        )
        fun_name = self.get_word(tabs + 7)
        self.pos += 1

        assert self.get_tabs() == tabs + 1 and self.get_word(tabs + 1) == "Parameters:"
        self.pos += 1
        params = self.parse_list(tabs + 1, self.parse_typed_name)

        assert (
            self.get_tabs() == tabs + 1
            and self.get_word(tabs + 1) == "Return Variables:"
        )
        self.pos += 1

        returns = self.parse_list(tabs + 1, self.parse_typed_name)

        assert self.get_tabs() == tabs + 1 and self.get_word(tabs + 1) == "Body:"
        self.pos += 1
        body = self.parse_block()

        return ast.FunctionDefinition(
            name=fun_name, parameters=params, return_variables=returns, body=body
        )

    def parse_if(self) -> ast.If:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "If:", "This node should be of type If"
        self.pos += 1

        condition = self.parse_expression()
        body = self.parse_block()
        else_body = None
        if self.get_tabs() > tabs:
            else_body = self.parse_block()

        return ast.If(condition=condition, body=body, else_body=else_body)

    def parse_case(self) -> ast.Case:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Case:", "This node should be of type Case"
        self.pos += 1

        try:
            value = self.parse_literal()
        except AssertionError:
            assert (
                self.get_tabs() == tabs + 1 and self.get_word(tabs + 1) == "Default"
            ), "The value must be a literal or None (when it's the default case)"
            value = None
            self.pos += 1

        return ast.Case(value=value, body=self.parse_block())

    def parse_switch(self) -> ast.Switch:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Switch:", "This node should be of type Switch"
        self.pos += 1

        return ast.Switch(
            expression=self.parse_expression(),
            cases=self.parse_list(tabs, self.parse_case),
        )

    def parse_for_loop(self) -> ast.ForLoop:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "ForLoop:", "This node should be of type ForLoop"
        self.pos += 1

        return ast.ForLoop(
            pre=self.parse_block(),
            condition=self.parse_expression(),
            post=self.parse_block(),
            body=self.parse_block(),
        )

    def parse_break(self) -> ast.Break:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Break", "This node should be of type Break"
        self.pos += 1

        return ast.Break()

    def parse_continue(self) -> ast.Continue:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Continue", "This node should be of type Continue"
        self.pos += 1

        return ast.Continue()

    def parse_leave(self) -> ast.Leave:
        tabs = self.get_tabs()
        assert self.get_word(tabs) == "Leave", "This node should be of type Leave"
        self.pos += 1

        return ast.LEAVE, pos

    def parse_node(self) -> ast.Node:
        tabs = self.get_tabs()
        node_type_name = self.get_word(tabs).split(":")[0]

        parser_name = f"parse_{self.get_name(node_type_name)}"
        parser = getattr(self, parser_name, None)
        if parser is None:
            raise WarpException("Wrong node type name!")
        return parser()

    def parse_statement(self) -> ast.Statement:
        statements = [
            "ExpressionStatement",
            "Assignment",
            "VariableDeclaration",
            "FunctionDefinition",
            "If",
            "Switch",
            "ForLoop",
            "Break",
            "Continue",
            "Leave",
            "Block",
        ]

        tabs = self.get_tabs()
        node_type_name = self.get_word(tabs).split(":")[0]
        assert node_type_name in statements, "Not a valid statement"

        return self.parse_node()

    def parse_expression(self) -> ast.Expression:
        tabs = self.get_tabs()
        node_type_name = self.get_word(tabs).split(":")[0]
        assert node_type_name in [
            "Literal",
            "Identifier",
            "FunctionCall",
        ], "Node type must be an expression"

        return self.parse_node()

    def parse_list(self, tabs, parser):
        items = []
        while self.pos < len(self.lines) and self.get_tabs() > tabs:
            item = parser()
            items.append(item)

        return items

    def get_tabs(self):
        tabs = 0
        if self.pos < len(self.lines):
            for c in self.lines[self.pos]:
                if not c == "\t":
                    break
                tabs += 1
            else:
                raise WarpException(
                    "Lines are not supposed to be filled only with tabs"
                )

        return tabs

    def get_word(self, start: int) -> str:
        return self.lines[self.pos][start:]

    def get_name(self, name):
        name = "_".join(re.findall("[A-Z][^A-Z]*", name))
        return name.lower()
