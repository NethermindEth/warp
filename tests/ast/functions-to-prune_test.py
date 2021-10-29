import pytest
from utils import check_ast
from yul.FunctionPruner import FunctionPruner


@check_ast(__file__)
def test_function_prunner(yul_ast):
    public_functions = ["funA", "funD", "funE"]
    yul_ast = FunctionPruner(public_functions).map(yul_ast)

    return yul_ast
