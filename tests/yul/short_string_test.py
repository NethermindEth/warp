import os

import pytest
from cli.StarkNetEvmContract import get_evm_calldata
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.utils import cairoize_bytes

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    solidity_file = test_dir[:-8] + ".sol"
    contract_file = test_dir[:-8] + ".cairo"
    contract_info = transpile_from_solidity(solidity_file, "WARP")
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    contract_address = await starknet.deploy(
        contract_definition=contract_definition, constructor_calldata=[]
    )

    calldata_evm = get_evm_calldata(
        contract_info["sol_abi"],
        contract_info["sol_abi_original"],
        "returnFun",
        [],
    )
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(calldata_evm[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    calldata = [calldata_size, len(cairo_input)] + cairo_input + [contract_address]

    res = await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_ENTRY_POINT",
        calldata=calldata,
        caller_address=0,
    )

    assert res.retdata == [1, 96, 6, 0, 32, 0, 3, 0x41424300000000000000000000000000, 0]

    calldata_evm = get_evm_calldata(
        contract_info["sol_abi"],
        contract_info["sol_abi_original"],
        "bytesFun",
        [],
    )
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(calldata_evm[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    calldata = [calldata_size, len(cairo_input)] + cairo_input + [contract_address]

    res = await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_ENTRY_POINT",
        calldata=calldata,
        caller_address=0,
    )

    assert res.retdata == [1, 96, 6, 0, 32, 0, 3, 0x41424300000000000000000000000000, 0]
