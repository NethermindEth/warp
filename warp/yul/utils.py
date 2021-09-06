import re

UPPERCASE_PATTERN = re.compile(r"[A-Z]")

statementStings = ["ExpressionStatement",
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
]

def get_low_bits(string: str) -> str:
    try:
        value = int(string)
        high, low = divmod(value, 2**128)
        return f"Uint256({low}, 0)"
    except ValueError:
        return f"{string}.low"

def get_low_high(string: str) -> str:
    try:
        value = int(string)
        high, low = divmod(value, 2**128)
        return f"{low}", f"{high}"
    except ValueError:
        return f"{string}.low", f"{string}.high"

def is_statement(node):
    node_str = node.__repr__()
    node_type = node_str[:node_str.find('(')]

    return node_type in statementStings

def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text

def snakify(camel_case: str) -> str:
    """ThisCaseWord -> this_case_word"""
    return remove_prefix(UPPERCASE_PATTERN.sub(
        lambda m: f"_{m.group(0).lower()}", camel_case
    ),"_")


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