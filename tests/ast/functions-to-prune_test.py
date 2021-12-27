from utils import check_ast

from warp.yul.FunctionPruner import FunctionPruner


@check_ast(__file__)
def test_function_prunner(ast):
    ast = FunctionPruner().map(ast)
    return ast
