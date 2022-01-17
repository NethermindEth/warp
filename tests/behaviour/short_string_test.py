import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import steps_in_function
from tests.utils import CAIRO_PATH
from warp.cli.encoding import get_evm_calldata
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    solidity_file = test_dir[:-8] + ".sol"
    contract_file = test_dir[:-8] + ".cairo"
    program_info = transpile_from_solidity(solidity_file, "WARP")
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address = await deploy_contract(
        starknet, program_info, contract_definition
    )

    res = await invoke_method(starknet, program_info, contract_address, "returnFun")
    steps_in_function(solidity_file, "returnFun", res, "short_string")
    assert res.retdata == [96, 6, 0, 32, 0, 3, 0x41424300000000000000000000000000, 0]

    res = await invoke_method(starknet, program_info, contract_address, "bytesFun")
    steps_in_function(solidity_file, "bytesFun", res, "short_string")
    assert res.retdata == [96, 6, 0, 32, 0, 3, 0x41424300000000000000000000000000, 0]
