from transpiler.Operations.Binary import Binary
from transpiler.Operations.Unary import Unary
from transpiler.utils import uint256_to_int256


class IsZero(Unary):
    def evaluate_eagerly(self, x):
        return x == 0

    def generate_cairo_code(self, op, res):
        return [
            f"let (local {res} : Uint256) = is_zero{{range_check_ptr=range_check_ptr}}({op})"
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_zero"}}


class Eq(Binary):
    @classmethod
    def evaluate_eagerly(self, x, y):
        return x == y

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256) = is_eq{{range_check_ptr=range_check_ptr}}({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_eq"}}


class Lt(Binary):
    def evaluate_eagerly(self, x, y):
        return x < y

    def generate_cairo_code(self, op1, op2, res):
        return [
            "local memory_dict : DictAccess* = memory_dict",
            f"let (local {res} : Uint256) = is_lt{{range_check_ptr=range_check_ptr}}({op1}, {op2})",
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_lt"}}


class Gt(Binary):
    def evaluate_eagerly(self, x, y):
        return x > y

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256) = is_gt{{range_check_ptr=range_check_ptr}}({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_gt"}}


def slt(a, b):
    return uint256_to_int256(a) < uint256_to_int256(b)


class Slt(Binary):
    def evaluate_eagerly(self, x, y):
        return slt(x, y)

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256) = slt{{range_check_ptr=range_check_ptr}}({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"slt"}}


def sgt(a, b):
    return uint256_to_int256(a) > uint256_to_int256(b)


class Sgt(Binary):
    def evaluate_eagerly(self, x, y):
        return sgt(x, y)

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256) = sgt{{range_check_ptr=range_check_ptr}}({op1}, {op2})"
        ]

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"sgt"}}
