import json
import shutil
import subprocess
import os
import sys

from starkware.cairo.lang.compiler.parser import parse_file
from yul.ExpressionSplitter import ExpressionSplitter
from yul.ForLoopEliminator import ForLoopEliminator
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.FunctionPruner import FunctionPruner
from yul.LeaveNormalizer import LeaveNormalizer
from yul.MangleNamesVisitor import MangleNamesVisitor
from yul.RevertNormalizer import RevertNormalizer
from yul.ScopeFlattener import ScopeFlattener
from yul.SwitchToIfVisitor import SwitchToIfVisitor
from yul.ToCairoVisitor import ToCairoVisitor
from yul.parse import parse_node
from yul.utils import get_public_functions

AST_GENERATOR = "gen-yul-json-ast"


def generate_cairo(sol_src_path, main_contract):
    if not shutil.which(AST_GENERATOR):
        sys.exit(f"Please install {AST_GENERATOR} first")

    with open(sol_src_path) as f:
        sol_source = f.read()
        public_functions = get_public_functions(sol_source)

    try:
        result = subprocess.run(
            [AST_GENERATOR, sol_src_path, main_contract],
            check=True,
            capture_output=True,
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
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = ScopeFlattener().map(yul_ast)
    yul_ast = LeaveNormalizer().map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = FunctionPruner(public_functions).map(yul_ast)
    cairo_visitor = ToCairoVisitor(sol_source, sol_src_path, main_contract)
    cairo_code = cairo_visitor.translate(yul_ast)
    return parse_file(cairo_code).format()


def main(argv):
    if len(argv) != 3:
        sys.exit("Supply SOLIDITY-CONTRACT and MAIN-CONTRACT-NAME")
    sol_src_path = argv[1]
    main_contract = argv[2]
    generate_cairo(sol_src_path, main_contract)


if __name__ == "__main__":
    main(sys.argv)
