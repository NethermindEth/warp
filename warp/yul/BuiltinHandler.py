from __future__ import annotations

from yul.FunctionGenerator import CairoFunctions
from yul.utils import get_low_bits

UINT256_MODULE = "starkware.cairo.common.uint256"


class BuiltinHandler:
    def __init__(
        self,
        module: str,
        function_name: str,
        function_args: str,
        cairo_functions: CairoFunctions,
        used_implicits: tuple[str] = ("range_check_ptr",),
    ):
        self.module = module
        self.function_name = function_name
        self.function_args = function_args
        self.cairo_functions = cairo_functions
        self.used_implicits = used_implicits
        self.function_call = f"{self.function_name}({self.function_args})"

    def required_imports(self):
        if self.module == "":
            return {}
        return {self.module: {self.function_name}}


# ============ Comparisons ============
class IsZero(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="is_zero",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Eq(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="is_eq",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Lt(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="is_lt",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Gt(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="is_gt",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Slt(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="slt",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Sgt(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="sgt",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


# ============ Bitwise ============
class And(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_and",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Or(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_or",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Not(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_not",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Xor(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_xor",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Shl(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_shl",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Shr(BuiltinHandler):  # ARG ORDER NOT CONVENTIONAL
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_shr",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Sar(BuiltinHandler):  # ARG ORDER NOT CONVENTIONAL
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_sar",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Byte(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_byte",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


# ============ Arithmetic ============
class Add(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="u256_add",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Mul(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="u256_mul",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Sub(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_sub",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Div(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="u256_div",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Sdiv(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="u256_sdiv",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Exp(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module=UINT256_MODULE,
            function_name="uint256_exp",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class Mod(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_mod",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class SMod(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="smod",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class AddMod(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_addmod",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class MulMod(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_mulmod",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


class SignExtend(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.uint256",
            function_name="uint256_signextend",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )


# ============ Memory ============
class MStore(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        self.address = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore_",
            function_args=function_args,
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"mstore_(offset={self.address}, value={self.value})"


class MStore8(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        self.address: str = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore8_",
            function_args=function_args,
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"mstore8_(offset={self.address}, value={self.value})"


class MLoad(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        if "Uint256(low=" in function_args:
            self.offset = function_args[function_args.find("=") +1: function_args.find(',')].strip()
        elif "Uint256(" in function_args:
            self.offset = function_args[function_args.find("(") +1: function_args.find(',')].strip()
        else:
            self.offset: str = get_low_bits(function_args.split(",")[0].strip())
        super().__init__(
            module="evm.memory",
            function_name="mload_",
            function_args=function_args,
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"mload_({self.offset})"


class MSize(BuiltinHandler):
    def __init__(self, function_args, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.memory",
            function_name="get_msize",
            function_args=function_args,
            used_implicits=("msize"),
            cairo_functions=cairo_functions,
        )


# ============ Storage ============
class SStore(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        self.key: str = function_args.split(",")[0].strip()
        self.value: str = function_args.split(",")[1].strip()
        info = cairo_functions.sstore_function()
        super().__init__(
            module="",
            function_name=info.name,
            function_args=function_args,
            used_implicits=("storage_ptr", "range_check_ptr", "pedersen_ptr"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"{info.name}(key={self.key},value={self.value})"


class SLoad(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        info = cairo_functions.sload_function()
        super().__init__(
            module="",
            function_name=info.name,
            function_args=function_args,
            used_implicits=("storage_ptr", "range_check_ptr", "pedersen_ptr"),
            cairo_functions=cairo_functions,
        )


# ============ Keccak ============
class SHA3(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        self.offset = get_low_bits(function_args.split(",")[0].strip())
        self.length: str = get_low_bits(function_args.split(",")[1].strip())
        super().__init__(
            module="",
            function_name="sha",
            function_args=function_args,
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"sha({self.offset}, {self.length})"

    def required_imports(self):
        return {"evm.sha3": {"sha"}}


# ============ Call Data ============
class Caller(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.calls",
            function_name="get_caller_data_uint256",
            function_args=function_args,
            used_implicits=("syscall_ptr",),
            cairo_functions=cairo_functions,
        )


class CallDataLoad(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        self.offset: str = get_low_bits(function_args.split(",")[0].strip())
        super().__init__(
            module="evm.calls",
            function_name="calldata_load",
            function_args=function_args,
            used_implicits=("range_check_ptr", "exec_env"),
            cairo_functions=cairo_functions,
        )
        self.function_call = f"calldata_load({self.offset})"


class CallDataSize(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        info = cairo_functions.constant_function(0)
        super().__init__(
            module="",
            function_name=info.name,
            function_args=function_args,
            used_implicits=tuple(info.implicits),
            cairo_functions=cairo_functions,
        )
        self.function_call = "__warp__id(Uint256(exec_env.calldata_size, 0))"


class CallDataCopy(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.calls",
            function_name="calldatacopy_",
            function_args=function_args,
            used_implicits=("range_check_ptr", "exec_env", "memory_dict", "msize"),
            cairo_functions=cairo_functions,
        )


# ============ Return Data ============


class ReturnDataCopy(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.calls",
            function_name="returndata_copy",
            function_args=function_args,
            used_implicits=("range_check_ptr", "exec_env", "memory_dict"),
        )


class ReturnDataSize(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="",
            function_name="",
            function_args="",
            used_implicits=("exec_env",),
            cairo_functions=cairo_functions,
        )
        self.function_call = "__warp__id(Uint256(low=exec_env.returndata_size, high=0))"


class Return(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="evm.array",
            function_name="array_create_from_memory",
            function_args=function_args,
            cairo_functions=cairo_functions
        )
        [pointer, length] = [arg.strip() for arg in self.function_args.split(",")]
        self.function_call = (
            f"let (local return_: felt*) = array_create_from_memory({pointer}.low, {length}.low)\n"
            # f"default_dict_finalize(memory_dict_start, memory_dict, 0)\n"
            # f"return (1, {length}.low, return_)\n"
        )


class Call(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="",
            function_name="warp_call",
            function_args=function_args,
            used_implicits=(
                "syscall_ptr",
                "storage_ptr",
                "exec_env",
                "memory_dict",
                "range_check_ptr",
            ),
            cairo_functions=cairo_functions
        )


class StaticCall(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="",
            function_name="warp_static_call",
            function_args=function_args,
            used_implicits=(
                "syscall_ptr",
                "storage_ptr",
                "exec_env",
                "memory_dict",
                "range_check_ptr",
            ),
            cairo_functions=cairo_functions,
        )


class ExtCodeSize(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="",
            function_name="",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )
        self.function_call = "__warp__id(Uint256(1, 1))"


class Gas(BuiltinHandler):
    def __init__(self, function_args: str, cairo_functions: CairoFunctions):
        super().__init__(
            module="",
            function_name="",
            function_args=function_args,
            cairo_functions=cairo_functions,
        )
        self.function_call = "__warp__id(Uint256(1, 1))"


YUL_BUILTINS_MAP = {
    "add": Add,
    "addmod": AddMod,
    # "address": Address,
    "and": And,
    "byte": Byte,
    "calldatacopy": CallDataCopy,
    "calldataload": CallDataLoad,
    "calldatasize": CallDataSize,
    "caller": Caller,
    # "delegatecall": Delegatecall,
    "div": Div,
    "eq": Eq,
    "exp": Exp,
    "gas": Gas,
    "gt": Gt,
    "iszero": IsZero,
    "keccak256": SHA3,
    "lt": Lt,
    "mload": MLoad,
    "mod": Mod,
    "msize": MSize,
    "mstore": MStore,
    "mstore8": MStore8,
    "mul": Mul,
    "mulmod": MulMod,
    "not": Not,
    "or": Sub,
    "return": Return,
    "returndatacopy": ReturnDataCopy,
    "returndatasize": ReturnDataSize,
    "sar": Sar,
    "sdiv": Sdiv,
    "sgt": Sgt,
    "shl": Shl,
    "shr": Shr,
    "signextend": SignExtend,
    "sload": SLoad,
    "slt": Slt,
    "smod": SMod,
    "sstore": SStore,
    "extcodesize": ExtCodeSize,
    "gas": Gas,
    "call": Call,
    "staticcall": StaticCall,
    "sub": Sub,
    "xor": Xor,
}
