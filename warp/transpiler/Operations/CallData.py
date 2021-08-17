from transpiler.Operations.EnforcedStack import EnforcedStack


class CallDataCopy(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="lll", has_output=False)

    def generate_cairo_code(self, dest_offset, offset, length):
        return [
            f"let (local msize) = update_msize(msize, {dest_offset}, {length})",
            "local memory_dict : DictAccess* = memory_dict",
            "array_copy_to_memory(exec_env.input_len, exec_env.input, ",
            f"   {dest_offset}, {offset}, {length})",
            "local memory_dict : DictAccess* = memory_dict",
        ]

    @classmethod
    def required_imports(cls):
        return {
            "evm.array": {"array_copy_to_memory"},
            "evm.utils": {"update_msize"},
        }


class CallDataSize(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=0, has_output=True)

    def generate_cairo_code(self, res):
        return [f"local {res} : Uint256 = Uint256(exec_env.calldata_size, 0)"]


class CallDataLoad(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="l", has_output=True)

    def generate_cairo_code(self, byte_pos, res):
        return [
            f"let (local {res} : Uint256) = "
            f"array_load(exec_env.input_len, exec_env.input, {byte_pos})",
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.array": {"array_load"}}
