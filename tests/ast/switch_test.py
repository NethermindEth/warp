import pytest
from utils import check_ast
from yul.AstTools import AstParser, AstPrinter
from yul.SwitchToIfVisitor import SwitchToIfVisitor


@check_ast(__file__)
def test_switch_to_ifs(yul_ast):
    return SwitchToIfVisitor().map(yul_ast)
