import pytest
from utils import check_ast

from warp.yul.ForLoopEliminator import ForLoopEliminator
from warp.yul.ForLoopSimplifier import ForLoopSimplifier
from warp.yul.NameGenerator import NameGenerator


@check_ast(__file__)
def test_multiple_for_loops(ast):
    name_gen = NameGenerator()
    ast = ForLoopSimplifier().map(ast)
    ast = ForLoopEliminator(name_gen).map(ast)

    return ast
