from __future__ import annotations

import abc
from abc import ABC
from typing import Callable, Mapping, Optional, Sequence

from yul.FunctionGenerator import CairoFunctions, FunctionInfo
from yul.utils import get_low_bits

UINT256_MODULE = "starkware.cairo.common.uint256"


class BuiltinHandler(ABC):
    def get_function_call(self, function_args: Sequence[str]) -> str:
        kwarg_names = self.get_kwarg_names()
        function_name = self.get_function_name()
        if kwarg_names:
            assert len(kwarg_names) == len(function_args)
            args_repr = ", ".join(
                f"{kw}={v}" for kw, v in zip(kwarg_names, function_args)
            )
        else:
            args_repr = ", ".join(function_args)
        return f"{function_name}({args_repr})"

    def required_imports(self) -> Mapping[str, set[str]]:
        module = self.get_module()
        if module is None:
            return {}
        return {module: {self.get_function_name()}}

    @abc.abstractmethod
    def get_function_name(self) -> str:
        pass

    @abc.abstractmethod
    def get_module(self) -> Optional[str]:
        pass

    @abc.abstractmethod
    def get_used_implicits(self) -> tuple[str, ...]:
        pass

    @abc.abstractmethod
    def get_kwarg_names(self) -> Optional[tuple[str, ...]]:
        pass


class StaticHandler(BuiltinHandler):
    def __init__(
        self,
        function_name: str,
        module: Optional[str] = None,
        used_implicits: tuple[str, ...] = ("range_check_ptr",),
        kwarg_names: Optional[tuple[str, ...]] = None,
    ):
        self.function_name = function_name
        self.module = module
        self.used_implicits = used_implicits
        self.kwarg_names = kwarg_names

    def get_function_name(self):
        return self.function_name

    def get_module(self):
        return self.module

    def get_used_implicits(self):
        return self.used_implicits

    def get_kwarg_names(self):
        return self.kwarg_names


class DynamicHandler(BuiltinHandler):
    def __init__(self, info_gen: Callable[[], FunctionInfo]):
        self.info_gen = info_gen

    def get_function_name(self):
        return self.info_gen().name

    def get_module(self):
        return None

    def get_used_implicits(self):
        return self.info_gen().implicits

    def get_kwarg_names(self):
        return self.info_gen().kwarg_names


