import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import steps_in_function
from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

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

    caller_contractDef = compile_starknet_files(
        [caller_cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )
    erc20_contractDef = compile_starknet_files(
        [erc20_cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    erc20_address = await deploy_contract(starknet, erc20_info, erc20_contractDef)
    caller_address = await deploy_contract(starknet, caller_info, caller_contractDef)

    mint_res = await invoke_method(
        starknet,
        caller_info,
        caller_address,
        "gimmeMoney",
        erc20_address,
        0x6044EC4F3C64A75078096F7C7A6892D16569921C8B5C86986A28F4BB39FEDDF,
    )
    steps_in_function("c2c.sol", "gimmeMoney", mint_res, "c2c")
    assert mint_res.retdata == [32, 2, 0, 1]

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
    assert balances1_res.retdata == [32, 2, 0, 42]

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
    assert transfer_res.retdata == [32, 2, 0, 1]

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
    assert balance_after_transfer.retdata == [32, 2, 0, 0]
