import tempfile
from pathlib import Path

import pytest
from starkware.starknet.compiler.compile import (
    compile_starknet_codes,
    compile_starknet_files,
)
from starkware.starknet.testing.state import StarknetState
from starkware.starkware_utils.error_handling import StarkException

from tests.utils import CAIRO_PATH, WARP_ROOT
from warp.cli.encoding import (
    get_cairo_calldata,
    get_ctor_evm_calldata,
    get_evm_calldata,
)
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

TEST_DIR = Path(__file__).parent


@pytest.fixture
async def starknet():
    return await StarknetState.empty()


@pytest.fixture
def friendly_info():
    friendly_file = TEST_DIR / "friendly.sol"
    return transpile_from_solidity(friendly_file, "Friend")


@pytest.fixture
def friendly_def(friendly_info):
    with tempfile.NamedTemporaryFile(mode="w", suffix=".cairo") as tmp:
        tmp.write(friendly_info["cairo_code"])
        yield compile_starknet_codes(
            [(friendly_info["cairo_code"], tmp.name)],
            debug_info=True,
            cairo_path=[CAIRO_PATH],
        )


@pytest.fixture
async def friendly_address(starknet, friendly_info, friendly_def):
    return await deploy_contract(starknet, friendly_info, friendly_def, 8)


@pytest.mark.asyncio
async def test_normal_contract_call(
    starknet, friendly_info, friendly_def, friendly_address
):
    friendly_address2 = await deploy_contract(starknet, friendly_info, friendly_def, 13)
    result = await invoke_method(
        starknet, friendly_info, friendly_address, "call_friend", friendly_address2
    )
    assert result.retdata == [32, 2, 0, 13]


@pytest.mark.asyncio
async def test_malicious_deploy(starknet, friendly_info, friendly_def):
    evm_calldata = get_ctor_evm_calldata(friendly_info["sol_abi"], [0])
    cairo_calldata = get_cairo_calldata(evm_calldata)
    tampered_calldata1 = list(cairo_calldata)
    tampered_calldata1[-1] = 2 ** 128
    exc_msg = rf"Value {2**128}, in range check builtin \d*, is out of range \[0, {2**128}\)\."
    with pytest.raises(StarkException, match=exc_msg):
        await starknet.deploy(friendly_def, tampered_calldata1)
    tampered_calldata2 = list(cairo_calldata)
    tampered_calldata2[0] -= 10
    with pytest.raises(StarkException):
        await starknet.deploy(friendly_def, tampered_calldata2)
    tampered_calldata3 = list(cairo_calldata)
    tampered_calldata3[0] += 10
    with pytest.raises(StarkException):
        await starknet.deploy(friendly_def, tampered_calldata3)


@pytest.mark.asyncio
async def test_malicious_direct_call(starknet, friendly_info, friendly_address):
    evm_calldata = get_evm_calldata(friendly_info["sol_abi"], "call_friend", [0])
    cairo_calldata = get_cairo_calldata(evm_calldata)
    cairo_calldata[-1] = 2 ** 128  # tamper with calldata to make it invalid
    exc_msg = rf"Value {2**128}, in range check builtin \d*, is out of range \[0, {2**128}\)\."
    with pytest.raises(StarkException, match=exc_msg):
        await starknet.invoke_raw(
            contract_address=friendly_address,
            selector="__main",
            calldata=cairo_calldata,
            caller_address=0,
        )


@pytest.mark.asyncio
async def test_malicious_contract_call(starknet, friendly_info, friendly_address):
    hacker_file = TEST_DIR / "hacker.cairo"
    hacker_def = compile_starknet_files([str(hacker_file)], debug_info=True)
    hacker_address = await starknet.deploy(hacker_def, [])

    exc_msg = rf"Value {2**128}, in range check builtin \d*, is out of range \[0, {2**128}\)\."
    with pytest.raises(StarkException, match=exc_msg):
        await invoke_method(
            starknet, friendly_info, friendly_address, "call_friend", hacker_address
        )
