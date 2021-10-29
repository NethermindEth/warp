import pytest

from utils import check_ast
from yul.NameGenerator import NameGenerator
from yul.ScopeFlattener import ScopeFlattener

@check_ast(__file__)
def test_scope_flattening(yul_ast):
    name_gen = NameGenerator()
    yul_ast = ScopeFlattener(name_gen).map(yul_ast)

    return yul_ast
