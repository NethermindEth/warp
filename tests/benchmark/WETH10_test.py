import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.state import StarknetState

from tests.logging.generateMarkdown import (
    bytecode_details,
    size_of_file,
    steps_in_function,
)
from tests.utils import CAIRO_PATH, WARP_ROOT
from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import deploy_contract, invoke_method

test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    sol_file = test_dir[:-8] + ".sol"

    # ======= Handwritten Cairo =======
    contractDef = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[CAIRO_PATH]
    )
    bytecode_details("WETH10", contractDef.program.data, "WETH10")
    size_of_file("WETH10", contract_file, "WETH10")

    starknet = await Starknet.empty()
    contract = await starknet.deploy(contract_def=contractDef, constructor_calldata=[])

    exec_info = await contract.totalSupply().invoke()
    steps_in_function("WETH10", "totalSupply", exec_info, "WETH10")
    assert exec_info.result._asdict()["res"] == 0

    # exec_info = await contract.receive(100).invoke()
    # steps_in_function("WETH10", "receive", exec_info)

    exec_info = await contract.deposit(100).invoke()
    steps_in_function("WETH10", "deposit", exec_info, "WETH10")

    exec_info = await contract.depositTo(0x0, 100).invoke()
    steps_in_function("WETH10", "depositTo", exec_info, "WETH10")

    exec_info = await contract.maxFlashLoan(0x0).invoke()
    steps_in_function("WETH10", "maxFlashLoan", exec_info, "WETH10")
    assert exec_info.result._asdict()["res"] == 0

    exec_info = await contract.flashFee(contract.contract_address, 100).invoke()
    steps_in_function("WETH10", "flashFee", exec_info, "WETH10")
    assert exec_info.result._asdict()["success"] == 0

    # exec_info = await contract.withdraw(100).invoke()
    # steps_in_function("WETH10", "withdraw", exec_info)

    # exec_info = await contract.withdrawTo(0x0, 100).invoke()
    # steps_in_function("WETH10", "withdrawTo", exec_info)

    # exec_info = await contract.withdrawFrom(0x0, 0x1, 100).invoke()
    # steps_in_function("WETH10", "withdrawFrom", exec_info)

    exec_info = await contract.approve(0x0, 10).invoke()
    steps_in_function("WETH10", "approve", exec_info, "WETH10")
    assert exec_info.result._asdict()["success"] == 1

    exec_info = await contract.transfer(0x1, 0).invoke()
    steps_in_function("WETH10", "transfer", exec_info, "WETH10")
    assert exec_info.result._asdict()["success"] == 1

    exec_info = await contract.transferFrom(0x0, 0x1, 0).invoke()
    steps_in_function("WETH10", "transferFrom", exec_info, "WETH10")
    assert exec_info.result._asdict()["success"] == 1

    # ======= Compiled Cairo =======

    program_info = transpile_from_solidity(sol_file, "WETH10")
    program_cairo = os.path.join(WARP_ROOT, "benchmark/tmp", "WETH10_warp.cairo")

    with open(program_cairo, "w") as f:
        f.write(program_info["cairo_code"])

    contractDef = compile_starknet_files(
        [program_cairo], debug_info=True, cairo_path=[CAIRO_PATH]
    )

    starknet = await StarknetState.empty()
    contract_address: int = await deploy_contract(starknet, program_info, contractDef)
    bytecode_details("WETH10_warp", contractDef.program.data, "WETH10")
    size_of_file("WETH10_warp", program_cairo, "WETH10")

    res = await invoke_method(
        starknet,
        program_info,
        contract_address,
        "totalSupply",
    )
    steps_in_function("WETH10_warp", "totalSupply", res, "WETH10")
    assert res.retdata == [32, 2, 0, 0]

    res = await invoke_method(starknet, program_info, contract_address, "deposit", 100)
    steps_in_function("WETH10_warp", "deposit", res, "WETH10")

    res = await invoke_method(
        starknet, program_info, contract_address, "depositTo", 0x0, 100
    )
    steps_in_function("WETH10_warp", "depositTo", res, "WETH10")

    res = await invoke_method(
        starknet, program_info, contract_address, "maxFlashLoan", 0x0
    )
    steps_in_function("WETH10_warp", "maxFlashLoan", res, "WETH10")
    assert res.retdata == [32, 2, 0, 0]

    res = await invoke_method(
        starknet, program_info, contract_address, "flashFee", contract_address, 100
    )
    steps_in_function("WETH10_warp", "flashFee", res, "WETH10")
    assert res.retdata == [32, 2, 0, 0]

    # res = await invoke_method(starknet, program_info, contract_address, "withdraw", 100)
    # steps_in_function("WETH10_warp", "withdraw", res)

    # res = await invoke_method(
    #     starknet, program_info, contract_address, "withdrawTo", 0x0, 100
    # )
    # steps_in_function("WETH10_warp", "withdrawTo", res)

    # res = await invoke_method(
    #     starknet, program_info, contract_address, "withdrawFrom", 0x0, 0x1, 100
    # )
    # steps_in_function("WETH10_warp", "withdrawFrom", res)

    res = await invoke_method(
        starknet, program_info, contract_address, "approve", 0x0, 10
    )
    steps_in_function("WETH10_warp", "approve", res, "WETH10")
    assert res.retdata == [32, 2, 0, 1]

    res = await invoke_method(
        starknet, program_info, contract_address, "transfer", 0x1, 0
    )
    steps_in_function("WETH10_warp", "transfer", res, "WETH10")
    assert res.retdata == [32, 2, 0, 1]

    res = await invoke_method(
        starknet, program_info, contract_address, "transferFrom", 0x0, 0x1, 0
    )
    steps_in_function("WETH10_warp", "transferFrom", res, "WETH10")
    assert res.retdata == [32, 2, 0, 1]
