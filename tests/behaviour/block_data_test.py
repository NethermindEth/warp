import os

import pytest
from starkware.starknet.business_logic.state import BlockInfo
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import steps_in_function
from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

test_dir = os.path.dirname(os.path.abspath(__file__))


@pytest.mark.asyncio
async def test_starknet():
    block_data_sol = os.path.join(test_dir, "block_data.sol")
    block_data_info = transpile_from_solidity(block_data_sol, "WARP")
    block_data_cairo = os.path.join(test_dir, "block_data.cairo")

    with open(block_data_cairo, "w") as f:
        f.write(block_data_info["cairo_code"])

    block_data_contractDef = compile_starknet_files(
        [block_data_cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    starknet.state.block_info = BlockInfo(
        block_number=0xDEADBEEF, block_timestamp=0xCAFEBABE
    )

    block_data_address: int = await deploy_contract(
        starknet, block_data_info, block_data_contractDef
    )

    block_number = await invoke_method(
        starknet, block_data_info, block_data_address, "getBlockNumber"
    )
    assert block_number.retdata == [
        32,
        2,
        0,
        0xDEADBEEF,
    ]

    block_timestamp = await invoke_method(
        starknet, block_data_info, block_data_address, "getBlockTimeStamp"
    )
    assert block_timestamp.retdata == [32, 2, 0, 0xCAFEBABE]
