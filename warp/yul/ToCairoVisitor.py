from __future__ import annotations
from collections import defaultdict

import solcx
from transpiler.Imports import merge_imports, UINT256_MODULE
import yul.yul_ast as ast
from yul.BuiltinHandler import YUL_BUILTINS_MAP

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


class ToCairoVisitor(ast.AstVisitor):
    def __init__(self, sol_source: str):
        super().__init__()
        self.repr_stack: list[str] = []
        self.preamble: bool = False
        self.n_names: int = 0
        self.sol_source: str = sol_source
        self.solc_version: float = self.get_source_version(sol_source)
        self.validate_solc_ver()
        self.public_functions = self.get_public_functions(self.sol_source)
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.cairo_code: str = ""

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
        return main_part

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
                if not node.variable_names:
                    return value_repr
                else:
                    return f"let ({ids_repr}) = {value_repr}"
        else:
            ids_repr: str = self.generate_ids_typed(node.variable_names)
            self.preamble = True
            return f"{ids_repr} = {value_repr}"

    def visit_function_call(self, node: ast.FunctionCall) -> str:
        fun_repr = self.print(node.function_name)
        args_repr = ", ".join(self.print(x) for x in node.arguments)
        if fun_repr == "revert":
            return "assert 0 = 1"
        if fun_repr.startswith("checked_add"):
            merge_imports(self.imports, {"evm.uint256": {"u256_add"}})
            return f"u256_add({args_repr})"
        if fun_repr.startswith("checked_sub"):
            merge_imports(self.imports, {UINT256_MODULE: {"uint256_sub"}})
            return f"uint256_sub({args_repr})"
        if fun_repr in YUL_BUILTINS_MAP.keys():
            builtin_to_cairo = YUL_BUILTINS_MAP[fun_repr](args_repr)
            merge_imports(self.imports, builtin_to_cairo.required_imports())
            if self.preamble:
                return f"""{builtin_to_cairo.preamble}
{builtin_to_cairo.function_call}
{builtin_to_cairo.ref_copy}"""
            else:
                return f"{builtin_to_cairo.function_call}"
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
            vars_repr = self.generate_ids_typed(node.variables, function_name)
            if function_name in YUL_BUILTINS_MAP.keys():
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
                    return f"let ({vars_repr}) = {value_repr}"
        else:
            vars_repr = self.generate_ids_typed(node.variables)
            self.preamble = True
            return f"{vars_repr} = {value_repr}"

    def visit_block(self, node: ast.Block) -> str:
        stmts_repr = ""
        for stmt in node.statements:
            try:
                stmts_repr += self.print(stmt) + "\n"
            except:
                continue
        return stmts_repr

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
        declr_str = "\n".join(
            f"let (local {p}: Uint256) = Uint256({p}_low, {p}_high)" for p in params
        )
        return declr_str

    def gen_external_function(
        self,
        fun_name: str,
        params_repr: str,
        return_repr: str,
        return_names: str,
        body: str,
    ) -> str:
        body = self.init_u256(params_repr) + body
        params = self.to_high_low_felt(params_repr)
        return_signature = self.to_high_low_felt(return_repr)
        return_names = self.to_high_low_felt(return_names)
        return f"""
@external
func {fun_name}{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*, memory_dict: DictAccess*, msize}}({params}) -> ({return_signature}):
alloc_locals
{body}
return ({return_names})
end"""

    def visit_function_definition(self, node: ast.FunctionDefinition):
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        return_names = ", ".join(x.name for x in node.return_variables)
        body_repr = self.print(node.body)
        if "abi_" in node.name or "checked_" in node.name:
            return ""
        if node.name in self.public_functions:
            self.cairo_code += self.gen_external_function(
                node.name, params_repr, returns_repr, return_names, body_repr
            )
        else:
            self.cairo_code += f"""
func {node.name}{{range_check_ptr, pedersen_ptr: HashBuiltin*, storage_ptr: Storage*, memory_dict: DictAccess*, msize}}({params_repr}) -> ({returns_repr}):
alloc_locals
{body_repr}
return ({return_names})
end"""

    def visit_if(self, node: ast.If) -> str:
        cond_repr = self.print(node.condition)
        body_repr = self.print(node.body)
        else_repr = ""
        if node.else_body:
            else_repr = f"\t{self.print(node.else_body)}\n"
        return f"""if {cond_repr}.low + {cond_repr}.high != 0:
{body_repr}
{else_repr}
end"""

    def visit_case(self, node: ast.Case):
        return ""

    def visit_switch(self, node: ast.Switch):
        return ""

    def visit_for_loop(self, node: ast.ForLoop):
        return ""

    def visit_break(self, node: ast.Break):
        return ""

    def visit_continue(self, node: ast.Continue):
        return ""

    def visit_leave(self, node: ast.Leave):
        return ""
