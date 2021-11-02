import asyncio
import os

import pytest
from cli.StarkNetEvmContract import get_evm_calldata
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.utils import cairoize_bytes

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.dirname(os.path.abspath(__file__))


@pytest.mark.asyncio
async def test_starknet():
    caller_sol = os.path.join(test_dir, "c2c.sol")
    caller_info = transpile_from_solidity(caller_sol, "WARP")
    caller_cairo = os.path.join(test_dir, "c2c.cairo")

    with open(caller_cairo, "w") as f:
        f.write(caller_info["cairo_code"])

    erc20_cairo = os.path.join(test_dir, "ERC20.cairo")
    erc20_sol = os.path.join(test_dir, "ERC20.sol")
    erc20_info = transpile_from_solidity(erc20_sol, "WARP")

    with open(erc20_cairo, "w") as f:
        f.write(erc20_info["cairo_code"])

    cairo_path = f"{warp_root}/warp/cairo-src"
    caller_contractDef = compile_starknet_files(
        [caller_cairo], debug_info=True, cairo_path=[cairo_path]
    )
    erc20_contractDef = compile_starknet_files(
        [erc20_cairo], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    erc20_address = await starknet.deploy(
        contract_definition=erc20_contractDef, constructor_calldata=[]
    )
    caller_address = await starknet.deploy(
        contract_definition=caller_contractDef, constructor_calldata=[]
    )

    mint_calldata_evm = get_evm_calldata(
        caller_info["sol_abi"],
        caller_info["sol_abi_original"],
        caller_info["sol_bytecode"],
        "gimmeMoney",
        [
            erc20_address,
            0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
        ],
    )
    mint_cairo_input, unused_bytes = cairoize_bytes(
        bytes.fromhex(mint_calldata_evm[2:])
    )
    mint_calldata_size = (len(mint_cairo_input) * 16) - unused_bytes
    mint_calldata = (
        [mint_calldata_size, len(mint_cairo_input)]
        + mint_cairo_input
        + [caller_address]
    )
    balance_calldata_evm = get_evm_calldata(
        caller_info["sol_abi"],
        caller_info["sol_abi_original"],
        caller_info["sol_bytecode"],
        "checkMoneyz",
        [
            erc20_address,
            0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
        ],
    )
    balance_cairo_input, unused_bytes = cairoize_bytes(
        bytes.fromhex(balance_calldata_evm[2:])
    )
    balance_calldata_size = (len(balance_cairo_input) * 16) - unused_bytes
    balance_calldata = (
        [balance_calldata_size, len(balance_cairo_input)]
        + balance_cairo_input
        + [erc20_address]
    )

    # check transfer worked
    balance_calldata_evm2 = get_evm_calldata(
        caller_info["sol_abi"],
        caller_info["sol_abi_original"],
        caller_info["sol_bytecode"],
        "checkMoneyz",
        [
            erc20_address,
            0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
        ],
    )
    balance_cairo_input2, unused_bytes = cairoize_bytes(
        bytes.fromhex(balance_calldata_evm2[2:])
    )
    balance_calldata_size2 = (len(balance_cairo_input2) * 16) - unused_bytes
    balance_calldata2 = (
        [balance_calldata_size2, len(balance_cairo_input2)]
        + balance_cairo_input2
        + [erc20_address]
    )

    transfer_calldata_evm = get_evm_calldata(
        caller_info["sol_abi"],
        caller_info["sol_abi_original"],
        caller_info["sol_bytecode"],
        "sendMoneyz",
        [
            erc20_address,
            0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
            0x05E5ABCCFD81CC08D0E51AD2DA3FE1768C80BA6BC1A8F0F189CFC52925B01429,
            42,
        ],
    )
    transfer_cairo_input, unused_bytes = cairoize_bytes(
        bytes.fromhex(transfer_calldata_evm[2:])
    )
    transfer_calldata_size = (len(transfer_cairo_input) * 16) - unused_bytes
    transfer_calldata = (
        [transfer_calldata_size, len(transfer_cairo_input)]
        + transfer_cairo_input
        + [erc20_address]
    )

    mint_res = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=mint_calldata,
        caller_address=0,
    )

    print(mint_res)
    assert mint_res.retdata == [1, 32, 2, 0, 1]

    balances1_res = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=balance_calldata,
        caller_address=0,
    )
    print(balances1_res)
    assert balances1_res.retdata == [1, 32, 2, 0, 42]

    transfer_res = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=transfer_calldata,
        caller_address=0,
    )
    print(transfer_res)
    assert transfer_res.retdata == [1, 32, 2, 0, 1]

    balance_after_transfer = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=balance_calldata2,
        caller_address=0,
    )
    print(balance_after_transfer)
    assert balance_after_transfer.retdata == [1, 32, 2, 0, 0]
