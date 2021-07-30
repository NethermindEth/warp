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
        return [f"let (local {res} : Uint256) = uint256_not({op})"]

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_not"}}


class Xor(SimpleBinary):
    def __init__(self):
        super().__init__(operator.xor, UINT256_MODULE, "uint256_xor")


class Shl(SimpleBinary):
    def __init__(self):
        super().__init__(operator.lshift, UINT256_MODULE, "uint256_shl")


class Shr(SimpleBinary):
    def __init__(self):
        super().__init__(operator.rshift, UINT256_MODULE, "uint256_shr")


def sar(a, b):
    b = uint256_to_int256(b)  # per yellow paper, only b is treated as signed
    return int256_to_uint256(a >> b)


class Sar(SimpleBinary):
    def __init__(self):
        super().__init__(sar, UINT256_MODULE, "uint256_sar")


class Byte(Binary):
    def evaluate_eagerly(self, b, x):
        return (x >> (248 - b * 8)) & 0xFF

    def generate_cairo_code(self, op1, op2, res):
        # the reverse order in `uint256_byte` call is intentional
        return [f"let (local {res} : Uint256) = uint256_byte({op2}, {op1})"]

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_byte"}}
