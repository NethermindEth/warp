from Imports import UINT256_MODULE
from Operations.Binary import Binary
from Operations.Unary import Unary


class IsZero(Unary):
    def bind_to_res(self, operand, res):
        return f"let (local {res} : Uint256) = is_zero({operand})"

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_zero"}}


class Eq(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256)  = is_eq({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_eq"}}


class Lt(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = is_lt({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_lt"}}


class Gt(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = is_gt({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_gt"}}


class Slt(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = slt({op1}, {op2})"

    def required_imports(cls):
        return {"evm.uint256": {"slt"}}


class Sgt(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = sgt({op1}, {op2})"

    def required_imports(cls):
        return {"evm.uint256": {"sgt"}}
