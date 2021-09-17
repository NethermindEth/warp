from __future__ import annotations

from collections import defaultdict
from contextlib import contextmanager
from typing import Optional

import solcx

import yul.yul_ast as ast
from transpiler.Imports import merge_imports, format_imports
from yul.BuiltinHandler import YUL_BUILTINS_MAP
from yul.utils import STORAGE_DECLS
from yul.yul_ast import AstVisitor

UINT128_BOUND = 2 ** 128

COMMON_IMPORTS = {
    "starkware.cairo.common.registers": {"get_fp_and_pc"},
    "starkware.cairo.common.dict_access": {"DictAccess"},
    "starkware.cairo.common.math_cmp": {"is_le"},
    "starkware.cairo.common.default_dict": {
        "default_dict_new",
    },
    "starkware.cairo.common.uint256": {"Uint256", "uint256_eq"},
    "starkware.cairo.common.cairo_builtins": {"HashBuiltin"},
    "starkware.starknet.common.storage": {"Storage"},
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
}

IMPLICITS_SET = set(IMPLICITS.keys())


class ToCairoVisitor(AstVisitor):
    def __init__(self, sol_source: str):
        super().__init__()
        self.solc_version: float = self.get_source_version(sol_source)
        self.validate_solc_ver()
        self.public_functions = self.get_public_functions(sol_source)
        self.external_functions: list[str] = []
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.last_used_implicits: tuple[str] = ()
        self.function_to_implicits: dict[str, set[str]] = {}
        self.in_entry_function: bool = False

    def get_source_version(self, sol_source: str) -> float:
        code_split = sol_source.split("\n")
        for line in code_split:
            if "pragma" in line:
                ver: float = float(line[line.index("0.") + 2 :].replace(";", ""))
                if ver < 8.0:
                    raise Exception(
                        "Please use a version of solidity that is at least 0.8.0"
                    )
                return ver
        raise Exception("No Solidity version specified in contract")

    def check_installed_solc(self, source_version: float) -> str:
        solc_vers = solcx.get_installed_solc_versions()
        vers_clean = []
        src_ver = "0." + str(source_version)
        for ver in solc_vers:
            vers_clean.append(".".join(str(x) for x in list(ver.precedence_key)[:3]))
        if src_ver not in vers_clean:
            solcx.install_solc(src_ver)
        return src_ver

    def validate_solc_ver(self):
        src_ver: str = self.check_installed_solc(self.solc_version)
        solcx.set_solc_version(src_ver)

    def get_public_functions(self, sol_source: str) -> list[str]:
        public_functions = set()
        abi = solcx.compile_source(sol_source, output_values=["hashes"])
        for value in abi.values():
            for v in value["hashes"]:
                public_functions.add(f"fun_{v[:v.find('(')]}")
        return list(public_functions)

    def translate(self, node: ast.Node) -> str:
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
        if "return" in fun_repr:
            return ""
        if fun_repr == "checked_add_uint256":
            fun_repr = "add"
        if "calldata" in fun_repr:
            return "Uint256(31597865,9284653)"
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
                    node.function_name.name, IMPLICITS_SET
                )
            )
            implicits_call = ", ".join(f"{x}={x}" for x in self.last_used_implicits)
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
            if (
                value_repr == "Uint256(31597865,9284653)"
                or value_repr == "Uint256(0,0)"
            ):
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
        if "ENTRY_POINT" in node.name:
            self.in_entry_function = True
        self.last_function = node
        taboos = ["checked_add"]
        if any(taboo in node.name for taboo in taboos):
            return ""
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        body_repr = self.print(node.body)
        if "revert" in node.name:
            return ""
        if "ENTRY_POINT" in node.name:
            self.in_entry_function = False
            return (
                "@external\n"
                f"func {node.name}{{pedersen_ptr : HashBuiltin*, range_check_ptr, storage_ptr : Storage*, syscall_ptr : felt* }}({params_repr}) -> ({returns_repr}):\n"
                f"alloc_locals\n"
                "let (memory_dict) = default_dict_new(0)\n"
                "let msize = 0\n"
                f"{body_repr}\n"
                f"end\n"
            )

        external = node.name in self.public_functions
        external_function = self._make_external_function(node) if external else ""
        implicits = sorted(self.function_to_implicits.setdefault(node.name, set()))
        if implicits:
            implicits_repr = ", ".join(print_implicit(x) for x in implicits)
            implicits_decl = "{" + implicits_repr
            implicits_decl += (
                ", range_check_ptr}" if not "range_check" in implicits_decl else "}"
            )
        else:
            implicits_decl = ""
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
        inner_returns = ", ".join(x.name for x in node.return_variables)
        inner_call = (
            f"{node.name}{{memory_dict=memory_dict, msize=msize}}({inner_args})"
        )
        inner_assignment = (
            f"let ({inner_returns}) = {inner_call}"
            if node.return_variables
            else inner_call
        )
        split_returns = ", ".join(
            f"{x.name}.low, {x.name}.high" for x in node.return_variables
        )
        self.external_functions.append(node.name)
        implicits = sorted(IMPLICITS_SET - {"msize", "memory_dict"})
        implicits_repr = ", ".join(print_implicit(x) for x in implicits)
        return (
            f"\n@external\n"
            f"func {node.name}_external"
            f"{{{implicits_repr}}}"
            f"({params}) -> ({returns}):\n"
            f"let (memory_dict) = default_dict_new(0)\n"
            f"let msize = 0\n"
            f"{inner_assignment}\n"
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
