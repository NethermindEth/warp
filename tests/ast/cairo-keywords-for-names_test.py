import pytest
from utils import check_ast

from warp.yul.Renamer import MangleNamesVisitor


@check_ast(__file__)
def test_changing_names(ast):
    return MangleNamesVisitor().map(ast)
