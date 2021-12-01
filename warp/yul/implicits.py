IMPLICITS = {
    "memory_dict": "DictAccess*",
    "msize": None,
    "pedersen_ptr": "HashBuiltin*",
    "range_check_ptr": None,
    "syscall_ptr": "felt*",
    "bitwise_ptr": "BitwiseBuiltin*",
    "exec_env": "ExecutionEnvironment*",
    "termination_token": None,
}

IMPLICITS_SET = set(IMPLICITS.keys())

# Implicits that we create manually, they are not built into Cairo
MANUAL_IMPLICITS = {"memory_dict", "msize", "exec_env", "termination_token"}
assert MANUAL_IMPLICITS.issubset(IMPLICITS_SET)


def print_implicit(name):
    type_ = IMPLICITS.get(name, None)
    if type_ is None:
        return name
    else:
        return f"{name}: {type_}"


def copy_implicit(name):
    return f"local {print_implicit(name)} = {name}"


def initialize_manual_implicit(name):
    assert name in MANUAL_IMPLICITS
    if name == "memory_dict":
        return (
            f"let (memory_dict) = default_dict_new(0)\n"
            f"let memory_dict_start = memory_dict\n"
        )
    elif name == "msize":
        return "let msize = 0\n"
    elif name == "exec_env":
        return (
            f"let (__fp__, _) = get_fp_and_pc()\n"
            f"local exec_env_ : ExecutionEnvironment = ExecutionEnvironment("
            f"calldata_size=calldata_size, calldata_len=calldata_len, calldata=calldata,"
            f"returndata_size=0, returndata_len=0, returndata=cast(0, felt*),"
            f"to_returndata_size=0, to_returndata_len=0, to_returndata=cast(0, felt*))\n"
            f"let exec_env : ExecutionEnvironment* = &exec_env_\n"
        )
    elif name == "termination_token":
        return "let termination_token = 0\n"
    assert False, f"Unhandled manual implicit: '{name}'"


def finalize_manual_implicit(name):
    assert name in MANUAL_IMPLICITS
    if name == "memory_dict":
        return "default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
    else:
        return ""
