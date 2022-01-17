import pytest

import warp.yul.ast as ast
from warp.yul.BuiltinHandler import StaticHandler
from warp.yul.ExpressionSplitter import ExpressionSplitter
from warp.yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from warp.yul.NameGenerator import NameGenerator
from warp.yul.ToCairoVisitor import ToCairoVisitor


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
        name_gen=NameGenerator(),
        cairo_functions=CairoFunctions(FunctionGenerator()),
        builtins_map=lambda _: {
            "f1": StaticHandler("f1"),
            "f2": StaticHandler("f2"),
            "<": StaticHandler("<"),
        },
    ).print(new_node)
    assert cairo.splitlines() == [
        "let (__warp_subexpr_1 : Uint256) = f2()",
        "let (__warp_subexpr_0 : Uint256) = f1()",
        "let (res : Uint256) = <(__warp_subexpr_0, __warp_subexpr_1)",
    ]
