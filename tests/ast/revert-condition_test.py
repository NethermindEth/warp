import pytest
from utils import check_ast

from warp.yul.BuiltinHandler import get_default_builtins
from warp.yul.ExpressionSplitter import ExpressionSplitter
from warp.yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from warp.yul.NameGenerator import NameGenerator
from warp.yul.RevertNormalizer import RevertNormalizer
from warp.yul.ScopeFlattener import ScopeFlattener


@check_ast(__file__)
def test_revert_condition(ast):
    name_gen = NameGenerator()
    builtins = get_default_builtins(CairoFunctions(FunctionGenerator()))
    ast = ExpressionSplitter(name_gen).map(ast)
    ast = RevertNormalizer(builtins).map(ast)
    ast = ScopeFlattener(name_gen).map(ast)

    return ast
