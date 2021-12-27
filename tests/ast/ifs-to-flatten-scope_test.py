import pytest
from utils import check_ast

from warp.yul.NameGenerator import NameGenerator
from warp.yul.ScopeFlattener import ScopeFlattener


@check_ast(__file__)
def test_scope_flattening(ast):
    name_gen = NameGenerator()
    ast = ScopeFlattener(name_gen).map(ast)

    return ast
