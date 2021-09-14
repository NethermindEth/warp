import pytest
import os

from starknet.compile import compile_starknet_files

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.join(warp_root, "tests", "yul")
cairo_files = [os.path.join(test_dir, item) for item in os.listdir(test_dir) if item.endswith('.cairo')]

@pytest.mark.asyncio
@pytest.mark.parametrize(("cairo_file"), cairo_files)
async def test_compilation(cairo_file):
    contract_file = os.path.join(test_dir, cairo_file)
    cairo_path = f"{warp_root}/warp/cairo-src"
    contract_definition = compile_starknet_files([contract_file], debug_info=True, cairo_path=[cairo_path])