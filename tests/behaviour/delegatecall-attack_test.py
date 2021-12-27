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

TEST_DIR = Path(__file__).parent


def spit(fname, content):
    """Writes 'content' to the file named 'fname'"""
    with open(fname, "w") as f:
        f.write(content)


@pytest.mark.asyncio
async def test_attack():
    sol = TEST_DIR / "delegatecall-attack.sol"
    tmpdir = mkdtemp()
    lib_cairo = path.join(tmpdir, "lib.cairo")
    hackme_cairo = path.join(tmpdir, "hackme.cairo")
    attack_cairo = path.join(tmpdir, "attack.cairo")

    lib_info = transpile_from_solidity(sol, "Lib")
    hackme_info = transpile_from_solidity(sol, "HackMe")
    attack_info = transpile_from_solidity(sol, "Attack")

    spit(lib_cairo, lib_info["cairo_code"])
    spit(hackme_cairo, hackme_info["cairo_code"])
    spit(attack_cairo, attack_info["cairo_code"])

    lib_def = compile_starknet_files(
        [lib_cairo],
        debug_info=True,
        cairo_path=[CAIRO_PATH],
    )
    hackme_def = compile_starknet_files(
        [hackme_cairo],
        debug_info=True,
        cairo_path=[CAIRO_PATH],
    )
    attack_def = compile_starknet_files(
        [attack_cairo],
        debug_info=True,
        cairo_path=[CAIRO_PATH],
    )

    starknet = await StarknetState.empty()
    # step 1
    lib_address = await deploy_contract(starknet, lib_info, lib_def)
    # step 2
    hackme_address = await deploy_contract(
        starknet, hackme_info, hackme_def, lib_address
    )
    # step 3
    attack_address = await deploy_contract(
        starknet, attack_info, attack_def, hackme_address
    )
    # step 4
    await invoke_method(starknet, attack_info, attack_address, "attack")
    # step 5
    result = await invoke_method(starknet, hackme_info, hackme_address, "owner")
    high, low = divmod(attack_address, 2 ** 128)
    assert result.retdata == [32, 2, high, low]
    shutil.rmtree(tmpdir)
