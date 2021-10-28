import asyncio
import os

from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from cli.StarkNetEvmContract import get_evm_calldata
from transpiler.utils import cairoize_bytes


warp_root = os.path.abspath(os.path.join(__file__, "../.."))
test_dir = __file__


async def test_starknet():
    caller_cairo = "//home/greg/dev/warp/calls_test/c2c.cairo"
    caller_sol = "/home/greg/dev/warp/calls_test/c2c.sol"
    erc20_cairo = "/home/greg/dev/warp/calls_test/ERC20.cairo"
    erc20_sol = "/home/greg/dev/warp/calls_test/ERC20.sol"
    cairo_path = f"{warp_root}/warp/cairo-src"
    caller_contractDef = compile_starknet_files(
        [caller_cairo], debug_info=True, cairo_path=[cairo_path]
    )
    erc20_contractDef = compile_starknet_files(
        [erc20_cairo], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    erc20_address = await starknet.deploy(contract_definition=erc20_contractDef)
    caller_address = await starknet.deploy(contract_definition=caller_contractDef)

    mint_calldata_evm = get_evm_calldata(
        caller_sol,
        "WARP",
        "gimmeMoney",
        [erc20_address, 0xE2D015F2CB56D18AD2B61AC045B262AC421B92C3],
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
        caller_sol,
        "WARP",
        "checkMoneyz",
        [erc20_address, 0xE2D015F2CB56D18AD2B61AC045B262AC421B92C3],
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
        caller_sol,
        "WARP",
        "checkMoneyz",
        [erc20_address, 0x7BE8076F4EA4A4AD08075C2508E481D6C946D12B],
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
        caller_sol,
        "WARP",
        "sendMoneyz",
        [
            erc20_address,
            0xE2D015F2CB56D18AD2B61AC045B262AC421B92C3,
            0x7BE8076F4EA4A4AD08075C2508E481D6C946D12B,
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
    )
    print(mint_res)

    balances1_res = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=balance_calldata,
    )
    print(balances1_res)

    transfer_res = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=transfer_calldata,
    )
    print(transfer_res)

    balance_after_transfer = await starknet.invoke_raw(
        contract_address=caller_address,
        selector="fun_ENTRY_POINT",
        calldata=balance_calldata2
    )
    print(balance_after_transfer)



asyncio.run(test_starknet())
