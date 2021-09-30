import pytest
import os

from starkware.starknet.testing.starknet import Starknet

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    cairo_path = [f"{warp_root}/warp/cairo-src"]
    starknet = await Starknet.empty()
    contract = await starknet.deploy(source=contract_file, cairo_path=cairo_path)

    sender = 74
    receiver = 68

    await contract.fun_deposit_external(
        var_sender_65_low=sender,
        var_sender_65_high=0,
        var_value_low=500,
        var_value_high=0,
    ).invoke()

    transfer_from = contract.fun_transferFrom_external(
        var_src_71_low=sender,
        var_src_71_high=0,
        var_dst_low=receiver,
        var_dst_high=0,
        var_wad_72_low=400,
        var_wad_72_high=0,
        var_sender_73_low=sender,
        var_sender_73_high=0,
    )
    assert await transfer_from.invoke() == (1, 0)

    await contract.fun_withdraw_external(
        var_wad_83_low=80,
        var_wad_83_high=0,
        var_sender_84_low=sender,
        var_sender_84_high=0,
    ).invoke()

    assert await contract.fun_get_balance_external(
        var_src_low=sender, var_src_high=0
    ).call() == (20, 0)

    assert await contract.fun_get_balance_external(
        var_src_low=receiver, var_src_high=0
    ).call() == (400, 0)
