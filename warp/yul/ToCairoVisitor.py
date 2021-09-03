from contextlib import contextmanager
from typing import Optional
from collections import deque

import yul.yul_ast as ast
from yul.AstVisitor import AstVisitor
from yul.WarpException import WarpException
from yul.utils import YUL_BUILTINS_MAP

UINT128_BOUND = 2 ** 128


class ToCairoVisitor(AstVisitor):
    def __init__(self):
        super().__init__()
        self.repr_stack: list[str] = []
        self.n_names: int = 0

    def translate(self, node: ast.Node) -> str:
        main_part = self.print(node)
        return main_part

    def print(self, node: ast.Node, *args, **kwargs) -> str:
        self.visit(node, *args, **kwargs)
        return self.repr_stack.pop()

    def common_visit(self, node: ast.Node, *args, **kwargs):
        raise AssertionError(
            f"Each node type should have a custom visit, but {type(node)} doesn't"
        )

    def visit_typed_name(self, node: ast.TypedName):
        self.repr_stack.append(f"{node.name} : {node.type}")

    def visit_literal(self, node: ast.Literal):
        v = int(node.value)  # to convert bools: True -> 1, False -> 0
        high, low = divmod(v, UINT128_BOUND)
        self.repr_stack.append(f"Uint256(low={low}, high={high})")

    def visit_identifier(self, node: ast.Identifier):
        self.repr_stack.append(f"{node.name}")

    def visit_assignment(self, node: ast.Assignment):
        ids_repr = ", ".join("local " + self.print(x) for x in node.variable_names)
        value_repr = self.print(node.value)
        if isinstance(node.value, ast.FunctionCall):
            if not node.variable_names:
                self.repr_stack.append(value_repr)
            else:
                self.repr_stack.append(f"let ({ids_repr}) = {value_repr}")
        else:
            self.repr_stack.append(f"{ids_repr} = {value_repr}")

    def visit_function_call(self, node: ast.FunctionCall):
        fun_repr = self.print(node.function_name)
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr in YUL_BUILTINS_MAP.keys():
            self.repr_stack.append(f"{YUL_BUILTINS_MAP[fun_repr]}({args_repr})")
        else:
            self.repr_stack.append(f"{fun_repr}({args_repr})")

    def visit_expression_statement(self, node: ast.ExpressionStatement):
        if isinstance(node.expression, ast.FunctionCall):
            self.visit(node.expression)
        else:
            # see ast.ExpressionStatement docstring
            raise ValueError("What am I going to do with it? Why is it here?..")

    def visit_variable_declaration(self, node: ast.VariableDeclaration):
        if node.value is None:
            decls_repr = "\n".join(
                self.print(ast.VariableDeclaration(variables=[x], value=ast.Literal(0)))
                for x in node.variables
            )
            self.repr_stack.append(decls_repr)
            return
        vars_repr = ", ".join("local " + self.print(x) for x in node.variables)
        value_repr = self.print(node.value)
        if isinstance(node.value, ast.FunctionCall):
            if not node.variables:
                self.repr_stack.append(value_repr)
            else:
                self.repr_stack.append(f"let ({vars_repr}) = {value_repr}")
        else:
            self.repr_stack.append(f"{vars_repr} = {value_repr}")

    def visit_block(self, node: ast.Block):
        stmts_repr = "\n".join(self.print(x) for x in node.statements)
        self.repr_stack.append(stmts_repr)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        return_names = ", ".join(x.name for x in node.return_variables)
        body_repr = self.print(node.body)
        self.repr_stack.append(
            f"func {node.name}({params_repr}) -> ({returns_repr}):\n"
            "alloc_locals\n"
            f"{body_repr}\n"
            f"return ({return_names})\n"
            "end\n"
        )

    def visit_if(self, node: ast.If):
        cond_repr = self.print(node.condition)
        body_repr = self.print(node.body)
        else_repr = ""
        if node.else_body:
            else_repr = f"\t{self.print(node.else_body)}\n"
        self.repr_stack.append(
            f"if {cond_repr}.low + {cond_repr}.high != 0:\n"
            f"\t{body_repr}\n"
            f"{else_repr}"
            f"end"
        )

    def visit_case(self, node: ast.Case):
        raise AssertionError("There should be no cases, run SwitchToIfVisitor first")

    def visit_switch(self, node: ast.Switch):
        raise AssertionError("There should be no switches, run SwitchToIfVisitor first")

    def visit_for_loop(self, node: ast.ForLoop):
        raise AssertionError("There should be no for loops, run ScopeFlattener first")

    def visit_break(self, node: ast.Break):
        self.repr_stack.append("")  # TODO

    def visit_continue(self, node: ast.Continue):
        self.repr_stack.append("")  # TODO

    def visit_leave(self, node: ast.Leave):
        self.repr_stack.append("")  # TODO
