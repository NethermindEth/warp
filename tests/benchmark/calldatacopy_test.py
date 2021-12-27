import os
import tempfile

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import steps_in_function
from tests.utils import CAIRO_PATH
from warp.cli.encoding import get_evm_calldata
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method
from warp.yul.utils import cairoize_bytes

test_dir = __file__


@pytest.mark.asyncio
async def test_calldatacopy():
    sol_file = test_dir[:-8] + ".sol"
    program_info = transpile_from_solidity(sol_file, "WARP")
    tmp = tempfile.NamedTemporaryFile(mode="w", suffix=".cairo", delete=False)
    tmp.write(program_info["cairo_code"])
    tmp.close()
    contract_definition = compile_starknet_files(
        [tmp.name], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address = await deploy_contract(
        starknet, program_info, contract_definition
    )

    evm_calldata = get_evm_calldata(program_info["sol_abi"], "callMe", [])
    [first_four_bytes], _ = cairoize_bytes(evm_calldata[:4])
    res = await invoke_method(starknet, program_info, contract_address, "callMe")
    steps_in_function(sol_file, "callMe", res, "calldatacopy_test")
    assert res.retdata == [4, 1, first_four_bytes]

    os.unlink(tmp.name)
