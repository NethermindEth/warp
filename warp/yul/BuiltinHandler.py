from __future__ import annotations

import abc
import sys
from abc import ABC
from typing import Callable, Mapping, Optional, Sequence

from yul.FunctionGenerator import CairoFunctions, FunctionInfo
from yul.Imports import Imports
from yul.utils import get_low_bits

UINT256_MODULE = "starkware.cairo.common.uint256"


class BuiltinHandler(ABC):
    """Describes how an operation built into Yul translates to Cairo.

    References:
    https://docs.soliditylang.org/en/latest/yul.html?highlight=optimization#evm-dialect

    """

    def get_function_call(self, function_args: Sequence[str]) -> str:
        """Given the builtin operation and arguments, returns cairo code for
        this operation.

        - 'function_args' — a sequence of arguments already translated to Cairo

        """
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

    def required_imports(self) -> Imports:
        """Specifies Cairo imports requried for this operation."""
        module = self.get_module()
        if module is None:
            return {}
        return {module: {self.get_function_name()}}

    @abc.abstractmethod
    def get_function_name(self) -> str:
        """Specifies a name for the Cairo function used for this builtin."""
        pass

    @abc.abstractmethod
    def get_module(self) -> Optional[str]:
        """Specifies a module which needs to be imported. 'None' if no module
        is needed.

        """
        pass

    @abc.abstractmethod
    def get_used_implicits(self) -> tuple[str, ...]:
        """Specifies implicits needed for the Cairo function"""
        pass

    @abc.abstractmethod
    def get_kwarg_names(self) -> Optional[tuple[str, ...]]:
        """Specifies names of arguments of the Cairo function.

        If not 'None', all passed arguments will be passed as keyword
        arguments, i.e. 'ARG_NAME=' will be prepended to them.

        Right now, it's either all arguments are keyword arguments or
        none are. In the future, we can allow passing some names as
        'None'. That would mean that this arguments don't need the
        argument name prepending.

        """
        pass


class StaticHandler(BuiltinHandler):
    """A 'BuiltinHandler' for which function parameters are known at the
    handler creation time.

    """

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
    """A 'BuiltinHandler' for functions that are generated at the call
    time.

    """

    def __init__(self, info_gen: Callable[[], FunctionInfo]):
        """'info_gen' is a function that generates the required cairo function
        and returns information about it. Amortized it should run
        fast. See 'yul.FunctionGenerator'.

        """
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

    def get_function_call(self, _args: Sequence[str]):
        print(
            f"WARNING: This contract referenced '{type(self)}' "
            f"which is not yet supported. Evaluating"
            f"this contract on starknet may result in unexpected"
            f"behavior.",
            file=sys.stderr,
        )
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
        super().__init__(function_name="u256_shl", module="evm.uint256")


class Shr(StaticHandler):
    def __init__(self):
        super().__init__(function_name="u256_shr", module="evm.uint256")


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


class CallDataSize(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="calldatasize_",
            module="evm.calls",
            used_implicits=("range_check_ptr", "exec_env"),
        )


class CallDataCopy(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="calldatacopy_",
            module="evm.calls",
            used_implicits=("range_check_ptr", "exec_env", "memory_dict", "msize"),
        )


# ============ Return Data ============


class ReturnDataCopy(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="returndata_copy",
            module="evm.calls",
            used_implicits=("range_check_ptr", "exec_env", "memory_dict"),
        )


class ReturnDataSize(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.returndata_size_function())


class Return(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="returndata_write",
            module="evm.calls",
            used_implicits=("exec_env",),
        )


class Address(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(cairo_functions.address_function)


class Gas(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(10 ** 40))


class Delegatecall(NotImplementedOp):
    pass


class Call(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="warp_call",
            module="evm.calls",
            used_implicits=(
                "syscall_ptr",
                "exec_env",
                "memory_dict",
                "range_check_ptr",
                "bitwise_ptr",
            ),
        )


class StaticCall(StaticHandler):
    def __init__(self):
        super().__init__(
            function_name="warp_static_call",
            module="evm.calls",
            used_implicits=(
                "syscall_ptr",
                "exec_env",
                "memory_dict",
                "range_check_ptr",
                "bitwise_ptr",
            ),
        )


class ExtCodeSize(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(1))


class CallValue(DynamicHandler):
    def __init__(self, cairo_functions: CairoFunctions):
        super().__init__(lambda: cairo_functions.constant_function(0))


def get_default_builtins(
    cairo_functions: CairoFunctions,
) -> Mapping[str, BuiltinHandler]:
    """Returns a mapping from default Yul builtins to their handlers."""
    return {
        "add": Add(),
        "addmod": AddMod(),
        "address": Address(cairo_functions),
        "and": And(),
        "byte": Byte(),
        "call": Call(),
        "calldatacopy": CallDataCopy(),
        "calldataload": CallDataLoad(),
        "calldatasize": CallDataSize(),
        "caller": Caller(),
        "callvalue": CallValue(cairo_functions),
        "delegatecall": Delegatecall(cairo_functions),
        "div": Div(),
        "eq": Eq(),
        "exp": Exp(),
        "extecodesize": ExtCodeSize(cairo_functions),
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
        "staticcall": StaticCall(),
        "sub": Sub(),
        "xor": Xor(),
    }
