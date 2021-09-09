from __future__ import annotations
from collections import defaultdict
from typing import Optional

from starkware.cairo.lang.compiler.parser import parse_file
import solcx
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

# This means that a warp_block_x
# just reverts, so we can discard its definition and 
# replace its callsites with assert 0 = 1
DISCARD = """    assert 0 = 1
    return ()"""

IF_REF_COPY = """
tempvar range_check_ptr = range_check_ptr
tempvar pedersen_ptr : HashBuiltin* = pedersen_ptr
tempvar storage_ptr : Storage* = storage_ptr
tempvar msize = msize
tempvar memory_dict : DictAccess* = memory_dict
"""


class ToCairoVisitor(AstVisitor):
    def __init__(self, sol_source):
        super().__init__()
        self.preamble: bool = False
        self.n_names: int = 0
        self.sol_source: str = sol_source
        self.solc_version: float = self.get_source_version(sol_source)
        self.validate_solc_ver()
        self.public_functions = self.get_public_functions(self.sol_source)
        self.imports = defaultdict(set)
        self.discarded_warp_blocks: list[str] = []
        self.external_cairo_funcs: dict[str, dict[str, str]] = {}
        self.current_function_ret_vars_len: int = 0
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

    def should_ignore(self, function_name: str) -> bool:
        return (
            "abi_" in function_name
            or "checked_" in function_name
            or "panic_error" in function_name
            or "increment_uint" in function_name
            or "decrement_uint" in function_name
            or "getter_" in function_name
        )

    def visit_typed_name(self, node: ast.TypedName) -> str:
        return f"{node.name} : {node.type}"

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

    def remove_generated_call(self, args_repr: str, function_name: str) -> str:
        if "checked_add" in function_name:
            return f"u256_add({args_repr})"
        elif "checked_sub" in function_name:
            return f"uint256_sub({args_repr})"
        elif "revert" in function_name:
            return f"assert 0 = 1"
        elif "increment_uint256" in function_name:
            return f"u256_add({args_repr}, 1)"
        elif "decrement_uint256" in function_name:
            return f"uint256_sub({args_repr}, 1)"
        else:
            return f"{function_name}({args_repr})"

    def visit_assignment(self, node: ast.Assignment) -> str:
        self.preamble = False
        value_repr: str = self.print(node.value)
        if isinstance(node.value, ast.FunctionCall):
            function_name = node.value.function_name.name
            function_args: str = ", ".join(self.print(x) for x in node.value.arguments)
            ids_repr: str = self.generate_ids_typed(node.variable_names, function_name)
            self.preamble = True
            if function_name in YUL_BUILTINS_MAP.keys():
                builtin_to_cairo = YUL_BUILTINS_MAP[function_name](function_args)
                merge_imports(self.imports, builtin_to_cairo.required_imports())
                if not node.variable_names:
                    return builtin_to_cairo.generated_cairo
                else:
                    return f"""{builtin_to_cairo.preamble}
let ({ids_repr}) = {builtin_to_cairo.function_call}
{builtin_to_cairo.ref_copy}"""
            else:
                call = self.remove_generated_call(function_args, function_name)
                if not node.variable_names:
                    return value_repr
                elif function_name in self.external_cairo_funcs:
                    ids_repr_felt = self.to_high_low_felt(ids_repr)
                    return f"let ({ids_repr_felt}) = {call}\n" + self.init_u256(
                        ids_repr
                    )
                else:
                    return f"let ({ids_repr}) = {call}"
        else:
            ids_repr: str = self.generate_ids_typed(node.variable_names)
            self.preamble = True
            return f"{ids_repr} = {value_repr}"

    def visit_function_call(self, node: ast.FunctionCall) -> str:
        fun_repr = self.print(node.function_name)
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr in self.external_cairo_funcs:
            args_repr = self.to_high_low_felt(args_repr)
        if fun_repr == "revert":
            return "assert 0 = 1"
        elif fun_repr.startswith("checked_add"):
            merge_imports(self.imports, {"evm.uint256": {"u256_add"}})
            return f"u256_add({args_repr})"
        elif fun_repr.startswith("checked_sub"):
            merge_imports(self.imports, {UINT256_MODULE: {"uint256_sub"}})
            return f"uint256_sub({args_repr})"
        elif fun_repr in self.discarded_warp_blocks or "panic_error" in fun_repr:
            return "assert 0 = 1"
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
                    if function_name in self.external_cairo_funcs:
                        vars_repr_felt = self.to_high_low_felt(vars_repr)
                        return (
                            f"let ({vars_repr_felt}) = {function_name}({self.to_high_low_felt(function_args)})\n"
                            + self.init_u256(vars_repr)
                        )
                    elif "mapping_index" in function_name:
                        return f"""let ({vars_repr}) = {function_name}({function_args})
local range_check_ptr = range_check_ptr
local memory_dict : DictAccess* = memory_dict
local msize = msize"""
                    return f"let ({vars_repr}) = {value_repr}"
        else:
            self.preamble = True
            vars_repr = self.generate_ids_typed(node.variables)
            return f"{vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        return "\n".join(self.print(x) for x in node.statements)

    def to_high_low_felt(self, vars: str) -> str:
        if vars != "":
            vars = vars.replace(" : Uint256", "")
            vars = vars.split(",")
            params_repr = ", ".join(f"{p.strip()}_low, {p.strip()}_high" for p in vars)
            return params_repr
        else:
            return vars

    def init_u256(self, params_repr: str) -> str:
        params = params_repr.replace(" : Uint256", "")
        params = params.split(",")
        declr_str = ""
        for p in params:
            if "local" in p:
                p_no_local = p.replace("local", "").strip()
                declr_str += (
                    f"{p}: Uint256 = Uint256({p_no_local}_low, {p_no_local}_high)\n"
                )
            else:
                declr_str += f"local {p}: Uint256 = Uint256({p}_low, {p}_high)\n"
        return declr_str

    def gen_external_return_names(self, names: str) -> str:
        if names != "":
            vars = names.replace(" : Uint256", "")
            vars = vars.split(",")
            params_repr = ", ".join(f"{p.strip()}.low, {p.strip()}.high" for p in vars)
            return params_repr
        else:
            return names

    def gen_external_function_def(
        self,
        fun_name: str,
        params_repr: str,
        return_repr: str,
        return_names_repr: str,
        body: str,
    ) -> str:
        body = self.init_u256(params_repr) + "\n" + body
        params = self.to_high_low_felt(params_repr)
        return_signature = self.to_high_low_felt(return_repr)
        return_names = self.gen_external_return_names(return_names_repr)
        self.external_cairo_funcs[fun_name] = {"return_names": return_names}
        if self.current_function_ret_vars_len == 0:
            assignment = f"""{fun_name}{{range_check_ptr=range_check_ptr,
            pedersen_ptr=pedersen_ptr,
            storage_ptr=storage_ptr,
            memory_dict=memory_dict,
            msize=msize}}({params})"""
        else:
            assignment = f"""let ({return_signature}) = {fun_name}{{range_check_ptr=range_check_ptr,
            pedersen_ptr=pedersen_ptr,
            storage_ptr=storage_ptr,
            memory_dict=memory_dict,
            msize=msize}}({params})"""
        return f"""
func {fun_name}{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*, memory_dict : DictAccess*, msize}}({params}) -> ({return_signature}):
alloc_locals
{body}
return ({return_names})
end

@external
func {fun_name}_external{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*}}({params}) -> ({return_signature}):
alloc_locals
let (local memory_dict : DictAccess*) = default_dict_new(0)
tempvar msize = 0
{assignment}
return ({return_signature})
end
"""

    def to_high_low_felt(self, vars: str) -> str:
        if vars != "":
            vars = vars.replace(" : Uint256", "")
            vars = vars.split(",")
            params_repr = ", ".join(f"{p.strip()}_low, {p.strip()}_high" for p in vars)
            return params_repr
        else:
            return vars

    def init_u256(self, params_repr: str) -> str:
        params = params_repr.replace(" : Uint256", "")
        params = params.split(",")
        declr_str = ""
        for p in params:
            if "local" in p:
                p_no_local = p.replace("local", "").strip()
                declr_str += (
                    f"{p}: Uint256 = Uint256({p_no_local}_low, {p_no_local}_high)\n"
                )
            else:
                declr_str += f"local {p}: Uint256 = Uint256({p}_low, {p}_high)\n"
        return declr_str

    def gen_external_return_names(self, names: str) -> str:
        if names != "":
            vars = names.replace(" : Uint256", "")
            vars = vars.split(",")
            params_repr = ", ".join(f"{p.strip()}.low, {p.strip()}.high" for p in vars)
            return params_repr
        else:
            return names

    def gen_external_function_def(
        self,
        fun_name: str,
        params_repr: str,
        return_repr: str,
        return_names_repr: str,
        body: str,
    ) -> str:
        body = self.init_u256(params_repr) + "\n" + body
        params = self.to_high_low_felt(params_repr)
        return_signature = self.to_high_low_felt(return_repr)
        return_names = self.gen_external_return_names(return_names_repr)
        self.external_cairo_funcs[fun_name] = {"return_names": return_names}
        if self.current_function_ret_vars_len == 0:
            assignment = f"""{fun_name}{{range_check_ptr=range_check_ptr,
            pedersen_ptr=pedersen_ptr,
            storage_ptr=storage_ptr,
            memory_dict=memory_dict,
            msize=msize}}({params})"""
        else:
            assignment = f"""let ({return_signature}) = {fun_name}{{range_check_ptr=range_check_ptr,
            pedersen_ptr=pedersen_ptr,
            storage_ptr=storage_ptr,
            memory_dict=memory_dict,
            msize=msize}}({params})"""
        return f"""
func {fun_name}{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*, memory_dict : DictAccess*, msize}}({params}) -> ({return_signature}):
alloc_locals
{body}
return ({return_names})
end

@external
func {fun_name}_external{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*}}({params}) -> ({return_signature}):
alloc_locals
let (local memory_dict : DictAccess*) = default_dict_new(0)
tempvar msize = 0
{assignment}
return ({return_signature})
end
"""

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        if "panic_error" in node.name:
            return
        if node.name in self.public_functions:
            # must split into high/low bits
            self.current_function_ret_vars_len = len(node.return_variables) * 2
            self.curr_fun_ret_felt = True
        else:
            self.current_function_ret_vars_len = len(node.return_variables)
            self.curr_fun_ret_felt = False

        return_names = ", ".join(x.name for x in node.return_variables)
        if node.name in self.public_functions:
            # must split into high/low bits
            self.current_function_ret_vars_len = len(node.return_variables) * 2
            self.curr_fun_ret_felt = True
        else:
            self.current_function_ret_vars_len = len(node.return_variables)
            self.curr_fun_ret_felt = False
        body_repr = self.print(node.body)
        if self.should_ignore(node.name):
            return ""
        elif node.name in self.public_functions:
            return self.gen_external_function_def(
                node.name, params_repr, returns_repr, return_names, body_repr
            )
        else:
            func = f"""
func {node.name}{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*, memory_dict: DictAccess*, msize}}({params_repr}) -> ({returns_repr}):
alloc_locals
{body_repr}
end
            """
            func = parse_file(func).format()
            if ("__warp_block" in node.name) and (DISCARD in func):
                self.discarded_warp_blocks.append(node.name)
                return ""
            else:
                return (
                    f"func {node.name}"
                    f"{{range_check_ptr, pedersen_ptr: HashBuiltin*"
                    f", storage_ptr: Storage*, memory_dict: DictAccess*, msize}}"
                    f"({params_repr}) -> ({returns_repr}):\n"
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

    def visit_leave(self, node: ast.Leave) -> str:
        return_names = ", ".join(x.name for x in self.last_function.return_variables)
        return f"return ({return_names})"
