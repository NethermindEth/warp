from __future__ import annotations

import re
import solcx

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


def get_low_bits(string: str) -> str:
    try:
        value = int(string)
        high, low = divmod(value, 2 ** 128)
        return f"Uint256({low}, 0)"
    except ValueError:
        return f"{string}.low"


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


STORAGE_DECLS = """

@storage_var
func evm_storage(low: felt, high: felt, part: felt) -> (res : felt):
end

func s_load{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        key: Uint256) -> (res : Uint256):
    let (low_r) = evm_storage.read(key.low, key.high, 1)
    let (high_r) = evm_storage.read(key.low, key.high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        key: Uint256, value: Uint256):
    evm_storage.write(low=key.low, high=key.high, part=1, value=value.low)
    evm_storage.write(low=key.low, high=key.high, part=2, value=value.high)
    return ()
end

@view
func get_storage_low{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end
"""


def get_public_functions(sol_source: str) -> list[str]:
    validate_solc_ver(sol_source)

    public_functions = set()
    abi = solcx.compile_source(sol_source, output_values=["hashes"])
    for value in abi.values():
        for v in value["hashes"]:
            public_functions.add(f"fun_{v[:v.find('(')]}")
    return list(public_functions)


def get_function_mutabilities(sol_source: str) -> dict[str, str]:
    validate_solc_ver(sol_source)

    function_visibilities = dict()
    abi = solcx.compile_source(sol_source)

    for value in abi.values():
        for v in value["abi"]:
            if v["type"] == "function":
                function_visibilities[v["name"]] = v["stateMutability"]
    return function_visibilities


def validate_solc_ver(sol_source):
    solc_version: float = get_source_version(sol_source)
    src_ver: str = check_installed_solc(solc_version)
    solcx.set_solc_version(src_ver)


def get_source_version(sol_source: str) -> float:
    code_split = sol_source.split("\n")
    for line in code_split:
        if "pragma" in line:
            ver: float = float(line[line.index("0.") + 2 :].replace(";", ""))
            if ver < 8.0:
                raise Exception(
                    "Please use a version of solidity that is at least 0.8.0"
                )
            return ver
    raise Exception("No Solidity version specified in contract")


def check_installed_solc(source_version: float) -> str:
    solc_vers = solcx.get_installed_solc_versions()
    vers_clean = []
    src_ver = "0." + str(source_version)
    for ver in solc_vers:
        vers_clean.append(".".join(str(x) for x in list(ver.precedence_key)[:3]))
    if src_ver not in vers_clean:
        solcx.install_solc(src_ver)
    return src_ver
