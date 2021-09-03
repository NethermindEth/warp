import json
import shutil
import subprocess
import sys

from starkware.cairo.lang.compiler.parser import parse_file

from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.MangleNamesVisitor import MangleNamesVisitor
from yul.ScopeFlattener import ScopeFlattener
from yul.SwitchToIfVisitor import SwitchToIfVisitor
from yul.ToCairoVisitor import ToCairoVisitor
from yul.parse import parse_node

AST_GENERATOR = "./gen-yul-json-ast"


def main(argv):
    if len(argv) != 2:
        sys.exit(f"Usage: python {argv[0]} SOLIDITY-FILE")

    if not shutil.which(AST_GENERATOR):
        sys.exit(f"Please install {AST_GENERATOR} first")

    solidity_file = argv[1]
    result = subprocess.run(
        [AST_GENERATOR, solidity_file], check=True, capture_output=True
    )
    yul_ast = parse_node(json.loads(result.stdout))
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = MangleNamesVisitor().map(yul_ast)
    yul_ast = SwitchToIfVisitor().map(yul_ast)
    yul_ast = ScopeFlattener().map(yul_ast)
    cairo_code = ToCairoVisitor().translate(yul_ast)
    print(parse_file(cairo_code).format())


if __name__ == "__main__":
    main(sys.argv)
