from __future__ import annotations

from collections import defaultdict
from contextlib import contextmanager
import os
from typing import Optional

import yul.yul_ast as ast
from transpiler.Imports import merge_imports, format_imports
from yul.BuiltinHandler import YUL_BUILTINS_MAP
from yul.Artifacts import Artifacts
from yul.ExecEnv import NeedsExececutionEnvironment
from yul.utils import (
    STORAGE_DECLS,
    get_source_version,
    get_public_functions,
    validate_solc_ver,
)

from yul.yul_ast import AstVisitor

UINT128_BOUND = 2 ** 128

COMMON_IMPORTS = {
    "starkware.cairo.common.registers": {"get_fp_and_pc"},
    "starkware.cairo.common.dict_access": {"DictAccess"},
    "starkware.cairo.common.math_cmp": {"is_le"},
    "starkware.cairo.common.default_dict": {
        "default_dict_new",
        "default_dict_finalize",
    },
    "starkware.cairo.common.uint256": {"Uint256", "uint256_eq"},
    "starkware.cairo.common.cairo_builtins": {"HashBuiltin"},
    "starkware.starknet.common.storage": {"Storage"},
    "evm.utils": {"update_msize"},
    "evm.exec_env": {"ExecutionEnvironment"},
}

MAIN_PREAMBLE = """%lang starknet
%builtins pedersen range_check
"""

IMPLICITS = {
    "memory_dict": "DictAccess*",
    "msize": None,
    "pedersen_ptr": "HashBuiltin*",
    "range_check_ptr": None,
    "storage_ptr": "Storage*",
    "syscall_ptr": "felt*",
    "exec_env": "ExecutionEnvironment",
}

IMPLICITS_SET = set(IMPLICITS.keys())


