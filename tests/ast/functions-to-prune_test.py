from utils import check_ast
from yul.FunctionPruner import FunctionPruner


@check_ast(__file__)
def test_function_prunner(yul_ast):
    yul_ast = FunctionPruner().map(yul_ast)
    return yul_ast
