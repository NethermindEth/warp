import yul.yul_ast as ast
from utils import compare_codes
from yul.AstTools import YulPrinter
from yul.parse_object import combine_deployment_and_runtime


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
\tfunction constructor() { do_stuff_deployment() }
\tfunction do_stuff_deployment() {  }
\tfunction fun_ENTRY_POINT() { do_stuff() }
\tfunction do_stuff() {  }
}
"""
    compare_codes(actual.strip().splitlines(), expected.strip().splitlines())
