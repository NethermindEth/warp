from transpiler.Operations.EnforcedStack import EnforcedStack


class CallDataCopy(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="lll", has_output=False)

    def generate_cairo_code(self, dest_offset, offset, length):
        return [
            "local pedersen_ptr : HashBuiltin* = pedersen_ptr",
            "local memory_dict : DictAccess* = memory_dict",
            "local storage_ptr : Storage* = storage_ptr",
            f"let (local msize) = update_msize(msize, {dest_offset}, {length})",
            "copy_to_memory(exec_env.input_len, exec_env.input, ",
            f"   {dest_offset}, {offset}, {length})",
        ]

    @classmethod
    def required_imports(cls):
        return {
            "evm.array": {"copy_to_memory"},
            "evm.utils": {"update_msize"},
        }


class CallDataSize(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=0, has_output=True)

    def generate_cairo_code(self, res):
        return [f"let {res} = exec_env.input_len"]


class CallDataLoad(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="l", has_output=True)

    def generate_cairo_code(self, byte_pos, res):
        return [
            "local pedersen_ptr : HashBuiltin* = pedersen_ptr",
            "local memory_dict : DictAccess* = memory_dict",
            "local storage_ptr : Storage* = storage_ptr",
            f"let (local {res} : Uint256) = aload(exec_env.input_len, exec_env.input, {byte_pos})",
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.array": {"aload"}}
