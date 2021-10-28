from __future__ import annotations

import re
from collections import defaultdict
from contextlib import contextmanager
from typing import Callable, Optional

import yul.yul_ast as ast
from yul.AstVisitor import AstVisitor
from yul.BuiltinHandler import BuiltinHandler
from yul.FunctionGenerator import CairoFunctions
from yul.implicits import IMPLICITS_SET, copy_implicit, print_implicit
from yul.Imports import format_imports, merge_imports
from yul.NameGenerator import NameGenerator
from yul.storage_access import (
    StorageVar,
    extract_var_from_getter,
    extract_var_from_setter,
    generate_getter_body,
    generate_setter_body,
    generate_storage_var_declaration,
)
from yul.utils import HANDLERS_DECL

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
    "starkware.cairo.common.alloc": {"alloc"},
    "evm.exec_env": {"ExecutionEnvironment"},
}

MAIN_PREAMBLE = """%lang starknet
%builtins pedersen range_check bitwise
"""


class ToCairoVisitor(AstVisitor):
    def __init__(
        self,
        public_functions: list[str],
        name_gen: NameGenerator,
        cairo_functions: CairoFunctions,
        builtins_map: Callable[[CairoFunctions], dict[str, BuiltinHandler]],
    ):
        super().__init__()
        self.public_functions = public_functions
        self.name_gen = name_gen
        self.cairo_functions = cairo_functions
        self.builtins_map = builtins_map(self.cairo_functions)
        self.dynamic_argument_functions: list[str] = []
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.last_function: Optional[ast.FunctionDefinition] = None
        self.last_used_implicits: tuple[str, ...] = ()
        self.function_to_implicits: dict[str, set[str]] = {}
        self.in_entry_function: bool = False
        self.storage_variables: set[StorageVar] = set()

    def translate(self, node: ast.Node) -> str:
        main_part = self.print(node)
        storage_vars = self.storage_variables | self.cairo_functions.storage_vars
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
                HANDLERS_DECL,
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
        if isinstance(node.value, str):
            string = node.value + "\0" * (32 - len(node.value))
            return f"Uint256('{string[16: 32]}', '{string[:16]}')"
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
        if fun_repr == "revert" and not self.in_entry_function:
            return "assert 0 = 1\njmp rel 0"
        if fun_repr == "revert" and self.in_entry_function:
            return ""
        if fun_repr == "pop":
            return ""
        result: str
        builtin_handler = self.builtins_map.get(fun_repr)
        if builtin_handler:
            merge_imports(self.imports, builtin_handler.required_imports())
            self.last_used_implicits = builtin_handler.get_used_implicits()
            if self.in_entry_function and "mstore" in fun_repr:
                result = (
                    f"with memory_dict, msize, range_check_ptr:\n"
                    f"{builtin_handler.get_function_call(args)}\n"
                    f"end\n"
                )
            else:
                result = f"{builtin_handler.get_function_call(args)}"
        else:
            self.last_used_implicits = sorted(
                self.function_to_implicits.setdefault(
                    node.function_name.name, IMPLICITS_SET
                )
            )
            args_repr = ", ".join(self.print(x) for x in node.arguments)
            if self.in_entry_function and "__warp_if_" in fun_repr:
                result = (
                    f"with exec_env, memory_dict, msize, pedersen_ptr, range_check_ptr, syscall_ptr:\n"
                    f"{fun_repr}({args_repr})\n"
                    f"end\n"
                )
            else:
                result = f"{fun_repr}({args_repr})"
        if self.last_function:
            self.function_to_implicits.setdefault(
                self.last_function.name, set()
            ).update(self.last_used_implicits)
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
        params_repr = ", ".join(self.print(x) for x in node.parameters)
        returns_repr = ", ".join(self.print(x) for x in node.return_variables)
        body_repr = self._try_make_storage_accessor_body(node)
        if not body_repr:
            body_repr = self.print(node.body)
        if "_DynArgs" in node.name:
            if node.name == "fun_warp_constructor_DynArgs":
                self.dynamic_argument_functions.append("constructor")
            else:
                self.dynamic_argument_functions.append(node.name)
        if node.name == "fun_warp_constructor":
            return (
                f"@constructor\n"
                f"func constructor{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"syscall_ptr : felt* , bitwise_ptr : BitwiseBuiltin*}}({params_repr}):\n"
                f"alloc_locals\n"
                f"let (local memory_dict) = default_dict_new(0)\n"
                f"local memory_dict_start: DictAccess* = memory_dict\n"
                f"let msize = 0\n"
                f"with pedersen_ptr, range_check_ptr, bitwise_ptr, memory_dict, msize:\n"
                f"{body_repr}\n"
                f"end\n"
                f"end"
            )
        elif node.name == "fun_warp_constructor_DynArgs":
            return (
                f"@constructor\n"
                f"func constructor{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"syscall_ptr : felt* , bitwise_ptr : BitwiseBuiltin*}}(calldata_size,"
                f"calldata_len, calldata : felt*):\n"
                f"alloc_locals\n"
                f"local pedersen_ptr : HashBuiltin* = pedersen_ptr\n"
                f"local range_check_ptr = range_check_ptr\n"
                f"local syscall_ptr : felt* = syscall_ptr\n"
                f"let (returndata_ptr: felt*) = alloc()\n"
                f"let (local __fp__, _) = get_fp_and_pc()\n"
                f"local exec_env_ : ExecutionEnvironment = ExecutionEnvironment("
                f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata,"
                f"returndata_size=0, returndata_len=0, returndata=returndata_ptr,"
                f"to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)\n"
                f"let exec_env : ExecutionEnvironment* = &exec_env_\n"
                f"let (local memory_dict) = default_dict_new(0)\n"
                f"local memory_dict_start: DictAccess* = memory_dict\n"
                f"let msize = 0\n"
                f"with pedersen_ptr, range_check_ptr, bitwise_ptr, memory_dict, msize, exec_env:\n"
                f"{body_repr}\n"
                f"end\n"
                f"end\n"
            )

        if node.name == "fun_ENTRY_POINT":
            # The leave gets replaced with the wrong return type in this case
            # we need to replace it with our return
            body_repr = re.sub("return \(\)$", "", body_repr)
            returns_repr = "success: felt, returndata_size: felt, returndata_len: felt, returndata: felt*"
            self.in_entry_function = False
            return (
                "@external\n"
                f"func {node.name}{{pedersen_ptr : HashBuiltin*, range_check_ptr,"
                f"syscall_ptr : felt* , bitwise_ptr : BitwiseBuiltin*}}(calldata_size,"
                f"calldata_len, calldata : felt*, self_address : felt) -> ({returns_repr}):\n"
                f"alloc_locals\n"
                f"let (local __fp__, _) = get_fp_and_pc()\n"
                f"initialize_address{{range_check_ptr=range_check_ptr, syscall_ptr=syscall_ptr, pedersen_ptr=pedersen_ptr}}(self_address)\n"
                f"local pedersen_ptr : HashBuiltin* = pedersen_ptr\n"
                f"local range_check_ptr = range_check_ptr\n"
                f"local syscall_ptr : felt* = syscall_ptr\n"
                f"let (returndata_ptr: felt*) = alloc()\n"
                f"local exec_env_ : ExecutionEnvironment = ExecutionEnvironment("
                f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata,"
                f"returndata_size=0, returndata_len=0, returndata=returndata_ptr,"
                f"to_returndata_size=0, to_returndata_len=0, to_returndata=returndata_ptr)\n"
                f"let exec_env : ExecutionEnvironment* = &exec_env_\n"
                f"let (local memory_dict) = default_dict_new(0)\n"
                f"local memory_dict_start: DictAccess* = memory_dict\n"
                f"let msize = 0\n"
                f"with exec_env, msize, memory_dict:\n"
                f"  {body_repr}\n"
                f"end\n"
                f"default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
                f"return (1, exec_env.to_returndata_size, exec_env.to_returndata_len, exec_env.to_returndata)\n"
                f"end\n"
            )

        implicits = sorted(self.function_to_implicits.setdefault(node.name, set()))
        implicits_decl = ""
        if implicits:
            implicits_decl = "{" + ", ".join(print_implicit(x) for x in implicits) + "}"
        self.in_entry_function = False
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
            ("pedersen_ptr", "range_check_ptr", "syscall_ptr")
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
