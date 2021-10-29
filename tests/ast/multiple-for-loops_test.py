import pytest
from utils import check_ast
from yul.ForLoopEliminator import ForLoopEliminator
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.NameGenerator import NameGenerator


@check_ast(__file__)
def test_multiple_for_loops(yul_ast):
    name_gen = NameGenerator()
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = ForLoopEliminator(name_gen).map(yul_ast)

    return yul_ast
