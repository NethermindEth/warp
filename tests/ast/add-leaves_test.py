import pytest
from utils import check_ast

from warp.yul.LeaveNormalizer import LeaveNormalizer


@check_ast(__file__)
def test_adding_leaves(ast):
    return LeaveNormalizer().map(ast)
