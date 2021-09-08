import pytest
import os
import subprocess

from starkware.starknet.compiler.compile import (compile_starknet_files)
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.services.api.contract_definition import ContractDefinition

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.join(warp_root, "tests", "yul")
cairo_files = [os.path.join(test_dir, item) for item in os.listdir(test_dir) if item.endswith('.gold.cairo')]

@pytest.mark.asyncio
@pytest.mark.parametrize(("cairo_file"), cairo_files)
async def test_compilation(cairo_file):
    contract_file = os.path.join(test_dir, cairo_file)
    # contract_definition = compile_starknet_files([contract_file], debug_info=True)

    compiled_file = f"{contract_file[:-15]}_compiled.json"
    abi_file = f"{contract_file[:-15]}_abi.json"
    completed_process = subprocess.run([
                            "starknet-compile",
                            "--disable_hint_validation",
                            f"{contract_file}",
                            "--output",
                            compiled_file,
                            "--abi",
                            abi_file,
                            "--cairo_path",
                            f"{warp_root}/warp/cairo-src"
                        ])
    assert completed_process.returncode == 0
    
    with open(compiled_file, 'r') as f:
        contract = f.read()
    contract_definition = ContractDefinition.loads(contract)
    
    starknet = await Starknet.empty()
    contract_address = await starknet.deploy(contract_definition=contract_definition)
    
    os.remove(compiled_file)
    os.remove(abi_file)