from __future__ import annotations

import json
import shutil
import subprocess
import sys

import yul.yul_ast as ast
from starkware.cairo.lang.compiler.parser import parse_file
from yul.Artifacts import Artifacts
from yul.ExpressionSplitter import ExpressionSplitter
from yul.ForLoopEliminator import ForLoopEliminator
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.FunctionPruner import FunctionPruner
from yul.LeaveNormalizer import LeaveNormalizer
from yul.MangleNamesVisitor import MangleNamesVisitor
from yul.NameGenerator import NameGenerator
from yul.RevertNormalizer import RevertNormalizer
from yul.ScopeFlattener import ScopeFlattener
from yul.SwitchToIfVisitor import SwitchToIfVisitor
from yul.ToCairoVisitor import ToCairoVisitor
from yul.parse import parse_node
from yul.utils import get_public_functions, get_function_mutabilities

AST_GENERATOR = "kudu"


def generate_cairo(sol_src_path, main_contract):
    if not shutil.which(AST_GENERATOR):
        sys.exit(f"Please install {AST_GENERATOR} first")

    try:
        result = subprocess.run(
            [AST_GENERATOR, sol_src_path, main_contract],
            check=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as e:
        print(e.stderr.decode("utf-8"), file=sys.stderr)
        raise e

    with open(sol_src_path) as f:
        sol_source = f.read()
        public_functions = get_public_functions(sol_source)
        function_mutabilities = get_function_mutabilities(sol_source)

    artifacts_manager = Artifacts(sol_src_path)
    yul_ast = parse_node(json.loads(result.stdout))
    return generate_from_yul(
        yul_ast,
        main_contract,
        public_functions,
        function_mutabilities,
        artifacts_manager,
    )


def generate_from_yul(
    yul_ast: ast.Node,
    main_contract: str,
    public_functions: list[str],
    function_mutabilities: dict[str, str],
    artifacts_manager: Artifacts,
):
    name_gen = NameGenerator()
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = ForLoopEliminator(name_gen).map(yul_ast)
    yul_ast = MangleNamesVisitor().map(yul_ast)
    yul_ast = SwitchToIfVisitor().map(yul_ast)
    yul_ast = ExpressionSplitter(name_gen).map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = ScopeFlattener(name_gen).map(yul_ast)
    yul_ast = LeaveNormalizer().map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = FunctionPruner(public_functions).map(yul_ast)

    cairo_visitor = ToCairoVisitor(
        main_contract,
        public_functions,
        function_mutabilities,
        name_gen,
        artifacts_manager,
    )
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
