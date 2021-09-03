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

YUL_BUILTINS_MAP = {
	'iszero': 'is_zero',
	'eq': 'is_eq',
	'gt': 'is_gt',
	'lt': 'is_lt',
	'slt': 'slt',
	'sgt': 'sgt',
	'smod': 'smod',
	'exp': 'uint256_exp',
	'mulmod': 'uint256_mulmod',
	'mstore8': 'mstore8',
	'mstore': 'mstore',
	'mload': 'mload',
	'add': 'uint256_add',
	'and': 'uint256_and',
	'sub': 'uint256_sub',
	'mul': 'uint256_mul',
	'div': 'uint256_unsigned_div_rem',
	'sdiv': 'uint256_signed_div_rem',
	'mod': 'uint256_mod',
	'not': 'uint256_not',
	'or': 'uint256_or',
	'xor': 'uint256_xor',
	'byte': 'uint256_byte',
	'shl': 'uint256_shl',
	'shr': 'uint256_shr',
	'sar': 'uint256_sar',
	'addmod': 'uint256_addmod',
	'signextend': 'uint256_signextend'
}

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
