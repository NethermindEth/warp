import os

import pytest
from cli.encoding import get_evm_calldata
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import invoke_method
from yul.utils import cairoize_bytes

from warp.logging.generateMarkdown import steps_in_function

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_calldatacopy():
    contract_file = test_dir[:-8] + ".cairo"
    sol_file = test_dir[:-8] + ".sol"
    program_info = transpile_from_solidity(sol_file, "WARP")
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    contract_address = await starknet.deploy(
        contract_definition=contract_definition, constructor_calldata=[]
    )

    evm_calldata = get_evm_calldata(program_info["sol_abi"], "callMe", [])[2:]
    [first_four_bytes], _ = cairoize_bytes(bytes.fromhex(evm_calldata[: 2 * 4]))
    res = await invoke_method(starknet, program_info, contract_address, "callMe")
    steps_in_function(sol_file, "callMe", res, "calldatacopy_test")
    assert res.retdata == [4, 1, first_four_bytes]
