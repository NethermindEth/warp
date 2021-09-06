from __future__ import annotations
from utils import get_low_bits, get_low_high

UINT256_MODULE = "starkware.cairo.common.uint256"

BUILTIN_NAME_MAP = {
    "iszero": "is_zero",
    "eq": "is_eq",
    "gt": "is_gt",
    "lt": "is_lt",
    "slt": "slt",
    "sgt": "sgt",
    "smod": "smod",
    "exp": "uint256_exp",
    "mulmod": "uint256_mulmod",
    "mstore8": "mstore8",
    "mstore": "mstore",
    "mload": "mload",
    "add": "uint256_add",
    "and": "uint256_and",
    "sub": "uint256_sub",
    "mul": "uint256_mul",
    "div": "uint256_unsigned_div_rem",
    "sdiv": "uint256_signed_div_rem",
    "mod": "uint256_mod",
    "not": "uint256_not",
    "or": "uint256_or",
    "xor": "uint256_xor",
    "byte": "uint256_byte",
    "shl": "uint256_shl",
    "shr": "uint256_shr",
    "sar": "uint256_sar",
    "addmod": "uint256_addmod",
    "signextend": "uint256_signextend",
}


class BuiltinHandler:
    def __init__(
        self,
        module: str,
        function_name: str,
        function_args: str,
        preamble: str = "",
        ref_copy: str = "",
    ):
        self.module = module
        self.function_name = function_name
        self.function_args = function_args
        self.preamble = preamble
        self.ref_copy = ref_copy
        self.function_call = f"{self.function_name}({self.function_args})"
        self.generated_cairo = self.generate_cairo()

    def required_imports(self):
        if self.module == "":
            return {"": {""}}
        return {self.module: {self.function_name}}

    def generate_cairo(self):
        return f"""
{self.preamble}{self.function_call}
{self.ref_copy}
"""


# ============ Comparisons ============
class IsZero(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_zero",
            function_args=function_args,
        )


class Eq(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_eq",
            function_args=function_args,
        )


class Lt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_lt",
            function_args=function_args,
            ref_copy="\nlocal memory_dict : DictAccess* = memory_dict",
        )


class Gt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_gt",
            function_args=function_args,
            preamble="",
            ref_copy="",
        )


class Slt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="slt",
            function_args=function_args,
        )


class Sgt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="sgt",
            function_args=function_args,
        )


# ============ Bitwise ============
class And(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_and",
            function_args=function_args,
        )


class Or(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_or",
            function_args=function_args,
        )


class Not(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_not",
            function_args=function_args,
        )


class Xor(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_xor",
            function_args=function_args,
        )


class Shl(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_shl",
            function_args=function_args,
        )


class Shr(BuiltinHandler):  # ARG ORDER NOT CONVENTIONAL
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_shl",
            function_args=function_args,
        )


class Sar(BuiltinHandler):  # ARG ORDER NOT CONVENTIONAL
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_sar",
            function_args=function_args,
        )


class Byte(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_byte",
            function_args=function_args,
        )


# ============ Arithmetic ============
class Add(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_add",
            function_args=function_args,
        )


class Mul(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_mul",
            function_args=function_args,
        )


class Sub(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_sub",
            function_args=function_args,
        )


class Div(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_unsigned_div_rem",
            function_args=function_args,
        )


class Sdiv(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_signed_div_rem",
            function_args=function_args,
        )


class Exp(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_exp",
            function_args=function_args,
        )


class Mod(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_mod",
            function_args=function_args,
        )


class SMod(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="smod",
            function_args=function_args,
        )


class AddMod(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_addmod",
            function_args=function_args,
        )


class MulMod(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_mulmod",
            function_args=function_args,
        )


class SignExtend(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_signextend",
            function_args=function_args,
        )


# ============ Memory ============
class MStore(BuiltinHandler):
    def __init__(self, function_args: str):
        self.address = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore",
            function_args=function_args,
            preamble=f"""let (local msize) = update_msize{{range_check_ptr=range_check_ptr}}(msize, {self.address}, 32)
local memory_dict : DictAccess* = memory_dict
local msize = msize\n""",
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"mstore(offset={self.address}, value={self.value})"
        self.generated_cairo = self.generate_cairo()

    def generate_cairo(self):
        return f"""
{self.preamble}mstore(offset={self.address}, value=byte)
{self.ref_copy}"""

    def required_imports(self):
        return {
            "evm.memory": {"mstore"},
            "starkware.cairo.common.dict_access": {"DictAccess"},
        }


