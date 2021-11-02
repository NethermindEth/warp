import asyncio
import os

import pytest
from cli.commands import flatten
from cli.StarkNetEvmContract import evm_to_cairo_calldata
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.utils import cairoize_bytes

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.dirname(os.path.abspath(__file__))


@pytest.mark.asyncio
async def test_constructors():
    cairo_path = f"{warp_root}/warp/cairo-src"

    dyn_constructor = os.path.join(test_dir, "constructors_dyn.cairo")
    dyn_constructor_sol = os.path.join(test_dir, "constructors_dyn.sol")

    non_dyn_constructor = os.path.join(test_dir, "constructors_nonDyn.cairo")
    non_dyn_constructor_sol = os.path.join(test_dir, "constructors_nonDyn.sol")

    dyn_contract_def = compile_starknet_files(
        [dyn_constructor], debug_info=True, cairo_path=[cairo_path]
    )
    dyn_info = transpile_from_solidity(dyn_constructor_sol, "WARP")
    dyn_inputs = [
        0x50C2AE5414B02533DFF9CE677C7F1FEBC962289B3A696F55DFF8B00836519B7,
        (12345, 23),
        250,
    ]
    dyn_constructor_calldata = evm_to_cairo_calldata(
        dyn_info["sol_abi"],
        dyn_info["sol_abi_original"],
        dyn_info["sol_bytecode"],
        fn_name="__warp_ctorHelper_DynArgs",
        inputs=dyn_inputs,
    )

    non_dyn_contract_def = compile_starknet_files(
        [non_dyn_constructor], debug_info=True, cairo_path=[cairo_path]
    )
    non_dyn_info = transpile_from_solidity(non_dyn_constructor_sol, "WARP")
    non_dyn_inputs = [0x50C2AE5414B02BC962289B3A696F55DFF8B00836519B7, 26, 7432533231]
    flattened_args = list(flatten(non_dyn_inputs))
    split_args = []
    for arg in flattened_args:
        high, low = divmod(arg, 2 ** 128)
        split_args += [low, high]
    starknet = await StarknetState.empty()
    dyn_address, non_dyn_address = await asyncio.gather(
        starknet.deploy(
            contract_definition=dyn_contract_def,
            constructor_calldata=dyn_constructor_calldata,
        ),
        starknet.deploy(
            contract_definition=non_dyn_contract_def,
            constructor_calldata=split_args,
        ),
    )
    dyn_calldata = evm_to_cairo_calldata(
        dyn_info["sol_abi"],
        dyn_info["sol_abi_original"],
        dyn_info["sol_bytecode"],
        fn_name="validate_constructor",
        inputs=dyn_inputs,
        address=dyn_address,
    )
    non_dyn_calldata = evm_to_cairo_calldata(
        non_dyn_info["sol_abi"],
        non_dyn_info["sol_abi_original"],
        non_dyn_info["sol_bytecode"],
        fn_name="validate_constructor",
        inputs=non_dyn_inputs,
        address=0,
    )
    print(dyn_calldata)
    print(non_dyn_calldata)
    dyn_result, non_dyn_result = await asyncio.gather(
        starknet.invoke_raw(
            contract_address=dyn_address,
            selector="fun_ENTRY_POINT",
            calldata=dyn_calldata,
            caller_address=0,
        ),
        starknet.invoke_raw(
            contract_address=non_dyn_address,
            selector="fun_ENTRY_POINT",
            calldata=non_dyn_calldata,
            caller_address=0,
        ),
    )
    print(f"dyn_result: {dyn_result}\n non_dyn_result: {non_dyn_result}")
    assert dyn_result.retdata == [1, 32, 2, 0, 1]
    assert non_dyn_result.retdata == [1, 32, 2, 0, 1]
