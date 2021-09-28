import pytest
import sys
import os

from starknet.compile import compile_starknet_files
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.contract import StarknetContract

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await Starknet.empty()
    starknetContract = await starknet.deploy(contract_def=contract_definition)
    contract = StarknetContract(
        state=starknet,
        abi=contract_definition.abi,
        contract_address=starknetContract.contract_address,
    )

    assert await starknetContract.fun_deposit_external(
        var_sender_72_low=30, var_sender_72_high=0, var_value_low=500, var_value_high=0
    ).call() == (21, 0, 12, 0)
