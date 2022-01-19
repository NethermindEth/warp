import asyncio
import os.path as path
from pathlib import Path
from tempfile import mkdtemp

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method
from warp.yul.utils import spit

TEST_DIR = Path(__file__).parent


@pytest.mark.asyncio
async def test_events():
    sol = TEST_DIR / "events.sol"
    tmpdir = mkdtemp()
    cairo = path.join(tmpdir, "events.cairo")
    info = transpile_from_solidity(sol, "WARP")
    spit(cairo, info["cairo_code"])
    program_info = transpile_from_solidity(sol, "WARP")
    contract_definition = compile_starknet_files(
        [cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address: int = await deploy_contract(
        starknet, program_info, contract_definition
    )

    (log0_res, log1_res, log2_res, log3_res, log4_res) = await asyncio.gather(
        invoke_method(starknet, program_info, contract_address, "log_0"),
        invoke_method(starknet, program_info, contract_address, "log_1", 251),
        invoke_method(starknet, program_info, contract_address, "log_2", 9507),
        invoke_method(starknet, program_info, contract_address, "log_3", 95071852, 42),
        invoke_method(starknet, program_info, contract_address, "log_4", 210, 42),
    )
    assert log0_res.call_info.events[0].keys == [
        43341652765638108362216821688802310765,
        268700160691763059118395331429587622791,
    ]
    assert log0_res.call_info.events[0].data == []

    assert log1_res.call_info.events[0].keys == [
        18854640275833897482902093436070788763,
        196212973174080954927693186864290207539,
    ]
    assert log1_res.call_info.events[0].data == [0, 0, 0, 251]

    assert log2_res.call_info.events[0].keys == [
        83613852532316243335946055095895599074,
        122551849556801221167305207342839997910,
        0,
        0,
    ]
    assert log2_res.call_info.events[0].data == [0, 9507]

    assert log3_res.call_info.events[0].keys == [
        217297115889279246049406593294833932317,
        281495467935021199325666935081949734994,
        0,
        0,
        95071852,
        0,
        42,
        0,
    ]
    assert log3_res.call_info.events[0].data == []

    assert log4_res.call_info.events[0].keys == [
        65648795233238585813247417819619712292,
        320698181699637348980926121377900388678,
        0,
        0,
        210,
        0,
        42,
        0,
    ]
    assert log4_res.call_info.events[0].data == [
        0,
        32,
        0,
        11,
        138766110006081598488797690746716028928,
        0,
    ]
