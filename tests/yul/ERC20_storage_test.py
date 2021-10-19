import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    contract_address = await starknet.deploy(contract_definition=contract_definition)
    sender = 74
    receiver = 68

    await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_deposit_external",
        calldata=[sender, 0, 500, 0],
    )

    res = await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_transferFrom_external",
        calldata=[sender, 0, receiver, 0, 400, 0, sender, 0],
    )
    assert res.retdata == [1, 0]

    await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_withdraw_external",
        calldata=[80, 0, sender, 0],
    )

    res = await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_get_balance_external",
        calldata=[sender, 0],
    )
    assert res.retdata == [20, 0]

    res = await starknet.invoke_raw(
        contract_address=contract_address,
        selector="fun_get_balance_external",
        calldata=[receiver, 0],
    )
    assert res.retdata == [400, 0]
