from transpiler.Imports import UINT256_MODULE
from transpiler.Operations.Binary import Binary
from transpiler.Operations.Unary import Unary


class IsZero(Unary):
    def bind_to_res(self, operand, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = is_zero({operand})", False, 0
        else:
            evaluated = 1 if operand == 0 else 0
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_zero"}}


class Eq(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = is_eq({op1}, {op2})", False, 0
        else:
            evaluated = 1 if op1 == op2 else 0
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_eq"}}


class Lt(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = is_lt({op1}, {op2})", False, 0
        else:
            evaluated = 1 if op1 < op2 else 0
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_lt"}}


class Gt(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = is_gt({op1}, {op2})", False, 0
        else:
            evaluated = 1 if op1 > op2 else 0
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"is_gt"}}


class Slt(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = slt({op1}, {op2})", False, 0
        else:
            evaluated = self.slt_eval(op1, op2)
            return (
                "",
                True,
                evaluated,
            )

    def slt_eval(self, op1, op2):
        op1 = -op1 if op1 > (2 ** 255 - 1) else op1
        op2 = -op2 if op1 > (2 ** 255 - 1) else op2
        return 1 if op1 < op2 else 0

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"slt"}}


class Sgt(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        print("HELLo")
        if not evaluatable:
            return f"let (local {res} : Uint256) = sgt({op1}, {op2})", False, 0
        else:
            evaluated = self.sgt_eval(op1, op2)
            return (
                "",
                True,
                evaluated,
            )

    def sgt_eval(self, op1, op2):
        op1 = -op1 if op1 > (2 ** 255 - 1) else op1
        op2 = -op2 if op1 > (2 ** 255 - 1) else op2
        return 1 if op1 > op2 else 0

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"sgt"}}
