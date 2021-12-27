import pytest
from starkware.starknet.compiler.compile import compile_starknet_files

from tests.utils import CAIRO_PATH, WARP_ROOT

test_dir = WARP_ROOT / "tests" / "golden"
cairo_files = list(test_dir.glob("*.cairo"))


@pytest.mark.asyncio
@pytest.mark.parametrize(("cairo_file"), cairo_files)
async def test_compilation(cairo_file):
    compile_starknet_files([str(cairo_file)], debug_info=True, cairo_path=[CAIRO_PATH])
