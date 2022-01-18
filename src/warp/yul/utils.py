from __future__ import annotations

import json
import os
import re

from warp.kudu import kudu_exe

UPPERCASE_PATTERN = re.compile(r"[A-Z]")


def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix) :]
    return text


def snakify(camel_case: str) -> str:
    """ThisCaseWord -> this_case_word"""
    return remove_prefix(
        UPPERCASE_PATTERN.sub(lambda m: f"_{m.group(0).lower()}", camel_case), "_"
    )


def camelize(snake_case: str) -> str:
    """this_case_word -> ThisCaseWord"""
    parts = snake_case.split("_")
    if not parts:
        return snake_case
    if any(x == "" for x in parts):
        raise ValueError(
            f"Can't camelize {snake_case}."
            " It probably contains several consecutive underscores."
        )
    return "".join(x.capitalize() for x in parts)


def clean_path(sol_source):
    if sol_source.startswith("./"):
        return sol_source[2:]
    else:
        return sol_source


def get_kudu_output(args: list[str], sol_source) -> dict:
    args = ",".join(args)
    with kudu_exe() as exe:
        output_str = (
            os.popen(f"{exe} --combined-json {args} {sol_source}").read().strip()
        )
    output = json.loads(output_str)
    for contract in output["contracts"].keys():
        output_str = output_str.replace(contract, os.path.abspath(contract))
    return json.loads(output_str)


def get_public_functions(sol_source: str, main_contract: str) -> list[str]:
    get_source_version(sol_source)
    sol_source = os.path.abspath(clean_path(sol_source))
    hashes = get_kudu_output(["hashes"], sol_source)
    public_functions = set()
    for v in hashes["contracts"][f"{sol_source}:{main_contract}"]["hashes"].keys():
        public_functions.add(f"fun_{v[:v.find('(')]}")
    return list(public_functions)


def get_function_mutabilities(sol_source, main_contract):
    get_source_version(sol_source)
    sol_source = os.path.abspath(clean_path(sol_source))
    function_visibilities = dict()
    abi = get_kudu_output(["abi"], sol_source)
    for v in abi["contracts"][f"{sol_source}:{main_contract}"]["abi"]:
        if v["type"] == "function":
            function_visibilities[v["name"]] = v["stateMutability"]
    return function_visibilities


def get_for_contract(sol_source, target_contract, output_values):
    get_source_version(sol_source)
    compiled = get_kudu_output(output_values, sol_source)
    for contract, values in compiled["contracts"].items():
        name = contract[contract.find(":") + 1 :]
        if name == target_contract:
            return [values[x] for x in output_values]
    return None


def get_source_version(sol_source: str) -> float:
    with open(sol_source) as f:
        src = f.read()
    code_split = src.split("\n")
    for line in code_split:
        if "pragma" in line:
            ver: float = float(line[line.index("0.") + 2 :].replace(";", ""))
            if ver < 7.6:
                raise Exception(
                    "Please use a version of solidity that is at least 0.7.6"
                )
            return ver
    raise Exception("No Solidity version specified in contract")


def cairoize_bytes(bs: bytes, shifted=False) -> tuple[list[int], int]:
    """Represent bytes as an array of 128-bit big-endian integers and
    return a number of unused bytes in the last array cell.

    'shifted' indicates if 'bs' should be shifted 12-bytes to the
    right, so as to be suitable as Warp calldata.

    """
    if shifted:
        bs = b"\x00" * 12 + bs
    unused_bytes = -len(bs) % 16
    bs = bs.ljust(len(bs) + unused_bytes, b"\x00")
    arr = [int.from_bytes(bs[i : i + 16], "big") for i in range(0, len(bs), 16)]
    return (arr, unused_bytes)
