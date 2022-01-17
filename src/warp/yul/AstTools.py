from __future__ import annotations

import re
from typing import Union

import warp.yul.ast as ast
from warp.yul.AstVisitor import AstVisitor
from warp.yul.WarpException import WarpException


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

        return ast.Block(statements=tuple(self.parse_list(tabs, self.parse_statement)))

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

        return ast.LEAVE

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
        return ast.assert_statement(self.parse_node())

    def parse_expression(self) -> ast.Expression:
        tabs = self.get_tabs()
        node_type_name = self.get_word(tabs).split(":")[0]
        assert node_type_name in [
            "Literal",
            "Identifier",
            "FunctionCall",
        ], "Node type must be an expression"
        return ast.assert_expression(self.parse_node())

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


class YulPrinter(AstVisitor):
    def format(self, node: ast.Node, tabs: int = 0) -> str:
        return self.visit(node, tabs)

    def visit_typed_name(self, node: ast.TypedName, tabs: int = 0) -> str:
        return f"{node.name}"

    def visit_literal(self, node: ast.Literal, tabs: int = 0) -> str:
        return f"{node.value}"

    def visit_identifier(self, node: ast.Identifier, tabs: int = 0) -> str:
        return f"{node.name}"

    def visit_assignment(self, node: ast.Assignment, tabs: int = 0) -> str:
        variables = ", ".join(self.visit_list(node.variable_names))
        value = self.visit(node.value, 0)
        return f"{variables} := {value}"

    def visit_function_call(self, node: ast.FunctionCall, tabs: int = 0) -> str:
        name = self.visit(node.function_name)
        args = ", ".join(self.visit_list(node.arguments))
        return f"{name}({args})"

    def visit_expression_statement(
        self, node: ast.ExpressionStatement, tabs: int = 0
    ) -> str:
        return self.visit(node.expression, tabs)

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration, tabs: int = 0
    ) -> str:
        variables = ", ".join(self.visit_list(node.variables))

        value = ""
        if node.value is not None:
            value = f" := {self.visit(node.value)}"

        return f"let {variables}{value}"

    def visit_block(self, node: ast.Block, tabs: int = 0) -> str:
        open_block = "{"
        close_block = "}"
        if self.is_short(node.statements):
            statements = "".join(self.visit_list(node.statements))
            return " ".join([open_block, statements, close_block])

        statements = self.visit_list(node.statements, tabs + 1)
        statements = ["\t" * (tabs + 1) + stmt for stmt in statements]
        statements = "\n".join(statements)
        close_block = "\t" * tabs + close_block
        res = "\n".join([open_block, statements, close_block])

        return res

    def visit_function_definition(
        self, node: ast.FunctionDefinition, tabs: int = 0
    ) -> str:
        parameters = ", ".join(self.visit_list(node.parameters, 0))
        ret_vars = ", ".join(self.visit_list(node.return_variables, 0))
        body = self.visit(node.body, tabs)

        res = f"function {node.name}({parameters})"
        if len(node.return_variables) > 0:
            res += f" -> {ret_vars}"
        res += f" {body}"
        return res

    def visit_if(self, node: ast.If, tabs: int = 0) -> str:
        res = f"if {self.visit(node.condition)} "
        res += self.visit(node.body, tabs)
        if node.else_body is not None:
            res += "\n" + "\t" * tabs + "else "
            res += self.visit(node.else_body, tabs)
        return res

    def visit_case(self, node: ast.Case, tabs: int = 0) -> str:
        res = "\t" * tabs
        if node.value is not None:
            res += f"case {self.visit(node.value)} "
        else:
            res += "default "
        res += self.visit(node.body, tabs)
        return res

    def visit_switch(self, node: ast.Switch, tabs: int = 0) -> str:
        res = f"switch {self.visit(node.expression)}\n"
        res += "\n".join(self.visit_list(node.cases, tabs))
        return res

    def visit_for_loop(self, node: ast.ForLoop, tabs: int = 0) -> str:
        res = "for "
        res += self.visit(node.pre, tabs)
        res += f" {self.visit(node.condition)} "
        res += self.visit(node.post, tabs)
        res += f"\n{self.visit(node.body, tabs)}"
        return res

    def visit_break(self, node: ast.Break, tabs: int = 0) -> str:
        return "break"

    def visit_continue(self, node: ast.Continue, tabs: int = 0) -> str:
        return "continue"

    def visit_leave(self, node: ast.Leave, tabs: int = 0) -> str:
        return "leave"

    def is_short(self, stmts: tuple) -> bool:
        if len(stmts) == 0:
            return True
        return len(stmts) == 1 and type(stmts[0]).__name__ not in [
            "Block",
            "FunctionDefinition",
            "If",
            "Switch",
            "ForLoop",
        ]
