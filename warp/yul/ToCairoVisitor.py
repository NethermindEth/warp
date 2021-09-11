from __future__ import annotations

from collections import defaultdict
from typing import Optional

import solcx
from starkware.cairo.lang.compiler.parser import parse_file

import yul.yul_ast as ast
from transpiler.Imports import merge_imports, UINT256_MODULE, format_imports
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


class ToCairoVisitor(AstVisitor):
    def __init__(self, sol_source: str):
        super().__init__()
        self.preamble: bool = False
        self.n_names: int = 0
        self.solc_version: float = self.get_source_version(sol_source)
        self.validate_solc_ver()
        self.public_functions = self.get_public_functions(sol_source)
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None

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

    def generate_ids_typed(self, variable_names, function_name: str = ""):
        variables = []
        for var in variable_names:
            var_repr = self.print(var)
            if "Uint256" not in var_repr:
                var_repr += ": Uint256"
            variables.append(var_repr)
        return ", ".join("local " + x for x in variables)

    def visit_assignment(self, node: ast.Assignment) -> str:
        self.preamble = False
        value_repr: str = self.print(node.value)
        if isinstance(node.value, ast.FunctionCall):
            function_name = node.value.function_name.name
            function_args: str = ", ".join(self.print(x) for x in node.value.arguments)
            ids_repr: str = self.generate_ids_typed(node.variable_names, function_name)
            self.preamble = True
            if function_name in YUL_BUILTINS_MAP:
                builtin_to_cairo = YUL_BUILTINS_MAP[function_name](function_args)
                merge_imports(self.imports, builtin_to_cairo.required_imports())
                if not node.variable_names:
                    return builtin_to_cairo.generated_cairo
                else:
                    return f"""{builtin_to_cairo.preamble}
let ({ids_repr}) = {builtin_to_cairo.function_call}
{builtin_to_cairo.ref_copy}"""
            else:
                if not node.variable_names:
                    return value_repr
                else:
                    ids_repr: str = ", ".join(
                        self.print(x) for x in node.variable_names
                    )
                    return f"let ({ids_repr}) = {value_repr}\n"

        else:
            ids_repr: str = self.generate_ids_typed(node.variable_names)
            self.preamble = True
            return f"{ids_repr} = {value_repr}"

    def visit_function_call(self, node: ast.FunctionCall) -> str:
        fun_repr = self.print(node.function_name)
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr == "revert":
            return "assert 0 = 1"
        elif fun_repr.startswith("checked_add"):
            merge_imports(self.imports, {"evm.uint256": {"u256_add"}})
            return f"u256_add({args_repr})"
        elif fun_repr in YUL_BUILTINS_MAP.keys():
            builtin_to_cairo = YUL_BUILTINS_MAP[fun_repr](args_repr)
            merge_imports(self.imports, builtin_to_cairo.required_imports())
            if self.preamble:
                return f"""{builtin_to_cairo.preamble}
{builtin_to_cairo.function_call}
{builtin_to_cairo.ref_copy}"""
            else:
                return f"{builtin_to_cairo.function_call}"
        else:
            return f"{fun_repr}({args_repr})"

    def visit_expression_statement(self, node: ast.ExpressionStatement) -> str:
        if isinstance(node.expression, ast.FunctionCall):
            return self.visit(node.expression)
        else:
            # see ast.ExpressionStatement docstring
            raise ValueError("What am I going to do with it? Why is it here?..")

    def visit_variable_declaration(self, node: ast.VariableDeclaration) -> str:
        self.preamble = False
        if node.value is None:
            decls_repr = "\n".join(
                self.print(ast.VariableDeclaration(variables=[x], value=ast.Literal(0)))
                for x in node.variables
            )
            self.preamble = True
            return decls_repr
        value_repr = self.print(node.value)
        if isinstance(node.value, ast.FunctionCall):
            function_name: str = node.value.function_name.name
            function_args: str = ", ".join(self.print(x) for x in node.value.arguments)
            func_call: str = self.print(node.value)
            vars_repr = self.generate_ids_typed(node.variables, function_name)
            if function_name in YUL_BUILTINS_MAP:
                builtin_to_cairo = YUL_BUILTINS_MAP[function_name](function_args)
                merge_imports(self.imports, builtin_to_cairo.required_imports())
                self.preamble = True
                if not node.variables:
                    return builtin_to_cairo.generated_cairo
                else:
                    return f"""{builtin_to_cairo.preamble}
let ({vars_repr}) = {builtin_to_cairo.function_call}
{builtin_to_cairo.ref_copy}"""
            else:
                if not node.variables:
                    return value_repr
                else:
                    if "mapping_index" in function_name:
                        return (
                            f"let ({vars_repr}) = {func_call}\n"
                            f"local range_check_ptr = range_check_ptr\n"
                            f"local memory_dict : DictAccess* = memory_dict\n"
                            f"local msize = msize"
                        )
                    else:
                        return f"let ({vars_repr}) = {func_call}"

        else:
            self.preamble = True
            vars_repr = self.generate_ids_typed(node.variables)
            return f"{vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        return "\n".join(self.print(x) for x in node.statements)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        taboos = ["abi_", "checked_add", "getter_"]
        if any(taboo in node.name for taboo in taboos):
            return ""
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        body_repr = self.print(node.body)
        external = node.name in self.public_functions
        external_function = self._make_external_function(node) if external else ""
        func = (
            f"func {node.name}"
            f"{{range_check_ptr, pedersen_ptr: HashBuiltin*"
            f", storage_ptr: Storage*, memory_dict: DictAccess*, msize}}"
            f"({params_repr}) -> ({returns_repr}):\n"
            f"alloc_locals\n"
            f"{body_repr}\n"
            f"end\n"
            f"{external_function}"
        )
        return parse_file(func).format()

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
        return (
            f"\n@external\n"
            f"func {node.name}_external"
            f"{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*}}"
            f"({params}) -> ({returns}):\n"
            f"let (memory_dict) = default_dict_new(0)\n"
            f"let msize = 0\n"
            f"{inner_assignment}\n"
            f"return ({split_returns})\n"
            f"end\n\n"
        )
