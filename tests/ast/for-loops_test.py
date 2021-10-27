import difflib
import os
import pytest

from yul.AstTools import AstParser, AstPrinter
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.ForLoopEliminator import ForLoopEliminator
from yul.NameGenerator import NameGenerator

test_dir = os.path.abspath(os.path.join(__file__, ".."))
tests = [
    os.path.join(test_dir, "multiple-for-loops.ast"),
    os.path.join(test_dir, "nested-for-loops.ast"),
]

@pytest.mark.parametrize(("ast_file_path"), tests)
def test_for_loops(ast_file_path):
    with open(ast_file_path, 'r') as ast_file:
        parser = AstParser(ast_file.read())
        
    yul_ast = parser.parse_node()
    name_gen = NameGenerator()
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = ForLoopEliminator(name_gen).map(yul_ast)

    generated_ast = AstPrinter().format(yul_ast)
    temp_file_path = f"{ast_file_path}.temp"
    with open(temp_file_path, 'w') as temp_file:
        temp_file.write(generated_ast)

    with open(ast_file_path + ".result", "r") as result_file:
        expected_ast = result_file.read()

    compare_codes(generated_ast.splitlines(), expected_ast.splitlines())
    os.remove(temp_file_path)

def compare_codes(lines1, lines2):
    d = difflib.unified_diff(lines1, lines2, n=1, lineterm="")

    message = "\n".join([line for line in d])
    assert len(message) == 0, message