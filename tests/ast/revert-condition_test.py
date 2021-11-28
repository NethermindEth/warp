import pytest
from utils import check_ast
from yul.BuiltinHandler import get_default_builtins
from yul.ExpressionSplitter import ExpressionSplitter
from yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from yul.NameGenerator import NameGenerator
from yul.RevertNormalizer import RevertNormalizer
from yul.ScopeFlattener import ScopeFlattener


@check_ast(__file__)
def test_revert_condition(yul_ast):
    name_gen = NameGenerator()
    builtins = get_default_builtins(CairoFunctions(FunctionGenerator()))
    yul_ast = ExpressionSplitter(name_gen).map(yul_ast)
    yul_ast = RevertNormalizer(builtins).map(yul_ast)
    yul_ast = ScopeFlattener(name_gen).map(yul_ast)

    return yul_ast
