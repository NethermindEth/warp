import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import invoke_method

from warp.logging.generateMarkdown import steps_in_function

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

    mint_res = await invoke_method(
        starknet,
        caller_info,
        caller_address,
        "gimmeMoney",
        erc20_address,
        0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
    )
    steps_in_function("c2c.sol", "gimmeMoney", mint_res, "c2c")
    assert mint_res.retdata == [1, 32, 2, 0, 1]

    balances1_res = await invoke_method(
        starknet,
        caller_info,
        caller_address,
        "checkMoneyz",
        erc20_address,
        0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
    )
    print(balances1_res)
    steps_in_function("c2c.sol", "checkMoneyz", balances1_res, "c2c")
    assert balances1_res.retdata == [1, 32, 2, 0, 42]

    transfer_res = await invoke_method(
        starknet,
        caller_info,
        caller_address,
        "sendMoneyz",
        erc20_address,
        0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
        0x05E5ABCCFD81CC08D0E51AD2DA3FE1768C80BA6BC1A8F0F189CFC52925B01429,
        42,
    )
    print(transfer_res)
    steps_in_function("c2c.sol", "sendMoneyz", transfer_res, "c2c")
    assert transfer_res.retdata == [1, 32, 2, 0, 1]

    # check transfer worked
    balance_after_transfer = await invoke_method(
        starknet,
        caller_info,
        caller_address,
        "checkMoneyz",
        erc20_address,
        0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
    )
    print(balance_after_transfer)
    steps_in_function("c2c.sol", "checkMoneyz", balance_after_transfer, "c2c")
    assert balance_after_transfer.retdata == [1, 32, 2, 0, 0]
