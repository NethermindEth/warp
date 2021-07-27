import operator

from Operations.Binary import SimpleBinary
from Operations.Unary import Unary
from utils import uint256_to_int256


class IsZero(Unary):
    def evaluate_eagerly(self, x):
        return x == 0

    def generate_cairo_code(self, op, res):
        return [f"let ({res}) = is_zero({op})"]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_zero"}}


class Eq(SimpleBinary):
    def __init__(self):
        super().__init__(operator.eq, "evm.uint256", "is_eq")


class Lt(SimpleBinary):
    def __init__(self):
        super().__init__(operator.lt, "evm.uint256", "is_lt")


class Gt(SimpleBinary):
    def __init__(self):
        super().__init__(operator.gt, "evm.uint256", "is_gt")


def slt(a, b):
    return uint256_to_int256(a) < uint256_to_int256(b)


class Slt(SimpleBinary):
    def __init__(self):
        super().__init__(slt, "evm.uint256", "slt")


def sgt(a, b):
    return uint256_to_int256(a) > uint256_to_int256(b)


class Sgt(SimpleBinary):
    def __init__(self):
        super().__init__(sgt, "evm.uint256", "sgt")
