import pytest

from utils import check_ast
from yul.ExpressionSplitter import ExpressionSplitter
from yul.NameGenerator import NameGenerator

@check_ast(__file__)
def test_split_expressions(yul_ast):
    name_gen = NameGenerator()
    yul_ast = ExpressionSplitter(name_gen).map(yul_ast)

    return yul_ast
