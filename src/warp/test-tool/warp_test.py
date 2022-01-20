import json
import os
import re
from pathlib import Path, PurePath

import pkg_resources
import pytest
import pytest_check as check
from starkware.cairo.lang.vm.vm_exceptions import VmException
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from starkware.starkware_utils.error_handling import StarkException

from warp.yul.main import transpile_from_solidity
from warp.yul.starknet_utils import (
    deploy_contract,
    deploy_contract_evm_calldata,
    invoke_method_evm_calldata,
)

CONTRACT_DEF_REGEX = re.compile(r"contract\s+(\w+)\s+")
CONTRACTS_DIR = os.path.join(os.getcwd(), "contracts")
TEST_CALLDATA = os.path.join(CONTRACTS_DIR, "test_calldata.json")


def get_last_contract(contract_file):
    contract_name = None
    with open(contract_file, "r") as contract:
        lines = contract.readlines()
        for line in lines:
            matches = CONTRACT_DEF_REGEX.match(line)
            if matches:
                contract_name = matches.groups()[0]

    if contract_name:
        return contract_name

    pytest.skip(f"Could not find any contract definitions in {contract_file}")


def load_test_calldata():
    with open(TEST_CALLDATA) as calldata:
        return json.load(calldata)


test_calldata = load_test_calldata()


async def starknet_compile(contract_file):
    cairo_path = os.path.abspath(
        os.path.join(
            PurePath(pkg_resources.get_distribution("sol-warp").location),
            "warp",
            "cairo-src",
        )
    )
    return compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )


def sol_files_in_dir(folder):
    # calling str on PosixPath, so that when the test fails it shows the file
    # name instead of an object
    return [str(f) for f in Path(folder).glob("**/*.sol")]


def split_expectations(expectations):
    constructor_expectations = []
    contract_expectations = []

    for e in expectations:
        if e["signature"] == "constructor()":
            constructor_expectations.append(e)
        else:
            contract_expectations.append(e)

    if len(constructor_expectations) == 1:
        return constructor_expectations[0]["callData"], contract_expectations

    return None, contract_expectations


def get_expectations(contract_file):
    expectations = test_calldata[os.path.abspath(contract_file)]

    if not expectations:
        pytest.skip("Invalid expectations for {contract_path}")

    return split_expectations(expectations)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "contract_file", sol_files_in_dir(os.path.join(os.getcwd(), "contracts"))
)
async def test_contracts(contract_file):
    constructor_args, contract_expectations = get_expectations(contract_file)

    program_info = transpile_from_solidity(
        contract_file, get_last_contract(contract_file)
    )

    cairo_code = program_info["cairo_code"]
    cairo_file_path = f"{os.path.splitext(contract_file)[0]}.cairo.temp"

    with open(cairo_file_path, "w") as fp:
        fp.write(cairo_code)

    contract_definition = await starknet_compile(cairo_file_path)

    starknet = await StarknetState.empty()
    contract_address = None
    if constructor_args:
        constructor_args = bytes.fromhex(constructor_args[2:])
        contract_address = await deploy_contract_evm_calldata(
            starknet, contract_definition, constructor_args
        )
    else:
        contract_address = await deploy_contract(
            starknet,
            program_info,
            contract_definition,
        )

    for test_info in contract_expectations:
        expected_result = test_info["expectations"]
        argument = bytes.fromhex(test_info["callData"][2:])

        if test_info["failure"]:
            try:
                await invoke_method_evm_calldata(starknet, contract_address, argument)
            except (VmException, StarkException):
                os.remove(cairo_file_path)
                return
        else:
            res = await invoke_method_evm_calldata(starknet, contract_address, argument)

            result_size, result_len, *result = res.retdata
            if result:
                result = [r.to_bytes(16, "big") for r in result]
                final_res = result[0]
                for r in result[1:]:
                    final_res = final_res + r
                final_res = "0x" + final_res.hex()

                check.equal(final_res, expected_result, cairo_file_path)

    os.remove(cairo_file_path)
