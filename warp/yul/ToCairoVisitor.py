from collections import defaultdict
from typing import Optional

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
    def __init__(self):
        super().__init__()
        self.preamble: bool = False
        self.n_names: int = 0
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None

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

    def visit_function_definition(self, node: ast.FunctionDefinition):
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        return_names = ", ".join(x.name for x in node.return_variables)
        body_repr = self.print(node.body)
        if "abi_" in node.name or "checked_" in node.name:
            return ""
        return (
            f"func {node.name}"
            f"{{range_check_ptr, pedersen_ptr: HashBuiltin*,"
            f"storage_ptr: Storage*, memory_dict: DictAccess*, msize}}"
            f"({params_repr}) -> ({returns_repr}):\n"
            f"alloc_locals\n"
            f"{body_repr}\n"
            f"return ({return_names})\n"
            f"end"
        )

    def visit_if(self, node: ast.If) -> str:
        cond_repr = self.print(node.condition)
        body_repr = self.print(node.body)
        else_repr = ""
        if node.else_body:
            else_repr = f"\t{self.print(node.else_body)}\n"
        return (
            f"if {cond_repr}.low + {cond_repr}.high != 0:\n"
            f"{body_repr}\n"
            f"{else_repr}\n"
            f"end"
        )

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
