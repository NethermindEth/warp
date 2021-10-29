import pytest

from utils import check_ast
from yul.ExpressionSplitter import ExpressionSplitter
from yul.NameGenerator import NameGenerator
from yul.RevertNormalizer import RevertNormalizer
from yul.ScopeFlattener import ScopeFlattener

@check_ast(__file__)
def test_revert_condition(yul_ast):
    name_gen = NameGenerator()
    yul_ast = ExpressionSplitter(name_gen).map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = ScopeFlattener(name_gen).map(yul_ast)

    return yul_ast