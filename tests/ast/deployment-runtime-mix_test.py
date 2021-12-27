from utils import compare_codes

import warp.yul.ast as ast
from warp.yul.AstTools import YulPrinter
from warp.yul.parse_object import combine_deployment_and_runtime


def test_function_with_the_same_name_in_deployment_and_runtime():
    call_do_stuff = ast.ExpressionStatement(
        ast.FunctionCall(ast.Identifier("do_stuff"), [])
    )
    deployment = ast.Block(
        (
            ast.Block((call_do_stuff,)),
            ast.FunctionDefinition("do_stuff", [], [], ast.Block(())),
        )
    )
    runtime = ast.Block(
        (
            ast.Block((call_do_stuff,)),
            ast.FunctionDefinition("do_stuff", [], [], ast.Block(())),
        )
    )
    combined = combine_deployment_and_runtime(deployment, runtime)
    actual = YulPrinter().format(combined)
    expected = """
{
\tfunction __constructor_meat() { do_stuff_deployment() }
\tfunction do_stuff_deployment() {  }
\tfunction __main_meat() { do_stuff() }
\tfunction do_stuff() {  }
}
"""
    compare_codes(actual.strip().splitlines(), expected.strip().splitlines())
