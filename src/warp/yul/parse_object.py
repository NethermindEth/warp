from __future__ import annotations

from typing import Sequence

import warp.yul.ast as ast
from warp.yul.parse import parse_node
from warp.yul.Renamer import Renamer


def parse_to_normalized_ast(codes) -> ast.Node:
    deployment_code = parse_node(codes["deploymentCode"])
    runtime_code = parse_node(codes["runtimeCode"])
    assert isinstance(deployment_code, ast.Block)
    assert isinstance(runtime_code, ast.Block)
    return combine_deployment_and_runtime(deployment_code, runtime_code)


def combine_deployment_and_runtime(
    deployment_code: ast.Block, runtime_code: ast.Block
) -> ast.Block:
    ctor_block, deployment_functions = extract_top_level_code(deployment_code)
    main_block, runtime_functions = extract_top_level_code(runtime_code)
    ctor = ast.FunctionDefinition(
        name="__constructor_meat", parameters=[], return_variables=[], body=ctor_block
    )
    main_ = ast.FunctionDefinition(
        name="__main_meat",
        parameters=[],
        return_variables=[],
        body=main_block,
    )

    deployment_names = {
        x.name for x in deployment_functions if isinstance(x, ast.FunctionDefinition)
    }
    runtime_names = {
        x.name for x in runtime_functions if isinstance(x, ast.FunctionDefinition)
    }
    duplicated = deployment_names & runtime_names
    renamer = Renamer(lambda x: x + "_deployment" if x in duplicated else x)
    renamed_deployment_functions = renamer.visit_list(deployment_functions)
    renamed_ctor = renamer.visit(ctor)
    return ast.Block(
        (renamed_ctor, *renamed_deployment_functions, main_, *runtime_functions)
    )


def extract_top_level_code(
    node: ast.Block,
) -> tuple[ast.Block, Sequence[ast.Statement]]:
    # solidity puts top-level code in the first block
    assert node.statements
    top_level_block, *other_stmts = node.statements
    assert isinstance(top_level_block, ast.Block)
    return top_level_block, other_stmts
