from __future__ import annotations

from collections import defaultdict
from contextlib import contextmanager
from typing import Optional

import yul.yul_ast as ast
from yul.BuiltinHandler import YUL_BUILTINS_MAP
from yul.yul_ast import AstVisitor

UINT128_BOUND = 2 ** 128


MAIN_PREAMBLE = """%lang starknet
%builtins pedersen range_check
"""


class NeedsExececutionEnvironment(AstVisitor):
    def __init__(self):
        super().__init__()
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.callgraph = {}
        self.needs_exec_env: list[str] = []
        self.visited: list[str] = []

    def traverse_callgraph(self, callgraph):
        for k, v in callgraph.items():
            stack = []
            stack.append(k)

            while len(stack):
                func = stack.pop()

                if func in self.visited:
                    continue

                if callgraph.get(func, {}).get("calldataOp"):
                    self.needs_exec_env.append(func)

                self.visited.append(func)
                stack.extend(v["calledFunctions"])

    def get_exec_env_functions(self, node: ast.Node) -> list[str]:
        self.print(node)
        self.traverse_callgraph(self.callgraph)
        return self.needs_exec_env

    def print(self, node: ast.Node, *args, **kwargs) -> str:
        return self.visit(node, *args, **kwargs)

    def common_visit(self, node: ast.Node, *args, **kwargs):
        raise AssertionError(
            f"Each node type should have a custom visit, but {type(node)} doesn't"
        )

    def visit_typed_name(self, node: ast.TypedName, split: bool = False) -> str:
        if not split:
            return f"{node.name} : {node.type}"
        assert node.type == "Uint256", "Can't split non Uin256 type"
        # could have added ": felt", but when a type is omitted, it's felt by default
        return f"{node.name}_low, {node.name}_high"

    def visit_literal(self, node: ast.Literal) -> str:
        v = int(node.value)  # to convert bools: True -> 1, False -> 0
        high, low = divmod(v, UINT128_BOUND)
        return f"Uint256(low={low}, high={high})"

    def visit_identifier(self, node: ast.Identifier) -> str:
        return f"{node.name}"

    def visit_assignment(self, node: ast.Assignment) -> str:
        return self.visit(
            ast.VariableDeclaration(
                variables=[ast.TypedName(x.name) for x in node.variable_names],
                value=node.value,
            )
        )

    def visit_function_call(self, node: ast.FunctionCall) -> str:
        fun_repr = self.print(node.function_name)
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr == "revert":
            return "assert 0 = 1\njmp rel 0"
        if fun_repr == "revert":
            return ""
        if "return" in fun_repr:
            return ""
        if fun_repr == "checked_add_uint256":
            fun_repr = "add"
        if "callvalue" in fun_repr:
            return "Uint256(0,0)"
        result: str
        if fun_repr in YUL_BUILTINS_MAP:
            builtin_to_cairo = YUL_BUILTINS_MAP[fun_repr](args_repr)
            self.callgraph[self.cur_function]["calledFunctions"].append(
                builtin_to_cairo.function_name
            )
            result = f"{builtin_to_cairo.function_call}"
        else:
            self.callgraph[self.cur_function]["calledFunctions"].append(fun_repr)
            result = f"{fun_repr}({args_repr})"

        return result

    def visit_expression_statement(self, node: ast.ExpressionStatement) -> str:
        if isinstance(node.expression, ast.FunctionCall):
            return self.visit(node.expression)
        else:
            # see ast.ExpressionStatement docstring
            raise ValueError("What am I going to do with it? Why is it here?..")

    def visit_variable_declaration(self, node: ast.VariableDeclaration) -> str:
        if node.value is None:
            decls_repr = "\n".join(
                self.print(ast.VariableDeclaration(variables=[x], value=ast.Literal(0)))
                for x in node.variables
            )
            return decls_repr
        value_repr = self.visit(node.value)
        if not node.variables:
            return value_repr
        vars_repr = ", ".join(f"local {self.visit(x)}" for x in node.variables)
        if isinstance(node.value, ast.FunctionCall):
            if "calldatasize" in node.value.function_name.name:
                return f"{vars_repr} = Uint256(exec_env.calldata_size, 0)"
            else:
                return f"let ({vars_repr}) = {value_repr}"
        else:
            assert len(node.variables) == 1
            return f"{vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        stmt_reprs = []
        for stmt in node.statements:
            stmt_reprs.append(self.visit(stmt))
        return "\n".join(stmt_reprs)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        taboos = ["checked_add"]
        if any(taboo in node.name for taboo in taboos):
            return ""
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        if "revert" in node.name:
            return ""
        self.cur_function = node.name
        self.callgraph[node.name] = {}
        self.callgraph[node.name]["calledFunctions"] = []
        body_repr = self.print(node.body)
        if "calldata" in body_repr:
            self.callgraph[node.name]["calldataOp"] = True
        else:
            self.callgraph[node.name]["calldataOp"] = False

        if "ENTRY_POINT" in node.name:
            return (
                "@external\n"
                f"func {node.name}{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"storage_ptr : Storage*, syscall_ptr : felt* }}(calldata_size,"
                f"calldata_len, calldata : felt*) -> ({returns_repr}):\n"
                f"alloc_locals\n"
                f"local exec_env : ExecutionEnvironment = ExecutionEnvironment("
                f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)\n"
                "let (memory_dict) = default_dict_new(0)\n"
                "let msize = 0\n"
                f"{body_repr}\n"
                f"end\n"
            )

        return (
            f"func {node.name}({params_repr}) -> ({returns_repr}):\n"
            f"alloc_locals\n"
            f"{body_repr}\n"
            f"end\n"
        )

    def visit_if(self, node: ast.If) -> str:
        cond_repr = self.print(node.condition)
        body_repr = self.print(node.body)
        else_repr = ""
        if node.else_body:
            else_repr = f"else:\n\t{self.print(node.else_body)}\n"
        return (
            f"if {cond_repr}.low + {cond_repr}.high != 0:\n"
            f"\t{body_repr}\n"
            f"{else_repr}"
            f"end"
        )

    def visit_case(self, node: ast.Case):
        return AssertionError("There should be no cases, run SwitchToIfVisitor first")

    def visit_switch(self, node: ast.Switch):
        return AssertionError(
            "There should be no switches, run SwitchToIfVisitor first"
        )

    def visit_for_loop(self, node: ast.ForLoop):
        raise AssertionError(
            "There should be no for loops, run ForLoopEliminator first"
        )

    def visit_break(self, node: ast.Break):
        raise AssertionError("There should be no breaks, run ForLoopEliminator first")

    def visit_continue(self, node: ast.Continue):
        raise AssertionError(
            "There should be no continues, run ForLoopEliminator first"
        )

    def visit_leave(self, _node: ast.Leave) -> str:
        return_names = ", ".join(x.name for x in self.last_function.return_variables)
        return f"return ({return_names})"
