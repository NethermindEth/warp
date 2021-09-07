import json
import shutil
import subprocess
import sys

from starkware.cairo.lang.compiler.parser import parse_file

from yul.ExpressionSplitter import ExpressionSplitter
from yul.ForLoopEliminator import ForLoopEliminator
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.LeaveNormalizer import LeaveNormalizer
from yul.MangleNamesVisitor import MangleNamesVisitor
from yul.ScopeFlattener import ScopeFlattener
from yul.SwitchToIfVisitor import SwitchToIfVisitor
from yul.ToCairoVisitor import ToCairoVisitor
from yul.parse import parse_node

AST_GENERATOR = "gen-yul-json-ast"


def main(argv):
    if len(argv) != 3:
        sys.exit(
            f"Usage: python {argv[0]} SOLIDITY-FILE MAIN-CONTRACT\n"
            f"where MAIN-CONTRACT is the name of the 'primary' contract (non-interface, non-library & non-abstract contract)"
        )

    if not shutil.which(AST_GENERATOR):
        sys.exit(f"Please install {AST_GENERATOR} first")

    solidity_file = argv[1]
    try:
        result = subprocess.run(
            [AST_GENERATOR, solidity_file, argv[2]], check=True, capture_output=True
        )
    except subprocess.CalledProcessError as e:
        print(e.stderr.decode("utf-8"), file=sys.stderr)
        raise e

    yul_ast = parse_node(json.loads(result.stdout))
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = ForLoopEliminator().map(yul_ast)
    yul_ast = MangleNamesVisitor().map(yul_ast)
    yul_ast = SwitchToIfVisitor().map(yul_ast)
    yul_ast = ExpressionSplitter().map(yul_ast)
    yul_ast = ScopeFlattener().map(yul_ast)
    yul_ast = LeaveNormalizer().map(yul_ast)
    cairo_visitor = ToCairoVisitor()
    cairo_code = cairo_visitor.translate(yul_ast)
    print(parse_file(cairo_code).format())


if __name__ == "__main__":
    main(sys.argv)
