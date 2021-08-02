import operator

from transpiler.Imports import UINT256_MODULE
from transpiler.Operations.Binary import Binary, SimpleBinary
from transpiler.Operations.Ternary import Ternary
from transpiler.utils import uint256_to_int256, int256_to_uint256, UINT256_HALF_BOUND


class Add(SimpleBinary):
    def __init__(self):
        super().__init__(operator.add, UINT256_MODULE, "uint256_add")

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = {self.function_name}({op1}, {op2})"]


class Mul(SimpleBinary):
    def __init__(self):
        super().__init__(operator.mul, UINT256_MODULE, "uint256_mul")

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = {self.function_name}({op1}, {op2})"]


class Sub(SimpleBinary):
    def __init__(self):
        super().__init__(operator.sub, UINT256_MODULE, "uint256_sub")


class Div(Binary):
    def evaluate_eagerly(self, a, b):
        return a // b if b != 0 else 0

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256, _) = uint256_unsigned_div_rem({op1}, {op2})"]

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
            f"let (local {res} : Uint256, _) = uint256_signed_div_rem({op1}, {op2})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signed_div_rem"}}


class Exp(SimpleBinary):
    def __init__(self):
        # FIXME we should probably use a fast modular exponentiation algorithm instead
        super().__init__(operator.pow, UINT256_MODULE, "uint256_exp")


def mod(a, b):
    return a % b if b != 0 else 0


class Mod(SimpleBinary):
    def __init__(self):
        super().__init__(mod, UINT256_MODULE, "uint256_mod")


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
        return [
            f"let (local {res} : Uint256) = uint256_addmod({op1}, {op2}, {op3})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_addmod"}}


class MulMod(Ternary):
    def evaluate_eagerly(self, a, b, c):
        return a * b % c

    def generate_cairo_code(self, op1, op2, op3, res):
        return [
            f"let (local {res} : Uint256) = uint256_mulmod({op1}, {op2}, {op3})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mulmod"}}


class SignExtend(Binary):
    def evaluate_eagerly(self, b, x):
        bit_place = b * 8 + 7
        mask = 1 << bit_place
        if x & mask:  # the bit is set: negative signed number
            return x | ~(mask - 1)  # mod 2^256, it's correct
        else:
            return x & (mask - 1)

    def generate_cairo_code(self, op1, op2, res):
        # notice, that op1 is the byte position, so it should be the
        # second arg to uint256_signextend
        return [
            f"let (local {res} : Uint256) = uint256_signextend({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signextend"}}
