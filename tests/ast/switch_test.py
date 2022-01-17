import pytest
from utils import check_ast

from warp.yul.SwitchToIfVisitor import SwitchToIfVisitor


@check_ast(__file__)
def test_switch_to_ifs(ast):
    return SwitchToIfVisitor().map(ast)
