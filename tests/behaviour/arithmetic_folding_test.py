import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    sol_file = test_dir[:-8] + ".sol"
    program_info = transpile_from_solidity(sol_file, "WARP")
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address: int = await deploy_contract(
        starknet, program_info, contract_definition
    )

    res = await invoke_method(starknet, program_info, contract_address, "f")
    assert res.retdata == [32, 2, 128935115591136839671669284847193423872, 14]
