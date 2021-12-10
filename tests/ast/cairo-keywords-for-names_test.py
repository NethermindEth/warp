import pytest
from utils import check_ast
from yul.Renamer import MangleNamesVisitor


@check_ast(__file__)
def test_changing_names(yul_ast):
    return MangleNamesVisitor().map(yul_ast)