class MStore8(BuiltinHandler):
    def __init__(self, function_args: str):
        self.address: str = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore8",
            function_args=function_args,
            preamble=f"let (local msize) = update_msize{{range_check_ptr=range_check_ptr}}(msize, {self.address}, 1)"
            f"local memory_dict : DictAccess* = memory_dict"
            f"local msize = msize"
            f"let (local byte, _) = extract_lowest_byte({self.value})",
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )

    def generate_cairo(self):
        return f"""
{self.preamble}
mstore8(offset={self.address}, byte=byte)
{self.ref_copy}
"""

    def required_imports(self):
        return {
            "evm.memory": {"mstore8"},
            "evm.uint256": {"extract_lowest_byte"},
            "evm.utils": {"update_msize"}
        }


class MLoad(BuiltinHandler):
    def __init__(self, function_args: str):
        self.address: str = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.uint256",
            function_name="uint256_signextend",
            function_args=function_args,
            preamble=f"let (local msize) = update_msize{{range_check_ptr=range_check_ptr}}(msize, {self.address}, 1)"
            f"local memory_dict : DictAccess* = memory_dict"
            f"local msize = msize",
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )

    def required_imports(self):
        return {"evm.memory": {"mload"}, "evm.utils": {"update_msize"}}


class MSize(BuiltinHandler):
    @classmethod
    def proceed(self, res_ref_name):
        return [
            "let (local immediate) = round_up_to_multiple(msize, 32)",
            f"local {res_ref_name} : Uint256 = Uint256(immediate, 0)",
        ]

    def required_imports(self):
        return {"evm.utils": {"round_up_to_multiple"}}


# ============ Storage ============
class SStore(BuiltinHandler):
    def __init__(self, function_args: str):
        self.key: str = function_args.split(",")[0].strip()
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="",
            function_name="s_store",
            function_args=function_args,
            preamble="",
            ref_copy="local pedersen_ptr : HashBuiltin* = pedersen_ptr\n\
            local storage_ptr : Storage* = storage_ptr",
        )
        self.function_call = f"s_store(key={self.key},value={self.value})"


class SLoad(BuiltinHandler):
    def __init__(self, function_args: str):
        self.key: str = function_args.split(",")[0].strip()
        super().__init__(
            module="",
            function_name="s_store",
            function_args=function_args,
            preamble="",
            ref_copy="local pedersen_ptr : HashBuiltin* = pedersen_ptr\n\
            local storage_ptr : Storage* = storage_ptr",
        )
        self.function_call = f"s_load(key={self.key})"


# ============ Keccak ============
class SHA3(BuiltinHandler):
    def __init__(self, function_args: str):
        self.offset = get_low_bits(function_args.split(",")[0].strip())
        self.length: str = get_low_bits(function_args.split(",")[1].strip())
        super().__init__(
            module="",
            function_name="sha",
            function_args=function_args,
            preamble="",
            ref_copy=f"local msize = msize"
            "local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"sha({self.offset}, {self.length})\nlocal msize = msize\n"\
            f"local memory_dict : DictAccess* = memory_dict"

    def required_imports(self):
        return {"evm.sha3": {"sha"}}


YUL_BUILTINS_MAP = {
    "iszero": IsZero,
    "eq": Eq,
    "gt": Gt,
    "lt": Lt,
    "slt": Slt,
    "sgt": Sgt,
    "smod": SMod,
    "exp": Exp,
    "keccak256": SHA3,
    "mulmod": MulMod,
    "sstore": SStore,
    "sload": SLoad,
    "mstore8": MStore8,
    "mstore": MStore,
    "mload": MLoad,
    "msize": MSize,
    "add": Add,
    "and": And,
    "sub": Sub,
    "mul": Mul,
    "div": Div,
    "sdiv": Sdiv,
    "mod": Mod,
    "not": Not,
    "or": Sub,
    "xor": Xor,
    "byte": Byte,
    "shl": Shl,
    "shr": Shr,
    "sar": Sar,
    "addmod": AddMod,
    "signextend": SignExtend,
}
