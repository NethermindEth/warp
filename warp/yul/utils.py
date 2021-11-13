from __future__ import annotations

import json
import os
import re
from typing import List, Optional, Sequence

UPPERCASE_PATTERN = re.compile(r"[A-Z]")

STATEMENT_STRINGS = {
    "ExpressionStatement",
    "Assignment",
    "VariableDeclaration",
    "FunctionDefinition",
    "If",
    "Switch",
    "ForLoop",
    "Break",
    "Continue",
    "Leave",
    "Block",
}

UNSUPPORTED_BUILTINS = [
    "balance",
    "basefee",
    "blockhash",
    "chainid",
    "codecopy",
    "codesize",
    "coinbase",
    "create2",
    "delegatecall",
    "difficulty",
    "extcodecopy",
    "extcodehash",
    "extcodesize",
    "gaslimit",
    "gasprice",
    "invalid",
    "log0",
    "log1",
    "log2",
    "log3",
    "log4",
    "number",
    "origin",
    "pc",
    "selfbalance",
    "selfdestruct",
    "timestamp",
]

HANDLERS_DECL = """
@storage_var
func this_address() -> (res: felt):
end

@storage_var
func address_initialized() -> (res : felt):
end

func initialize_address{range_check_ptr, syscall_ptr: felt*, pedersen_ptr : HashBuiltin*}(self_address : felt):
    let (address_init) = address_initialized.read()
    if address_init == 1:
        return ()
    end
    this_address.write(self_address)
    address_initialized.write(1)
    return ()
end
"""


def get_low_bits(string: str) -> str:
    return get_low_high(string)[0]


def get_low_high(string: str) -> str:
    try:
        value = int(string)
        high, low = divmod(value, 2 ** 128)
        return f"{low}", f"{high}"
    except ValueError:
        return f"{string}.low", f"{string}.high"


def is_statement(node):
    return type(node).__name__ in STATEMENT_STRINGS


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


def get_kudu_output(args: List[str], sol_source) -> dict:
    args = ",".join(args)
    output_str = os.popen(f"kudu --combined-json {args} {sol_source}").read().strip()
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


def cairoize_bytes(bs: bytes) -> tuple(List[int], int):
    """Represent bytes as an array of 128-bit big-endian integers and
    return a number of unused bytes in the last array cell.
    """
    unused_bytes = -len(bs) % 16
    bs = bs.ljust(len(bs) + unused_bytes, b"\x00")
    arr = [int.from_bytes(bs[i : i + 16], "big") for i in range(0, len(bs), 16)]
    return (arr, unused_bytes)


def make_abi_StarkNet_encodable(abi):
    """
    Because we need 31 byte addresses for starknet, we need to encode them as uint256,
    but if we pass an abi with address types to solcx, it will try to validate the address by
    checksum & making sure it's 20-bytes. So we just change the address abi types to uint256.
    This is fine because our fork of solc treats address types as uint256 anyway.
    We will replace this hackery with our own encoder in the future.
    """
    abiStr = f"{abi}".replace("'address'", "'uint256'")
    abiStr = abiStr.replace("'", '"')
    return json.loads(abiStr)
