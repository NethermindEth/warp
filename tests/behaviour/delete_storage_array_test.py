import os
from tempfile import mkdtemp

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

from tests.utils import CAIRO_PATH
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method
from warp.yul.utils import spit

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_address():
    contract_file = os.path.basename(test_dir[:-8] + ".cairo")
    sol_file = test_dir[:-8] + ".sol"
    tmpdir = mkdtemp()
    cairo = os.path.join(tmpdir, contract_file)

    program_info = transpile_from_solidity(sol_file, "WARP")
    spit(cairo, program_info["cairo_code"])
    contract_definition = compile_starknet_files(
        [cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address = await deploy_contract(
        starknet, program_info, contract_definition
    )

    res = await invoke_method(starknet, program_info, contract_address, "len")
    assert res.retdata == [32, 2, 0, 0]

    res = await invoke_method(starknet, program_info, contract_address, "val")
    assert res.retdata == [32, 2, 0, 0]
