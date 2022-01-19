import os.path as path
import shutil
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
async def test():
    sol = TEST_DIR / "for-loop-no-condition.sol"
    tmpdir = mkdtemp()
    cairo = path.join(tmpdir, "for-loop-no-condition.cairo")
    info = transpile_from_solidity(sol, "WARP")
    spit(cairo, info["cairo_code"])
    def_ = compile_starknet_files([cairo], debug_info=True, cairo_path=[CAIRO_PATH])

    starknet = await StarknetState.empty()
    address: int = await deploy_contract(starknet, info, def_)
    res = await invoke_method(starknet, info, address, "f")
    assert res.retdata == [32, 2, 0, 10]
    shutil.rmtree(tmpdir)
