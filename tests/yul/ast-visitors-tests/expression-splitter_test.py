import pytest
import yul.yul_ast as ast
from yul.Artifacts import DUMMY_ARTIFACTS
from yul.ExpressionSplitter import ExpressionSplitter
from yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from yul.main import generate_from_yul
from yul.NameGenerator import NameGenerator
from yul.ToCairoVisitor import ToCairoVisitor


@pytest.mark.asyncio
async def test_ExpressionSplitter():
    lt = ast.Identifier("<")
    f1 = ast.Identifier("f1")
    f2 = ast.Identifier("f2")
    node = ast.VariableDeclaration(
        variables=[ast.TypedName("res")],
        value=ast.FunctionCall(
            lt, [ast.FunctionCall(f1, []), ast.FunctionCall(f2, [])]
        ),
    )
    block = ast.Block((node,))  # to create new block env
    new_node = ExpressionSplitter(name_gen=NameGenerator()).visit_block(block)
    cairo = ToCairoVisitor(
        main_contract="dummy",
        public_functions=[],
        function_mutabilities={},
        name_gen=NameGenerator(),
        artifacts_manager=DUMMY_ARTIFACTS,
        cairo_functions=CairoFunctions(FunctionGenerator()),
    ).print(new_node)
    assert cairo.splitlines() == [
        "let (local __warp_subexpr_1 : Uint256) = f2()",
        "local bitwise_ptr: BitwiseBuiltin* = bitwise_ptr",
        "local memory_dict: DictAccess* = memory_dict",
        "local msize = msize",
        "local pedersen_ptr: HashBuiltin* = pedersen_ptr",
        "local range_check_ptr = range_check_ptr",
        "local storage_ptr: Storage* = storage_ptr",
        "local syscall_ptr: felt* = syscall_ptr",
        "let (local __warp_subexpr_0 : Uint256) = f1()",
        "local bitwise_ptr: BitwiseBuiltin* = bitwise_ptr",
        "local memory_dict: DictAccess* = memory_dict",
        "local msize = msize",
        "local pedersen_ptr: HashBuiltin* = pedersen_ptr",
        "local range_check_ptr = range_check_ptr",
        "local storage_ptr: Storage* = storage_ptr",
        "local syscall_ptr: felt* = syscall_ptr",
        "let (local res : Uint256) = <(__warp_subexpr_0, __warp_subexpr_1)",
        "local bitwise_ptr: BitwiseBuiltin* = bitwise_ptr",
        "local memory_dict: DictAccess* = memory_dict",
        "local msize = msize",
        "local pedersen_ptr: HashBuiltin* = pedersen_ptr",
        "local range_check_ptr = range_check_ptr",
        "local storage_ptr: Storage* = storage_ptr",
        "local syscall_ptr: felt* = syscall_ptr",
    ]
