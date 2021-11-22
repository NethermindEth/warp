from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys

import yul.yul_ast as ast
from yul.BuiltinHandler import get_default_builtins
from yul.ConstantFolder import ConstantFolder
from yul.DeadcodeEliminator import DeadcodeEliminator
from yul.ExpressionSplitter import ExpressionSplitter
from yul.FoldIf import FoldIf
from yul.ForLoopEliminator import ForLoopEliminator
from yul.ForLoopSimplifier import ForLoopSimplifier
from yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from yul.FunctionPruner import FunctionPruner
from yul.LeaveNormalizer import LeaveNormalizer
from yul.MangleNamesVisitor import MangleNamesVisitor
from yul.NameGenerator import NameGenerator
from yul.parse import parse_node
from yul.RevertNormalizer import RevertNormalizer
from yul.ScopeFlattener import ScopeFlattener
from yul.SwitchToIfVisitor import SwitchToIfVisitor
from yul.ToCairoVisitor import ToCairoVisitor
from yul.utils import get_for_contract
from yul.VariableInliner import VariableInliner
from yul.WarpException import warp_assert

AST_GENERATOR = "kudu"


def transpile_from_solidity(sol_src_path, main_contract) -> dict:
    sol_src_path_modified = sol_src_path[:-4] + "_marked.sol"
    if not shutil.which(AST_GENERATOR):
        sys.exit(f"Please install {AST_GENERATOR} first")

    try:
        result = subprocess.run(
            [AST_GENERATOR, "--yul-json-ast", sol_src_path, main_contract],
            check=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as e:
        print(e.stderr.decode("utf-8"), file=sys.stderr)
        raise e
    output = get_for_contract(sol_src_path_modified, main_contract, ["abi"])
    warp_assert(output, f"Couldn't extract {main_contract}'s abi from {sol_src_path}")
    (abi,) = output
    yul_ast = parse_node(json.loads(result.stdout))
    cairo_code, dynamic_argument_functions = transpile_from_yul(yul_ast)
    os.remove(sol_src_path_modified)
    return {
        "cairo_code": cairo_code,
        "sol_abi": abi,
        "dynamic_argument_functions": dynamic_argument_functions,
    }


def transpile_from_yul(yul_ast: ast.Node) -> str:
    name_gen = NameGenerator()
    cairo_functions = CairoFunctions(FunctionGenerator())
    yul_ast = ForLoopSimplifier().map(yul_ast)
    yul_ast = ForLoopEliminator(name_gen).map(yul_ast)
    yul_ast = MangleNamesVisitor().map(yul_ast)
    yul_ast = SwitchToIfVisitor().map(yul_ast)
    yul_ast = VariableInliner().map(yul_ast)
    yul_ast = ConstantFolder().map(yul_ast)
    yul_ast = FoldIf().map(yul_ast)
    yul_ast = ExpressionSplitter(name_gen).map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = ScopeFlattener(name_gen).map(yul_ast)
    yul_ast = LeaveNormalizer().map(yul_ast)
    yul_ast = RevertNormalizer().map(yul_ast)
    yul_ast = FunctionPruner().map(yul_ast)
    yul_ast = DeadcodeEliminator().map(yul_ast)

    cairo_visitor = ToCairoVisitor(name_gen, cairo_functions, get_default_builtins)

    from starkware.cairo.lang.compiler.parser import parse_file

    return (
        parse_file(cairo_visitor.translate(yul_ast)).format(),
        cairo_visitor.dynamic_argument_functions,
    )


def main(argv):
    if len(argv) != 3:
        sys.exit("Supply SOLIDITY-CONTRACT and MAIN-CONTRACT-NAME")
    sol_src_path = argv[1]
    main_contract = argv[2]
    transpile_from_solidity(sol_src_path, main_contract)


if __name__ == "__main__":
    main(sys.argv)
