from transpiler.Operations.EnforcedStack import EnforcedStack


class SHA3(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="ll", n_args=2, has_output=True)

    def generate_cairo_code(self, offset, length, output):
        return [
            f"let (local {output} : Uint256) = sha({offset}, {length})",
            f"local msize = msize",
            "local memory_dict : DictAccess* = memory_dict",
        ]

    def required_imports(self):
        return {"evm.sha3": {"sha"}}


class Keccak256(EnforcedStack):
    def __init__(self):
        super().__init__(args_spec="ll", n_args=2, has_output=True)

    def generate_cairo_code(self, offset, length, output):
        return [
            f"let (local {output} : Uint256) = sha({offset}, {length})",
            f"local msize = msize",
            "local memory_dict : DictAccess* = memory_dict",
        ]

    def required_imports(self):
        return {"evm.sha3": {"sha"}}
