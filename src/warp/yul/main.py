from __future__ import annotations

import dataclasses
import json
import os
import re
import shutil
import subprocess
import sys

import warp.yul.ast as ast
from warp.kudu import kudu_exe
from warp.yul.BuiltinHandler import get_default_builtins
from warp.yul.ConstantFolder import ConstantFolder
from warp.yul.DeadcodeEliminator import DeadcodeEliminator
from warp.yul.ExpressionSplitter import ExpressionSplitter
from warp.yul.FoldIf import FoldIf
from warp.yul.ForLoopEliminator import ForLoopEliminator
from warp.yul.ForLoopSimplifier import ForLoopSimplifier
from warp.yul.FunctionGenerator import CairoFunctions, FunctionGenerator
from warp.yul.FunctionPruner import FunctionPruner
from warp.yul.LeaveNormalizer import LeaveNormalizer
from warp.yul.NameGenerator import NameGenerator
from warp.yul.parse_object import parse_to_normalized_ast
from warp.yul.Renamer import MangleNamesVisitor
from warp.yul.RevertNormalizer import RevertNormalizer
from warp.yul.ScopeFlattener import ScopeFlattener
from warp.yul.SwitchToIfVisitor import SwitchToIfVisitor
from warp.yul.ToCairoVisitor import ToCairoVisitor
from warp.yul.utils import get_for_contract
from warp.yul.VariableInliner import VariableInliner
from warp.yul.WarpException import warp_assert


@dataclasses.dataclass()
class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


def transpile_from_solidity(
    sol_src_path, main_contract, optimizers_order="VFoLRFD"
) -> dict:
    sol_src_path_modified = str(sol_src_path)[:-4] + "_marked.sol"
    try:
        with kudu_exe() as exe:
            result = subprocess.run(
                [exe, "--yul-json-ast", sol_src_path, main_contract],
                check=True,
                capture_output=True,
            )
        if result.stderr:
            print(
                bcolors.FAIL
                + bcolors.BOLD
                + result.stderr.decode("utf-8")
                + bcolors.ENDC,
                file=sys.stderr,
            )
    except subprocess.CalledProcessError as e:
        print(
            bcolors.FAIL + bcolors.BOLD + e.stderr.decode("utf-8") + bcolors.ENDC,
            file=sys.stderr,
        )
        raise e

    output = get_for_contract(sol_src_path_modified, main_contract, ["abi"])
    warp_assert(output, f"Couldn't extract {main_contract}'s abi from {sol_src_path}")
    (abi,) = output

    codes = json.loads(result.stdout)
    yul_ast = parse_to_normalized_ast(codes)
    cairo_code = transpile_from_yul(yul_ast, optimizers_order)
    try:
        os.remove(sol_src_path_modified)
    except FileNotFoundError:
        pass  # for reentrancy
    return {"cairo_code": cairo_code, "sol_abi": abi}


def transpile_from_yul(yul_ast: ast.Node, optimizers_order) -> str:
    name_gen = NameGenerator()
    cairo_functions = CairoFunctions(FunctionGenerator())
    builtins = get_default_builtins(cairo_functions)

    pass_order = "FlsFleMSVERSf" + optimizers_order

    ast_passes = {
        "Fls": [ForLoopSimplifier().map],
        "Fle": [ForLoopEliminator(name_gen).map],
        "M": [MangleNamesVisitor().map],
        "S": [SwitchToIfVisitor().map],
        "E": [ExpressionSplitter(name_gen).map],
        "Sf": [ScopeFlattener(name_gen).map],
        "V": [VariableInliner().map, ConstantFolder().map],
        "Fo": [FoldIf().map],
        "L": [LeaveNormalizer().map],
        "R": [RevertNormalizer(builtins).map],
        "F": [FunctionPruner().map],
        "D": [DeadcodeEliminator().map],
    }

    for ast_pass in re.findall(r"[A-Z][a-z]*", pass_order):
        ast_mappers = ast_passes.get(ast_pass) or [lambda ast: ast]
        for ast_mapper in ast_mappers:
            yul_ast = ast_mapper(yul_ast)

    cairo_visitor = ToCairoVisitor(name_gen, cairo_functions, get_default_builtins)

    from starkware.cairo.lang.compiler.parser import parse_file

    return parse_file(cairo_visitor.translate(yul_ast)).format()


def main(argv):
    if len(argv) != 3:
        sys.exit("Supply SOLIDITY-CONTRACT and MAIN-CONTRACT-NAME")
    sol_src_path = argv[1]
    main_contract = argv[2]
    transpile_from_solidity(sol_src_path, main_contract)


if __name__ == "__main__":
    main(sys.argv)
