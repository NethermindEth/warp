from __future__ import annotations
from yul.utils import get_low_bits

UINT256_MODULE = "starkware.cairo.common.uint256"


class BuiltinHandler:
    def __init__(
        self,
        module: str,
        function_name: str,
        function_args: str,
        call_implicits: list[str] = [],
        used_implicits: tuple[str] = ("range_check_ptr",),
    ):
        self.module = module
        self.function_name = function_name
        self.function_args = function_args
        self.call_implicits = ", ".join(f"{x}={x}" for x in call_implicits)
        self.used_implicits = used_implicits
        self.function_call = (
            f"{self.function_name}({self.function_args})"
            if self.call_implicits == ""
            else f"{self.function_name}{{{self.call_implicits}}}({self.function_args})"
        )

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
        )


class Gt(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.uint256",
            function_name="is_gt",
            function_args=function_args,
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
            call_implicits=["memory_dict", "range_check_ptr", "msize"],
            used_implicits=("memory_dict", "msize"),
        )
        self.call_implicits = ["memory_dict", "range_check_ptr", "msize"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = f"mstore_{{{self.call_implicits_decl}}}(offset={self.address}, value={self.value})"


class MStore8(BuiltinHandler):
    def __init__(self, function_args: str):
        self.address: str = get_low_bits(function_args.split(",")[0].strip())
        self.value: str = function_args.split(",")[1].strip()
        super().__init__(
            module="evm.memory",
            function_name="mstore8_",
            function_args=function_args,
            call_implicits=["memory_dict", "range_check_ptr", "msize"],
            used_implicits=("memory_dict", "msize"),
        )
        self.call_implicits = ["memory_dict", "range_check_ptr", "msize"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = f"mstore8_{{{self.call_implicits_decl}}}(offset={self.address}, value={self.value})"


class MLoad(BuiltinHandler):
    def __init__(self, function_args: str):
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
            call_implicits=["memory_dict", "range_check_ptr", "msize"],
            used_implicits=("memory_dict", "msize"),
        )
        self.call_implicits = ["memory_dict", "range_check_ptr", "msize"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = f"mload_{{{self.call_implicits_decl}}}({self.offset})"


class MSize(BuiltinHandler):
    def __init__(self, function_args):
        super().__init__(
            module="evm.memory",
            function_name="get_msize",
            function_args=function_args,
            call_implicits=["msize"],
            used_implicits=("msize"),
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
            call_implicits=["storage_ptr", "range_check_ptr", "pedersen_ptr"],
            used_implicits=("storage_ptr", "pedersen_ptr"),
        )
        self.call_implicits = ["storage_ptr", "range_check_ptr", "pedersen_ptr"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = (
            f"s_store{{{self.call_implicits_decl}}}(key={self.key},value={self.value})"
        )


class SLoad(BuiltinHandler):
    def __init__(self, function_args: str):
        self.key: str = function_args.split(",")[0].strip()
        super().__init__(
            module="",
            function_name="s_store",
            function_args=function_args,
            call_implicits=["storage_ptr", "range_check_ptr", "pedersen_ptr"],
            used_implicits=("storage_ptr", "pedersen_ptr"),
        )
        self.call_implicits = ["storage_ptr", "range_check_ptr", "pedersen_ptr"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = f"s_load{{{self.call_implicits_decl}}}({self.key})"


# ============ Keccak ============
class SHA3(BuiltinHandler):
    def __init__(self, function_args: str):
        self.offset = get_low_bits(function_args.split(",")[0].strip())
        self.length: str = get_low_bits(function_args.split(",")[1].strip())
        super().__init__(
            module="",
            function_name="sha",
            function_args=function_args,
            call_implicits=["range_check_ptr", "memory_dict", "msize"],
            used_implicits=("memory_dict", "msize"),
        )
        self.call_implicits = ["range_check_ptr", "memory_dict", "msize"]
        self.call_implicits_decl = ", ".join(f"{x}={x}" for x in self.call_implicits)
        self.function_call = (
            f"sha{{{self.call_implicits_decl}}}({self.offset},{self.length})"
        )

    def required_imports(self):
        return {"evm.sha3": {"sha"}}


# ============ Call Data ============
class Caller(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.calls",
            function_name="get_caller_data_uint256",
            function_args=function_args,
            call_implicits=["syscall_ptr"],
            used_implicits=("syscall_ptr",),
        )


class CallDataLoad(BuiltinHandler):
    def __init__(self, function_args: str):
        self.offset: str = get_low_bits(function_args.split(",")[0].strip())
        super().__init__(
            module="evm.calls",
            function_name="calldata_load",
            function_args=function_args,
            call_implicits=["range_check_ptr", "exec_env"],
        )
        self.function_call = (
            f"calldata_load{{range_check_ptr=range_check_ptr, exec_env=exec_env}}("
            f"{self.offset})\n"
            f"local exec_env : ExecutionEnvironment = exec_env"
        )


class CallDataSize(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="",
            function_name="",
            function_args=function_args,
            call_implicits=[],
        )
        self.function_call = "Uint256(exec_env.calldata_size, 0)"


class CallDataCopy(BuiltinHandler):
    def __init__(self, function_args: str):
        super().__init__(
            module="evm.calls",
            function_name="calldatacopy_",
            function_args=function_args,
            call_implicits=["range_check_ptr", "exec_env"],
            used_implicits=("range_check_ptr", "exec_env", "memory_dict", "msize"),
        )


# ============ Return Data ============


# class ReturnDataCopy(BuiltinHandler):
#     touched = False

#     def __init__(self, function_args: str):
#         super().__init__(
#             module="", function_name="", function_args="", call_implicits=[]
#         )
#         if not ReturnDataCopy.touched:
#             print(
#                 "WARNING: This contract referenced 'return data' (returndatacopy) which is not yet supported. Evaluating this contract on starknet may result in unexpected behavior."
#             )
#             ReturnDataCopy.touched = True
#         self.function_call = ""


# class ReturnDataSize(BuiltinHandler):
#     touched = False

#     def __init__(self, function_args: str):
#         super().__init__(
#             module="", function_name="", function_args="", call_implicits=[]
#         )
#         if not ReturnDataCopy.touched:
#             print(
#                 "WARNING: This contract referenced 'return data' (returndatacopy) which is not yet supported. Evaluating this contract on starknet may result in unexpected behavior."
#             )
#             ReturnDataCopy.touched = True
#         self.function_call = "Uint256(low=0, high=0)"


class Return(BuiltinHandler):
    def __init__(self, function_arg: str):
        super().__init__(
            module="", function_name="", function_args="", call_implicits=[]
        )
        self.function_call = ""


YUL_BUILTINS_MAP = {
    "add": Add,
    "addmod": AddMod,
    "and": And,
    "byte": Byte,
    "calldatacopy": CallDataCopy,
    "calldataload": CallDataLoad,
    "calldatasize": CallDataSize,
    "caller": Caller,
    "div": Div,
    "eq": Eq,
    "exp": Exp,
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
    # "returndatacopy": ReturnDataCopy,
    # "returndatasize": ReturnDataSize,
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
    "sub": Sub,
    "xor": Xor,
}
