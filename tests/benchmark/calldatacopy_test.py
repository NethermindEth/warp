import os
import tempfile

import pytest
from cli.encoding import get_evm_calldata
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import deploy_contract, invoke_method
from yul.utils import cairoize_bytes

from warp.logging.generateMarkdown import steps_in_function

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_calldatacopy():
    sol_file = test_dir[:-8] + ".sol"
    program_info = transpile_from_solidity(sol_file, "WARP")
    tmp = tempfile.NamedTemporaryFile(mode="w", suffix=".cairo", delete=False)
    tmp.write(program_info["cairo_code"])
    tmp.close()
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [tmp.name], debug_info=True, cairo_path=[cairo_path]
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
