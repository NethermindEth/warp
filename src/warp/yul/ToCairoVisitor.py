from __future__ import annotations

from collections import defaultdict
from contextlib import contextmanager
from typing import Callable, Mapping, Optional

import warp.yul.ast as ast
from warp.yul.AstVisitor import AstVisitor
from warp.yul.BuiltinHandler import BuiltinHandler
from warp.yul.FunctionGenerator import CairoFunctions
from warp.yul.implicits import (
    IMPLICITS_SET,
    MANUAL_IMPLICITS,
    finalize_manual_implicit,
    initialize_manual_implicit,
    print_implicit,
)
from warp.yul.Imports import format_imports, merge_imports
from warp.yul.NameGenerator import NameGenerator
from warp.yul.storage_access import generate_storage_var_declaration

UINT128_BOUND = 2 ** 128

COMMON_IMPORTS = {
    "starkware.cairo.common.registers": {"get_fp_and_pc"},
    "starkware.cairo.common.dict_access": {"DictAccess"},
    "starkware.cairo.common.default_dict": {
        "default_dict_new",
        "default_dict_finalize",
    },
    "starkware.cairo.common.uint256": {"Uint256"},
    "starkware.cairo.common.cairo_builtins": {
        "HashBuiltin",
        "BitwiseBuiltin",
    },
    "evm.array": {"validate_array"},
    "evm.exec_env": {"ExecutionEnvironment"},
}

MAIN_PREAMBLE = """%lang starknet
%builtins pedersen range_check bitwise
"""


