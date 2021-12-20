import asyncio
import json
import os
import re
from pathlib import Path

import pytest
import pytest_check as check
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState
from yul.main import transpile_from_solidity
from yul.starknet_utils import (
    deploy_contract,
    deploy_contract_evm_calldata,
    invoke_method,
    invoke_method_evm_calldata,
)

semantic_tests_folder = os.path.dirname(__file__)
warp_root = os.path.join(semantic_tests_folder, "../../")
test_folder = os.path.join(
    semantic_tests_folder, "solidity/test/libsolidity/semanticTests"
)

CONTRACT_DEF_REGEX = re.compile(r"contract\s+(\w+)\s+")


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


def load_ignore_list():
    with open(
        os.path.abspath(os.path.join(semantic_tests_folder, "ignore_files.json"))
    ) as ignore_list:
        data = json.load(ignore_list)

        if data:
            return data["files"]

    pytest.skip("Ignore list not found")


def load_test_calldata():
    with open(
        os.path.abspath(os.path.join(semantic_tests_folder, "test_calldata.json"))
    ) as calldata:
        return json.load(calldata)

    pytest.skip("calldata for tests could not be loaded")


ignore_list = load_ignore_list()
test_calldata = load_test_calldata()


async def starknet_compile(contract_file):
    cairo_path = f"{warp_root}/warp/cairo-src"
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
        constructor_expectations.append(e) if e[
            "signature"
        ] == "constructor()" else contract_expectations.append(e)

    if len(constructor_expectations) == 1:
        return constructor_expectations[0]["callData"], contract_expectations

    return None, contract_expectations


def get_expectations(contract_file):
    split_path = Path(contract_file).parts
    libsolidity_folder_index = split_path.index("libsolidity")
    contract_path = (
        f"./scripts/../test/{str(Path(*split_path[libsolidity_folder_index:]))}"
    )
    expectations = test_calldata[contract_path]

    if not expectations:
        pytest.skip("Invalid expectations for {contract_path}")

    return split_expectations(expectations)


def ignore_file(contract_file, ignore_list):
    split_path = Path(contract_file).parts
    solidity_test_folder = split_path.index("solidity")
    contract_path = str(Path(*split_path[solidity_test_folder:]))
    if contract_path in ignore_list:
        pytest.skip(f"{contract_file} is in the ignore list")


@pytest.mark.asyncio
@pytest.mark.parametrize("contract_file", sol_files_in_dir(test_folder))
async def test_semantics(contract_file):
    ignore_file(contract_file, ignore_list)

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
        constract_address = await deploy_contract_evm_calldata(
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

        print(test_info)
        if test_info["failure"]:
            with pytest.raises(Exception) as e:
                # Narrow down the list of permissible exceptions
                await invoke_method_evm_calldata(starknet, contract_address, argument)
        else:
            res = await invoke_method_evm_calldata(starknet, contract_address, argument)

            result_size, result_len, *result = res.retdata

            if result:
                result = [r.to_bytes(16, "big") for r in result]
                final_res = result[0]
                for r in result[1:]:
                    final_res = final_res + r
                final_res = "0x" + final_res.hex()

                # TODO convert the expected_result to uint256
                check.equal(final_res, expected_result, cairo_file_path)

    os.remove(cairo_file_path)


async def main():
    compiled_files = [
        test_semantics(sol_file) for sol_file in sol_files_in_dir(test_folder)
    ]
    await asyncio.gather(*compiled_files)


if __name__ == "__main__":
    asyncio.run(main())
