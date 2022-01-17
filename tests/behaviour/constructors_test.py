import asyncio
import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import steps_in_function
from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

test_dir = os.path.dirname(os.path.abspath(__file__))


@pytest.mark.asyncio
async def test_constructors():
    dyn_constructor = os.path.join(test_dir, "constructors_dyn.cairo")
    dyn_constructor_sol = os.path.join(test_dir, "constructors_dyn.sol")

    non_dyn_constructor = os.path.join(test_dir, "constructors_nonDyn.cairo")
    non_dyn_constructor_sol = os.path.join(test_dir, "constructors_nonDyn.sol")

    dyn_contract_def = compile_starknet_files(
        [dyn_constructor], debug_info=True, cairo_path=[CAIRO_PATH]
    )
    dyn_info = transpile_from_solidity(dyn_constructor_sol, "WARP")
    dyn_inputs = [
        0x50C2AE5414B02533DFF9CE677C7F1FEBC962289B3A696F55DFF8B00836519B7,
        (12345, 23),
        250,
    ]
    non_dyn_contract_def = compile_starknet_files(
        [non_dyn_constructor], debug_info=True, cairo_path=[CAIRO_PATH]
    )
    non_dyn_info = transpile_from_solidity(non_dyn_constructor_sol, "WARP")
    non_dyn_inputs = [0x50C2AE5414B02BC962289B3A696F55DFF8B00836519B7, 26, 7432533231]
    starknet = await StarknetState.empty()
    dyn_address, non_dyn_address = await asyncio.gather(
        deploy_contract(starknet, dyn_info, dyn_contract_def, *dyn_inputs),
        deploy_contract(starknet, non_dyn_info, non_dyn_contract_def, *non_dyn_inputs),
    )
    dyn_result, non_dyn_result = await asyncio.gather(
        invoke_method(
            starknet, dyn_info, dyn_address, "validate_constructor", *dyn_inputs
        ),
        invoke_method(
            starknet,
            non_dyn_info,
            non_dyn_address,
            "validate_constructor",
            *non_dyn_inputs,
        ),
    )
    steps_in_function(
        "constructors_dyn.sol", "validate_constructor", dyn_result, "constructors_dyn"
    )
    steps_in_function(
        "constructors_nonDyn.sol",
        "validate_constructor",
        non_dyn_result,
        "constructors_nonDyn",
    )
    print(f"dyn_result: {dyn_result}\n non_dyn_result: {non_dyn_result}")
    assert dyn_result.retdata == [32, 2, 0, 1]
    assert non_dyn_result.retdata == [32, 2, 0, 1]