class ToCairoVisitor(AstVisitor):
    def __init__(
        self,
        name_gen: NameGenerator,
        cairo_functions: CairoFunctions,
        builtins_map: Callable[[CairoFunctions], Mapping[str, BuiltinHandler]],
    ):
        super().__init__()
        self.name_gen = name_gen
        self.cairo_functions = cairo_functions
        self.builtins_map = builtins_map(self.cairo_functions)
        self.imports: defaultdict[str, set[str]] = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.last_used_implicits: tuple[str, ...] = ()
        self.function_to_implicits: dict[str, set[str]] = {}
        self.next_stmt_is_leave: bool = False

    def translate(self, node: ast.Node) -> str:
        main_part = self.print(node)
        storage_vars = self.cairo_functions.storage_vars
        storage_var_decls = [
            generate_storage_var_declaration(x) for x in sorted(storage_vars)
        ]
        return "\n".join(
            [
                MAIN_PREAMBLE,
                format_imports(self.imports),
                "",
                *self.cairo_functions.get_definitions(),
                "",
                *storage_var_decls,
                self._make_constructor(),
                self._make_main(),
                main_part,
            ]
        )

    def print(self, node: ast.Node, *args, **kwargs) -> str:
        return self.visit(node, *args, **kwargs)

    def common_visit(self, node: ast.Node, *args, **kwargs):
        raise AssertionError(
            f"Each node type should have a custom visit, but {type(node)} doesn't"
        )

    def visit_typed_name(self, node: ast.TypedName) -> str:
        return f"{node.name} : {node.type}"

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
        args = [self.print(x) for x in node.arguments]
        if fun_repr == "revert":
            return "assert 0 = 1\njmp rel 0"
        if fun_repr == "pop":
            return ""
        result: str
        builtin_handler = self.builtins_map.get(fun_repr)
        if builtin_handler:
            result = builtin_handler.get_function_call(args)
            merge_imports(self.imports, builtin_handler.required_imports())
            self.last_used_implicits = builtin_handler.get_used_implicits()
        else:
            self.last_used_implicits = self._get_implicits(node.function_name.name)
            args_repr = ", ".join(self.print(x) for x in node.arguments)
            result = f"{fun_repr}({args_repr})"
        if self.last_function:
            self._add_implicits(self.last_function.name, *self.last_used_implicits)
            if self.next_stmt_is_leave:
                return result
            if "termination_token" in self.last_used_implicits:
                n_returns = len(self.last_function.return_variables)
                dummy_returns = ", ".join("Uint256(0, 0)" for _ in range(n_returns))
                return (
                    result
                    + f"\nif termination_token == 1:\nreturn ({dummy_returns})\nend"
                )
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
        vars_repr = ", ".join(f"{self.visit(x)}" for x in node.variables)
        if isinstance(node.value, ast.FunctionCall):
            return f"let ({vars_repr}) = {value_repr}"
        else:
            assert len(node.variables) == 1
            return f"let {vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        stmt_reprs = []
        for i, stmt in enumerate(node.statements):
            self.next_stmt_is_leave = False
            if i < len(node.statements) - 1:
                self.next_stmt_is_leave = isinstance(node.statements[i + 1], ast.Leave)
            with self._new_statement():
                stmt_reprs.append(self.visit(stmt))
        return "\n".join(stmt_reprs)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        body_repr = self.print(node.body)
        implicits = sorted(self.function_to_implicits.setdefault(node.name, set()))
        implicits_decl = ""
        if implicits:
            implicits_decl = "{" + ", ".join(print_implicit(x) for x in implicits) + "}"
        return (
            f"func {node.name}{implicits_decl}({params_repr}) -> ({returns_repr}):\n"
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
        assert self.last_function
        return_names = ", ".join(x.name for x in self.last_function.return_variables)
        return f"return ({return_names})"

    @contextmanager
    def _new_statement(self):
        old = self.last_used_implicits
        self.last_used_implicits = ()
        try:
            yield None
        finally:
            self.last_used_implicits = old

    def _add_implicits(self, fn_name: str, *implicits: str):
        self.function_to_implicits.setdefault(fn_name, set()).update(implicits)

    def _get_implicits(self, fn_name: str) -> tuple[str, ...]:
        return tuple(
            sorted(self.function_to_implicits.setdefault(fn_name, IMPLICITS_SET))
        )

    def _make_constructor(self):
        ctor_implicits = frozenset(self.function_to_implicits.get("__constructor_meat"))
        ctor_implicits |= {"range_check_ptr"}  # for validate_array
        assert ctor_implicits, "The '__constructor_meat' function is not generated"
        manual_implicits = sorted(ctor_implicits & MANUAL_IMPLICITS)
        builtin_implicits = sorted(ctor_implicits - MANUAL_IMPLICITS)

        builtins_str = "{" + ", ".join(map(print_implicit, builtin_implicits)) + "}"
        manuals_str = ", ".join(manual_implicits)
        manuals_init = "".join(map(initialize_manual_implicit, manual_implicits))
        manuals_fin = "".join(map(finalize_manual_implicit, manual_implicits))
        if not manual_implicits:
            meat = "__constructor_meat()"
        else:
            meat = f"with {manuals_str}:\n__constructor_meat()\nend"

        return (
            f"@constructor\n"
            f"func constructor{builtins_str}(calldata_size, calldata_len, calldata : felt*):\n"
            f"alloc_locals\n"
            f"validate_array(calldata_size, calldata_len, calldata)\n"
            f"{manuals_init}"
            f"{meat}\n"
            f"{manuals_fin}"
            f"return ()\n"
            f"end\n"
        )

    def _make_main(self):
        main_implicits = frozenset(self.function_to_implicits.get("__main_meat"))
        main_implicits |= {"range_check_ptr"}  # for validate_array
        assert main_implicits, "The '__main_meat' function is not generated"
        manual_implicits = sorted(main_implicits & MANUAL_IMPLICITS)
        builtin_implicits = sorted(main_implicits - MANUAL_IMPLICITS)

        builtins_str = "{" + ", ".join(map(print_implicit, builtin_implicits)) + "}"
        manuals_str = ", ".join(manual_implicits)
        manuals_init = "".join(map(initialize_manual_implicit, manual_implicits))
        manuals_fin = "".join(map(finalize_manual_implicit, manual_implicits))
        if not manual_implicits:
            meat = "__main_meat()"
        else:
            meat = f"with {manuals_str}:\n__main_meat()\nend"
        if "exec_env" in manual_implicits:
            returns = "(exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)"
        else:
            returns = "(0, 0, cast(0, felt*))"

        return (
            f"@external\n"
            f"func __main{builtins_str}(calldata_size, calldata_len, calldata : felt*)"
            f"-> (returndata_size, returndata_len, returndata: felt*):\n"
            f"alloc_locals\n"
            f"validate_array(calldata_size, calldata_len, calldata)\n"
            f"{manuals_init}"
            f"{meat}\n"
            f"{manuals_fin}"
            f"return {returns}\n"
            f"end\n"
        )
