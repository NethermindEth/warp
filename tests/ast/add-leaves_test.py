import pytest
from utils import check_ast
from yul.LeaveNormalizer import LeaveNormalizer


@check_ast(__file__)
def test_adding_leaves(yul_ast):
    return LeaveNormalizer().map(yul_ast)
