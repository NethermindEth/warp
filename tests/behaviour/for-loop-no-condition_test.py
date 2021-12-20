import os.path as path
import shutil
from pathlib import Path
from tempfile import mkdtemp

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import deploy_contract, invoke_method

WARP_ROOT = Path(__file__).parents[2]
CAIRO_PATH = WARP_ROOT / "warp" / "cairo-src"
TEST_DIR = Path(__file__).parent


def spit(fname, content):
    """Writes 'content' to the file named 'fname'"""
    with open(fname, "w") as f:
        f.write(content)


@pytest.mark.asyncio
async def test():
    sol = TEST_DIR / "for-loop-no-condition.sol"
    tmpdir = mkdtemp()
    cairo = path.join(tmpdir, "for-loop-no-condition.cairo")
    info = transpile_from_solidity(sol, "WARP")
    spit(cairo, info["cairo_code"])
    def_ = compile_starknet_files([cairo], debug_info=True, cairo_path=[CAIRO_PATH])

    starknet = await StarknetState.empty()
    address = await deploy_contract(starknet, info, def_)
    res = await invoke_method(starknet, info, address, "f")
    assert res.retdata == [32, 2, 0, 10]
    shutil.rmtree(tmpdir)
