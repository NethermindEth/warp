from __future__ import annotations
from utils import get_low_bits

UINT256_MODULE = "starkware.cairo.common.uint256"


class BuiltinHandler:
    def __init__(
        self,
        module: str,
        function_name: str,
        function_args: str,
        ref_copy: str = "",  # TODO replace with a simple bool
    ):
        self.module = module
        self.function_name = function_name
        self.function_args = function_args
        self.ref_copy = ref_copy
        self.function_call = f"{self.function_name}({self.function_args})"

    def required_imports(self):
        if self.module == "":
            return {}
        return {self.module: {self.function_name}}


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
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )


class Gt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_gt",
            function_args=function_args,
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
            function_name="uint256_shr",
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
            module="evm.uint256",
            function_name="u256_add",
            function_args=function_args,
        )


class Mul(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="u256_mul",
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
            module="evm.uint256",
            function_name="u256_div",
            function_args=function_args,
        )


class Sdiv(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="u256_sdiv",
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
            function_name="mstore_",
            function_args=function_args,
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"mstore_(offset={self.address}, value={self.value})"


class MStore8(BuiltinHandler):
    def __init__(self, function_args: str):
        self.address: str = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore8_",
            function_args=function_args,
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"mstore8_(offset={self.address}, byte={self.value})"


class MLoad(BuiltinHandler):
    def __init__(self, function_args: str):
        self.offset: str = get_low_bits(function_args.split(",")[0].strip())
        super().__init__(
            module="evm.memory",
            function_name="mload_",
            function_args=function_args,
            ref_copy="local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"mload_({self.offset})"


class MSize(BuiltinHandler):
    def __init__(self, function_args):
        super().__init__(
            module="evm.memory",
            function_name="get_msize",
            function_args=function_args,
        )


# ============ Storage ============
class SStore(BuiltinHandler):
    def __init__(self, function_args: str):
        self.key: str = function_args.split(",")[0].strip()
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="",
            function_name="s_store",
            function_args=function_args,
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
            ref_copy="local pedersen_ptr : HashBuiltin* = pedersen_ptr\n\
            local storage_ptr : Storage* = storage_ptr",
        )
        self.function_call = f"s_load({self.key})"


# ============ Keccak ============
class SHA3(BuiltinHandler):
    def __init__(self, function_args: str):
        self.offset = get_low_bits(function_args.split(",")[0].strip())
        self.length: str = get_low_bits(function_args.split(",")[1].strip())
        super().__init__(
            module="",
            function_name="sha",
            function_args=function_args,
            ref_copy=f"local msize = msize\n"
            "local memory_dict : DictAccess* = memory_dict",
        )
        self.function_call = f"sha({self.offset}, {self.length})"

    def required_imports(self):
        return {"evm.sha3": {"sha"}}


# ============ Call Data ============
class Caller(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.calls",
            function_name="get_caller_data_uint256",
            function_args=function_args,
        )


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
    "caller": Caller,
}
