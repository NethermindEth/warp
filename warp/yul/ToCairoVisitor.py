from __future__ import annotations

import re
from collections import defaultdict
from contextlib import contextmanager
from typing import Optional

import yul.yul_ast as ast
from transpiler.Imports import merge_imports, format_imports
from yul.Artifacts import Artifacts
from yul.BuiltinHandler import YUL_BUILTINS_MAP
from yul.NameGenerator import NameGenerator
from yul.storage_access import (
    StorageVar,
    extract_var_from_getter,
    extract_var_from_setter,
    generate_getter_body,
    generate_setter_body,
    generate_storage_var_declaration,
)
from yul.utils import (
    UNSUPPORTED_BUILTINS,
    STORAGE_DECLS,
    get_public_functions,
    validate_solc_ver,
)
from yul.utils import (
    get_function_mutabilities,
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
    "evm.exec_env": {"ExecutionEnvironment"},
    "evm.utils": {"update_msize"},
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
    def __init__(
        self,
        sol_source: str,
        sol_src_path: str,
        main_contract: str,
        name_gen: NameGenerator,
    ):
        super().__init__()
        self.artifacts_manager = Artifacts(sol_src_path)
        self.artifacts_manager.write_artifact("MAIN_CONTRACT", main_contract)
        validate_solc_ver(sol_source)
        self.main_contract = main_contract
        self.public_functions = get_public_functions(sol_source)
        self.function_mutabilities: dict[str, str] = get_function_mutabilities(
            sol_source
        )
        self.name_gen = name_gen
        self.external_functions: list[str] = []
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.last_used_implicits: tuple[str] = ()
        self.function_to_implicits: dict[str, set[str]] = {}
        self.in_entry_function: bool = False
        self.storage_variables: set[StorageVar] = set()

    def translate(self, node: ast.Node) -> str:
        main_part = self.print(node)
        storage_var_decls = [
            generate_storage_var_declaration(x) for x in sorted(self.storage_variables)
        ]
        return "\n".join(
            [
                MAIN_PREAMBLE,
                format_imports(self.imports),
                "",
                *storage_var_decls,
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
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr == "revert" and not self.in_entry_function:
            return "assert 0 = 1\njmp rel 0"
        if fun_repr == "revert" and self.in_entry_function:
            return ""
        if fun_repr in UNSUPPORTED_BUILTINS:
            return "__warp_holder()"
        result: str
        if fun_repr in YUL_BUILTINS_MAP:
            builtin_to_cairo = YUL_BUILTINS_MAP[fun_repr](args_repr)
            merge_imports(self.imports, builtin_to_cairo.required_imports())
            self.last_used_implicits = builtin_to_cairo.used_implicits
            result = f"{builtin_to_cairo.function_call}"
        else:
            self.last_used_implicits = sorted(
                self.function_to_implicits.setdefault(
                    node.function_name.name, IMPLICITS_SET
                )
            )
            holder = list(self.last_used_implicits)
            holder.append("exec_env") if "exec_env" not in holder else None
            self.last_used_implicits = tuple(holder)
            if self.in_entry_function:
                result = ("with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, storage_ptr, syscall_ptr:\n"
                    f"{fun_repr}({args_repr})\n"
                    "end\n"
                )
            else:
                result = f"{fun_repr}({args_repr})"
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

        body_repr = self._try_make_storage_accessor_body(node)
        if not body_repr:
            body_repr = self.print(node.body)

        if node.name == "fun_ENTRY_POINT":
            self.in_entry_function = False
            return (
                "@external\n"
                f"func {node.name}{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"storage_ptr : Storage*, syscall_ptr : felt* }}(calldata_size,"
                f"calldata_len, calldata : felt*, init_address : felt) -> ({returns_repr}):\n"
                f"alloc_locals\n"
                f"let (address_init) = address_initialized.read()\n"
                f"if address_init == 1:\n"
                f"return ()\n"
                f"end\n"
                f"this_address.write(init_address)\n"
                f"address_initialized.write(1)\n"
                f"local range_check_ptr = range_check_ptr\n"
                f"local pedersen_ptr : HashBuiltin* = pedersen_ptr\n"
                f"local storage_ptr : Storage* = storage_ptr\n"
                f"local syscall_ptr : felt* = syscall_ptr\n"
                f"local exec_env : ExecutionEnvironment = ExecutionEnvironment("
                f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata)\n"
                "let (local memory_dict) = default_dict_new(0)\n"
                f"local memory_dict_start: DictAccess* = memory_dict\n"
                f"let msize = 0\n"
                f"{body_repr}\n"
                f"end\n"
            )

        implicits = sorted(self.function_to_implicits.setdefault(node.name, set()))
        implicits_decl = ""
        if implicits:
            implicits_decl = ", ".join(print_implicit(x) for x in implicits)
            implicits_decl = (
                "{exec_env : ExecutionEnvironment, " + implicits_decl
                if "exec_env" not in implicits_decl
                else "{" + implicits_decl
            )
            if not "range_check" in implicits_decl:
                implicits_decl += (
                    ", range_check_ptr}"
                    if len(implicits_decl) > 1
                    and implicits_decl != "{exec_env : ExecutionEnvironment, "
                    else "range_check_ptr}"
                )
            else:
                implicits_decl += "}"

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
        return_names = ", ".join(x.name for x in self.last_function.return_variables)
        return f"return ({return_names})"

    def _make_external_function(
        self, node: ast.FunctionDefinition, mutability: str
    ) -> str:
        params = ", ".join(self.print(x) for x in node.parameters)
        returns = ", ".join(self.print(x) for x in node.return_variables)
        inner_args = ", ".join(x.name for x in node.parameters)
        inner_returns = ", ".join(
            f"local {self.visit(x)}" for x in node.return_variables
        )
        inner_call = f"{node.name}({inner_args})"
        inner_assignment = (
            f"let ({inner_returns}) = {inner_call}"
            if node.return_variables
            else inner_call
        )
        external_returns = ", ".join(
            f"{x.name}={x.name}" for x in node.return_variables
        )
        self.external_functions.append(node.name)
        implicits = sorted(IMPLICITS_SET - {"msize", "memory_dict", "exec_env"})
        implicits_repr = ", ".join(print_implicit(x) for x in implicits)
        implicit_copy = "\n".join(copy_implicit(x) for x in implicits)

        inner_implicits = "memory_dict, msize"
        init_exec_env = ""
        if "exec_env" in self.function_to_implicits[node.name]:
            params += ", " if params else ""
            params += "calldata_size, calldata_len, calldata : felt*"
            init_exec_env = (
                f"local exec_env : ExecutionEnvironment ="
                f"ExecutionEnvironment(calldata_size=calldata_size,"
                f"calldata_len=calldata_len, calldata=calldata)\n"
            )
            inner_implicits += ", exec_env"
        return (
            f"\n@{mutability}\n"
            f"func {node.name}_external"
            f"{{{implicits_repr}}}"
            f"({params}) -> ({returns}):\n"
            f"alloc_locals\n"
            f"let (local memory_dict) = default_dict_new(0)\n"
            f"local memory_dict_start : DictAccess* = memory_dict\n"
            f"let msize = 0\n"
            f"{init_exec_env}"
            f"with {inner_implicits}:\n"
            f"  {inner_assignment}\n"
            f"end\n"
            f"{implicit_copy}\n"
            f"default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
            f"return ({external_returns})\n"
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

    def _try_make_storage_accessor_body(
        self, node: ast.FunctionDefinition
    ) -> Optional[str]:
        getter_var = extract_var_from_getter(node.name)
        setter_var = extract_var_from_setter(node.name)
        if not (getter_var or setter_var):
            return None

        self.function_to_implicits.setdefault(node.name, set()).update(
            ("storage_ptr", "pedersen_ptr", "range_check_ptr")
        )
        accessor_args = tuple(x.name for x in node.parameters)
        if getter_var:
            assert (
                len(node.return_variables) == 1
            ), "We don't support multivalued storage variables yet"
            name = getter_var
            arg_types = tuple(x.type for x in node.parameters)
            res_type = node.return_variables[0].type
            body = generate_getter_body(getter_var, accessor_args)
        else:
            assert setter_var
            assert (
                node.parameters
            ), "Storage variable setters must have at least one parameter (the value to set)"
            name = setter_var
            arg_types = tuple(x.type for x in node.parameters[:-1])
            res_type = node.parameters[-1].type
            body = generate_setter_body(setter_var, accessor_args)
        self.storage_variables.add(
            StorageVar(name=name, arg_types=arg_types, res_type=res_type)
        )
        return body


def print_implicit(name):
    type_ = IMPLICITS.get(name, None)
    if type_ is None:
        return name
    else:
        return f"{name}: {type_}"


def copy_implicit(name):
    return f"local {print_implicit(name)} = {name}"


def extract_function_name(name: str) -> Optional[str]:
    if name.startswith("getter"):
        return extract_var_from_getter(name)
    elif name.startswith("setter"):
        return extract_var_from_setter(name)
    else:
        fun_pattern = re.compile(r"fun_(\S*)(_(\d+))?")
        match = re.fullmatch(fun_pattern, name)
        if not match:
            return None
        return match.group(1)
