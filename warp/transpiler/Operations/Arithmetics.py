import operator

from transpiler.Imports import UINT256_MODULE
from transpiler.Operations.Binary import Binary, SimpleBinary
from transpiler.Operations.Ternary import Ternary
from transpiler.StackValue import UINT256_BOUND
from transpiler.utils import (
    uint256_to_int256,
    int256_to_uint256,
    UINT256_HALF_BOUND,
    is_bit_set,
    bit_not,
)


class Add(SimpleBinary):
    def __init__(self):
        super().__init__(operator.add, UINT256_MODULE, "uint256_add")

    def generate_cairo_code(self, op1, op2, res):
        return [f"let (local {res} : Uint256, _) = {self.function_name}({op1}, {op2})"]


class Mul(SimpleBinary):
    def __init__(self):
        super().__init__(operator.mul, UINT256_MODULE, "uint256_mul")

    def generate_cairo_code(self, op1, op2, res):
        return [f"let (local {res} : Uint256, _) = {self.function_name}({op1}, {op2})"]


class Sub(SimpleBinary):
    def __init__(self):
        super().__init__(operator.sub, UINT256_MODULE, "uint256_sub")


class Div(Binary):
    def evaluate_eagerly(self, a, b):
        return a // b if b != 0 else 0

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = uint256_unsigned_div_rem({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_unsigned_div_rem"}}


class Sdiv(Binary):
    def evaluate_eagerly(self, a, b):
        a = uint256_to_int256(a)
        b = uint256_to_int256(b)
        if a == -UINT256_HALF_BOUND and b == -1:
            return a
        return int256_to_uint256(a // b) if b != 0 else 0

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = uint256_signed_div_rem({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signed_div_rem"}}


def bin_exp(a, b):
    ans = 1
    while b > 0:
        if b % 2 == 1:
            ans = (ans * a) % UINT256_BOUND
        a = (a * a) % UINT256_BOUND
        b = b >> 1
    return ans


class Exp(SimpleBinary):
    def __init__(self):
        super().__init__(bin_exp, "evm.uint256", "uint256_exp")


def mod(a, b):
    return a % b if b != 0 else 0


class Mod(SimpleBinary):
    def __init__(self):
        super().__init__(mod, "evm.uint256", "uint256_mod")


def smod(a, b):
    a = uint256_to_int256(a)
    b = uint256_to_int256(b)
    return int256_to_uint256(a % b) if b != 0 else 0


class SMod(SimpleBinary):
    def __init__(self):
        super().__init__(smod, "evm.uint256", "smod")


class AddMod(Ternary):
    def evaluate_eagerly(self, a, b, c):
        return (a + b) % c

    def generate_cairo_code(self, op1, op2, op3, res):
        return [f"let (local {res} : Uint256) = uint256_addmod({op1}, {op2}, {op3})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"uint256_addmod"}}


class MulMod(Ternary):
    def evaluate_eagerly(self, a, b, c):
        return a * b % c

    def generate_cairo_code(self, op1, op2, op3, res):
        return [f"let (local {res} : Uint256) = uint256_mulmod({op1}, {op2}, {op3})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"uint256_mulmod"}}


class SignExtend(Binary):
    def evaluate_eagerly(self, b, x):
        if b > 31:
            return x
        bit = (b * 8) + 7
        mask = (1 << bit) - 1
        if is_bit_set(x, bit):
            return x | bit_not(mask)
        else:
            return x & mask

    def generate_cairo_code(self, op1, op2, res):
        # notice, that op1 is the byte position, so it should be the
        # second arg to uint256_signextend
        return [f"let (local {res} : Uint256) = uint256_signextend({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"uint256_signextend"}}
