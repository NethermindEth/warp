import os

import pytest
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import invoke_method

from warp.logging.generateMarkdown import bytecodeDetails, sizeOfFile, stepsInFunction

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = __file__


@pytest.mark.asyncio
async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    sol_file = test_dir[:-8] + ".sol"
    cairo_path = f"{warp_root}/warp/cairo-src"

    # ======= Handwritten Cairo =======
    constructor_inputs = [10000000, 11000000, 10000000, 10, 0x0]

    contractDef = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )
    bytecodeDetails(
        "BaseJumpRateModelV2", contractDef.program.data, "BaseJumpRateModelV2"
    )

    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        contract_def=contractDef, constructor_calldata=constructor_inputs
    )

    exec_info = await contract.getSupplyRate(500, 100, 200, 2).invoke()
    stepsInFunction(
        "BaseJumpRateModelV2", "getSupplyRate", exec_info, "BaseJumpRateModelV2"
    )
    assert exec_info.result._asdict()["res"] == 0

    exec_info = await contract.utilizationRate(500, 100, 200).invoke()
    stepsInFunction(
        "BaseJumpRateModelV2", "utilizationRate", exec_info, "BaseJumpRateModelV2"
    )
    assert exec_info.result._asdict()["res"] == 250000000000000000

    exec_info = await contract.updateJumpRateModel(
        10000000, 11000000, 10000000, 7
    ).invoke()
    stepsInFunction(
        "BaseJumpRateModelV2", "updateJumpRateModel", exec_info, "BaseJumpRateModelV2"
    )

    sizeOfFile("BaseJumpRateModelV2", contract_file, "BaseJumpRateModelV2")

    # ======= Compiled Cairo =======

    program_info = transpile_from_solidity(sol_file, "BaseJumpRateModelV2")
    program_cairo = os.path.join(
        warp_root, "benchmark", "BaseJumpRateModelV2_compiled.cairo"
    )

    with open(program_cairo, "w") as f:
        f.write(program_info["cairo_code"])

    contractDef = compile_starknet_files(
        [program_cairo], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    contract_address = await starknet.deploy(
        contract_definition=contractDef,
        constructor_calldata=[10000000, 0, 11000000, 0, 10000000, 0, 10, 0, 0x0, 0],
    )

    res = await invoke_method(
        starknet, program_info, contract_address, "getSupplyRate", 500, 100, 200, 2
    )
    stepsInFunction(
        "BaseJumpRateModelV2_warp", "getSupplyRate", res, "BaseJumpRateModelV2"
    )
    assert res.retdata == [1, 32, 2, 0, 0]

    res = await invoke_method(
        starknet, program_info, contract_address, "utilizationRate", 500, 100, 200
    )
    stepsInFunction(
        "BaseJumpRateModelV2_warp", "utilizationRate", res, "BaseJumpRateModelV2"
    )
    assert res.retdata == [1, 32, 2, 0, 250000000000000000]

    res = await invoke_method(
        starknet,
        program_info,
        contract_address,
        "updateJumpRateModel",
        10000000,
        11000000,
        10000000,
        7,
    )
    stepsInFunction(
        "BaseJumpRateModelV2_warp", "updateJumpRateModel", res, "BaseJumpRateModelV2"
    )

    sizeOfFile("BaseJumpRateModelV2_warp", program_cairo, "BaseJumpRateModelV2")
    bytecodeDetails(
        "BaseJumpRateModelV2_warp", contractDef.program.data, "BaseJumpRateModelV2"
    )
