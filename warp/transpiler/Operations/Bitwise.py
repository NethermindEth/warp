import operator
from transpiler.Operations.Binary import Binary, SimpleBinary
from transpiler.Operations.Unary import Unary
from transpiler.Imports import UINT256_MODULE
from transpiler.utils import uint256_to_int256, int256_to_uint256


class And(SimpleBinary):
    def __init__(self):
        super().__init__(operator.and_, UINT256_MODULE, "uint256_and")


class Or(SimpleBinary):
    def __init__(self):
        super().__init__(operator.or_, UINT256_MODULE, "uint256_or")


class Not(Unary):
    def evaluate_eagerly(self, a):
        return ~a

    def generate_cairo_code(self, op1, res):
        return [f"let (local {res} : Uint256) = uint256_not({op1})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_not"}}


class Xor(SimpleBinary):
    def __init__(self):
        super().__init__(operator.xor, UINT256_MODULE, "uint256_xor")


class Shl(Binary):  # ARG ORDER NOT CONVENTIONAL
    def evaluate_eagerly(self, shift, value):
        return value << shift

    def generate_cairo_code(self, op1, op2, res):
        return [f"let (local {res} : Uint256) = uint256_shl({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shl"}}


class Shr(Binary):  # ARG ORDER NOT CONVENTIONAL
    def evaluate_eagerly(self, shift, value):
        return value >> shift

    def generate_cairo_code(self, op1, op2, res):
        return [f"let (local {res} : Uint256) = uint256_shr({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shr"}}


def sar(value, shift):
    shift = uint256_to_int256(shift)  # per yellow paper, only b is treated as signed
    return int256_to_uint256(value >> shift)


class Sar(Binary):  # ARG ORDER NOT CONVENTIONAL
    def evaluate_eagerly(self, shift, value):
        return sar(value=value, shift=shift)

    def generate_cairo_code(self, op1, op2, res):
        return [f"let (local {res} : Uint256) = uint256_sar({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"uint256_sar"}}


class Byte(Binary):
    def evaluate_eagerly(self, b, x):
        return (x >> (248 - b * 8)) & 0xFF

    def generate_cairo_code(self, op1, op2, res):
        # the reverse order in `uint256_byte` call is intentional
        return [f"let (local {res} : Uint256) = uint256_byte({op2}, {op1})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"uint256_byte"}}
