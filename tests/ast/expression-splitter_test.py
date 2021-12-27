import pytest
from utils import check_ast

from warp.yul.ExpressionSplitter import ExpressionSplitter
from warp.yul.NameGenerator import NameGenerator


@check_ast(__file__)
def test_split_expressions(ast):
    name_gen = NameGenerator()
    ast = ExpressionSplitter(name_gen).map(ast)

    return ast