class NotImplementedOp(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(cairo_functions.stubbing_function)
        print(
            f"WARNING: This contract referenced '{type(self)}' "
            f"which is not yet supported. Evaluating"
            f"this contract on starknet may result in unexpected"
            f"behavior."
        )

    def get_function_call(self, _args: Sequence[str]):
        return super().get_function_call([])


# ============ Comparisons ============
class IsZero(StaticHandler):
    def __init__(self):
        super().__init__(function_name="is_zero", module="evm.uint256")


class Eq(StaticHandler):
    def __init__(self):
        super().__init__(function_name="is_eq", module="evm.uint256")


class Lt(StaticHandler):
    def __init__(self):
        super().__init__(function_name="is_lt", module="evm.uint256")


class Gt(StaticHandler):
    def __init__(self):
        super().__init__(function_name="is_gt", module="evm.uint256")


class Slt(StaticHandler):
    def __init__(self):
        super().__init__(function_name="slt", module="evm.uint256")


class Sgt(StaticHandler):
    def __init__(self):
        super().__init__(function_name="sgt", module="evm.uint256")


# ============ Bitwise ============
class And(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_and", module=UINT256_MODULE)


class Or(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_or", module=UINT256_MODULE)


class Not(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_not", module=UINT256_MODULE)


class Xor(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_xor", module=UINT256_MODULE)


class Shl(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_shl", module=UINT256_MODULE)


class Shr(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_shr", module=UINT256_MODULE)


class Sar(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_sar", module="evm.uint256")


class Byte(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_byte", module="evm.uint256")


# ============ Arithmetic ============
class Add(StaticHandler):
    def __init__(self):
        super().__init__(function_name="u256_add", module="evm.uint256")


class Mul(StaticHandler):
    def __init__(self):
        super().__init__(function_name="u256_mul", module="evm.uint256")


class Sub(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_sub", module=UINT256_MODULE)


class Div(StaticHandler):
    def __init__(self):
        super().__init__(function_name="u256_div", module="evm.uint256")


class Sdiv(StaticHandler):
    def __init__(self):
        super().__init__(function_name="u256_sdiv", module="evm.uint256")


class Exp(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uin256_exp", module=UINT256_MODULE)


class Mod(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uint256_mod", module="evm.uint256")


class SMod(StaticHandler):
    def __init__(self):
        super().__init__(function_name="smod", module="evm.uint256")


class AddMod(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uin256_addmod", module="evm.uint256")


class MulMod(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uin256_mulmod", module="evm.uint256")


class SignExtend(StaticHandler):
    def __init__(self):
        super().__init__(function_name="uin256_signextend", module="evm.uint256")


# ============ Memory ============
class MStore(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="mstore_",
            module="evm.memory",
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
            kwarg_names=("offset", "value"),
        )

    def get_function_call(self, args: Sequence[str]):
        (address, value) = args
        return super().get_function_call([get_low_bits(address), value])


class MStore8(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="mstore8_",
            module="evm.memory",
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
        )

    def get_function_call(self, args: Sequence[str]):
        (address, value) = args
        return super().get_function_call([get_low_bits(address), value])


class MLoad(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="mload_",
            module="evm.memory",
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
        )

    def get_function_call(self, args: Sequence[str]):
        (address,) = args
        return super().get_function_call([get_low_bits(address)])


class MSize(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="get_msize", module="evm.memory", used_implicits=("msize",)
        )


# ============ Storage ============
class SStore(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(cairo_functions.sstore_function)


class SLoad(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(cairo_functions.sload_function)

    def get_kwarg_names(self):
        return None


# ============ Keccak ============
class SHA3(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="sha",
            module="evm.sha3",
            used_implicits=("memory_dict", "msize", "range_check_ptr"),
        )

    def get_function_call(self, args: Sequence[str]):
        (offset, length) = map(get_low_bits, args)
        return super().get_function_call([offset, length])


# ============ Call Data ============
class Caller(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="get_caller_data_uint256",
            module="evm.calls",
            used_implicits=("syscall_ptr",),
        )


class CallDataLoad(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="calldata_load",
            module="evm.calls",
            used_implicits=("range_check_ptr", "exec_env"),
        )

    def get_function_call(self, args: Sequence[str]):
        (offset,) = args
        return super().get_function_call([get_low_bits(offset)])


class CallDataSize(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(0))


class CallDataCopy(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="calldatacopy_",
            module="evm.calls",
            used_implicits=("range_check_ptr", "exec_env", "memory_dict", "msize"),
        )


class CallValue(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(0))


# ============ Return Data ============


class ReturnDataCopy(StaticHandler):
    def __init__(self):
        super().__init__(function_name="", used_implicits=())

    def get_function_call(self, _args):
        return ""


class ReturnDataSize(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(0))


class Return(StaticHandler):
    def __init__(self):
        super().__init__(function_name="", used_implicits=())

    def get_function_call(self, _args):
        return ""


# ============ Other ============


class Address(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(cairo_functions.address_function)


class Gas(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(10 ** 40))


class Delegatecall(NotImplementedOp):
    pass


def get_default_builtins(
    cairo_functions: CairoFunctions,
) -> Mapping[str, BuiltinHandler]:
    return {
        "add": Add(),
        "addmod": AddMod(),
        "address": Address(cairo_functions),
        "and": And(),
        "byte": Byte(),
        "calldatacopy": CallDataCopy(),
        "calldataload": CallDataLoad(),
        "calldatasize": CallDataSize(cairo_functions),
        "caller": Caller(),
        "callvalue": CallValue(cairo_functions),
        "delegatecall": Delegatecall(cairo_functions),
        "div": Div(),
        "eq": Eq(),
        "exp": Exp(),
        "gas": Gas(cairo_functions),
        "gt": Gt(),
        "iszero": IsZero(),
        "keccak256": SHA3(),
        "lt": Lt(),
        "mload": MLoad(),
        "mod": Mod(),
        "msize": MSize(),
        "mstore": MStore(),
        "mstore8": MStore8(),
        "mul": Mul(),
        "mulmod": MulMod(),
        "not": Not(),
        "or": Sub(),
        "return": Return(),
        "returndatacopy": ReturnDataCopy(),
        "returndatasize": ReturnDataSize(cairo_functions),
        "sar": Sar(),
        "sdiv": Sdiv(),
        "sgt": Sgt(),
        "shl": Shl(),
        "shr": Shr(),
        "signextend": SignExtend(),
        "sload": SLoad(cairo_functions),
        "slt": Slt(),
        "smod": SMod(),
        "sstore": SStore(cairo_functions),
        "sub": Sub(),
        "xor": Xor(),
    }