class ToCairoVisitor(AstVisitor):
    def __init__(self, sol_source: str, sol_src_path: str, main_contract: str):
        super().__init__()
        self.artifacts_manager = Artifacts(sol_src_path)
        self.artifacts_manager.write_artifact("MAIN_CONTRACT", main_contract)
        self.solc_version: float = get_source_version(sol_source)
        validate_solc_ver(sol_source)
        self.code = sol_source
        self.main_contract = main_contract
        self.file_name = os.path.basename(sol_src_path)[:-4]
        self.public_functions = get_public_functions(sol_source)
        self.external_functions: list[str] = []
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.last_used_implicits: tuple[str] = ()
        self.function_to_implicits: dict[str, set[str]] = {}
        self.in_entry_function: bool = False
        self.exec_env_functions: list[str] = []
        self.cur_function: str = ""

    def translate(self, node: ast.Node) -> str:
        self.exec_env_functions = NeedsExececutionEnvironment().get_exec_env_functions(
            node
        )
        self.exec_env_functions = list(set(self.exec_env_functions))
        main_part = self.print(node)
        return "\n".join(
            [
                MAIN_PREAMBLE,
                format_imports(self.imports),
                STORAGE_DECLS,
                main_part,
            ]
        )

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
        if fun_repr == "revert" and not self.in_entry_function:
            return "assert 0 = 1\njmp rel 0"
        if fun_repr == "revert" and self.in_entry_function:
            return ""
        if fun_repr == "pop":
            return ""
        if "callvalue" in fun_repr:
            return "Uint256(0,0)"
        result: str
        if fun_repr in YUL_BUILTINS_MAP:
            builtin_to_cairo = YUL_BUILTINS_MAP[fun_repr](args_repr)
            merge_imports(self.imports, builtin_to_cairo.required_imports())
            self.last_used_implicits = builtin_to_cairo.used_implicits
            result = f"{builtin_to_cairo.function_call}"
        else:
            self.last_used_implicits = sorted(
                self.function_to_implicits.setdefault(
                    node.function_name.name, (IMPLICITS_SET - {"exec_env"})
                )
            )
            implicits_call = ", ".join(f"{x}={x}" for x in self.last_used_implicits)
            if (
                "exec_env" not in implicits_call
                and fun_repr in self.exec_env_functions
                and fun_repr != "__warp_block_00"
            ):
                implicits_call = "exec_env=exec_env, " + implicits_call
                self.last_used_implicits.append("exec_env")
            result = (
                f"{fun_repr}({args_repr})"
                if (implicits_call == "" or "return" in fun_repr)
                else f"{fun_repr}{{{implicits_call}}}({args_repr})"
            )
        self.function_to_implicits.setdefault(self.last_function.name, set()).update(
            self.last_used_implicits
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
        if not node.variables:
            return value_repr
        vars_repr = ", ".join(f"local {self.visit(x)}" for x in node.variables)
        if isinstance(node.value, ast.FunctionCall):
            if "calldatasize" in node.value.function_name.name:
                return f"{vars_repr} = {value_repr}"
            else:
                return f"let ({vars_repr}) = {value_repr}"
        else:
            assert len(node.variables) == 1
            return f"{vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        stmt_reprs = []
        for stmt in node.statements:
            with self._new_statement():
                stmt_reprs.append(self.visit(stmt))
                for implicit in self.last_used_implicits:
                    stmt_reprs.append(copy_implicit(implicit))
        return "\n".join(stmt_reprs)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        if "_dynArgs" in node.name:
            self.artifacts_manager.write_artifact(
                ".DynArgFunctions", node.name.replace("_dynArgs", "") + "\n"
            )
        if "ENTRY_POINT" in node.name:
            self.in_entry_function = True
        self.last_function = node
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        if "revert" in node.name:
            return ""
        body_repr = self.print(node.body)
        if "ENTRY_POINT" in node.name:
            self.in_entry_function = False
            return (
                "@external\n"
                f"func {node.name}{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"storage_ptr : Storage*, syscall_ptr : felt* }}(calldata_size,"
                f"calldata_len, calldata : felt*) -> ({returns_repr}):\n"
                f"alloc_locals\n"
                f"local exec_env : ExecutionEnvironment = ExecutionEnvironment("
                f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)\n"
                "let (local memory_dict) = default_dict_new(0)\n"
                f"local memory_dict_start: DictAccess* = memory_dict\n"
                "let msize = 0\n"
                f"{body_repr}\n"
                f"default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
                f"end\n"
            )

        external = node.name in self.public_functions
        external_function = self._make_external_function(node) if external else ""
        implicits = sorted(self.function_to_implicits.setdefault(node.name, set()))
        implicits_decl = ""
        if implicits:
            implicits_decl = ", ".join(print_implicit(x) for x in implicits)
            if (
                node.name in self.exec_env_functions
                and "exec_env" not in implicits
                and "block_00" not in node.name
            ):
                implicits_decl = "{exec_env : ExecutionEnvironment, " + implicits_decl
            else:
                implicits_decl = "{" + implicits_decl
            if not "range_check" in implicits_decl:
                implicits_decl += (
                    ", range_check_ptr}"
                    if len(implicits_decl) > 1
                    and implicits_decl != "{exec_env : ExecutionEnvironment, "
                    else "range_check_ptr}"
                )
            else:
                implicits_decl += "}"
        self.in_entry_function = False
        return (
            f"func {node.name}{implicits_decl}({params_repr}) -> ({returns_repr}):\n"
            f"alloc_locals\n"
            f"{body_repr}\n"
            f"end\n"
            f"{external_function}"
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

    def _make_external_function(self, node: ast.FunctionDefinition) -> str:
        params = ", ".join(self.print(x, split=True) for x in node.parameters)
        returns = ", ".join(self.print(x, split=True) for x in node.return_variables)
        inner_args = ", ".join(
            f"Uint256({x.name}_low, {x.name}_high)" for x in node.parameters
        )
        inner_returns = ", ".join(
            f"local {self.visit(x)}" for x in node.return_variables
        )
        inner_call = f"{node.name}({inner_args})"
        inner_assignment = (
            f"let ({inner_returns}) = {inner_call}"
            if node.return_variables
            else inner_call
        )
        split_returns = ", ".join(
            f"{x.name}.low, {x.name}.high" for x in node.return_variables
        )
        self.external_functions.append(node.name)
        implicits = sorted(IMPLICITS_SET - {"msize", "memory_dict", "exec_env"})
        implicits_repr = ", ".join(print_implicit(x) for x in implicits)
        implicit_copy = "\n".join(copy_implicit(x) for x in implicits)
        return (
            f"\n@external\n"
            f"func {node.name}_external"
            f"{{{implicits_repr}}}"
            f"({params}) -> ({returns}):\n"
            f"alloc_locals\n"
            f"let (local memory_dict) = default_dict_new(0)\n"
            f"local memory_dict_start : DictAccess* = memory_dict\n"
            f"let msize = 0\n"
            f"with memory_dict, msize:\n"
            f"  {inner_assignment}\n"
            f"end\n"
            f"{implicit_copy}\n"
            f"default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
            f"return ({split_returns})\n"
            f"end\n\n"
        )

    @contextmanager
    def _new_statement(self):
        old = self.last_used_implicits
        self.last_used_implicits = ()
        try:
            yield None
        finally:
            self.last_used_implicits = old


def print_implicit(name):
    type_ = IMPLICITS.get(name, None)
    if type_ is None:
        return name
    else:
        return f"{name}: {type_}"


def copy_implicit(name):
    return f"local {print_implicit(name)} = {name}"
