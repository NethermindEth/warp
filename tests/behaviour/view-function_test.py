import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import deploy_contract, invoke_method

from warp.logging.generateMarkdown import steps_in_function

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    sol_file = test_dir[:-8] + ".sol"
    program_info = transpile_from_solidity(sol_file, "WARP")
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    contract_address = await deploy_contract(
        starknet, program_info, contract_definition
    )

    res = await invoke_method(
        starknet, program_info, contract_address, "viewFunction", 550, 80, 11, 45
    )
    steps_in_function(sol_file, "viewFunction", res, "view-function_test")
    assert res.retdata == [32, 2, 0, 637]
