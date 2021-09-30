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
    assert await contract.fun_deposit_external(
        var_sender_72_low=30, var_sender_72_high=0, var_value_low=500, var_value_high=0
    ).call() == (21, 0, 12, 0)
