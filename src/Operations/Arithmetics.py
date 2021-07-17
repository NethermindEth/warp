from Imports import UINT256_MODULE
from Operations.Binary import Binary
from Operations.Ternary import Ternary


class Add(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}, _) = uint256_add({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_add"}}


class Mul(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}, _) = uint256_mul({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mul"}}


class Sub(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}) = uint256_sub({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_sub"}}


class Div(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}, _) = uint256_unsigned_div_rem({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_unsigned_div_rem"}}


class Sdiv(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}, _) = uint256_signed_div_rem({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signed_div_rem"}}


class Exp(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}) = uint256_exp({op1}, {op2})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_exp"}}


class Mod(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}) = uint256_mod({op1}, {op2})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mod"}}


class SMod(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}) = smod({op1}, {op2})"

    def required_imports(cls):
        return {"evm.uint256": {"smod"}}


class AddMod(Ternary):
    def bind_to_res(self, op1, op2, op3, res):
        return f"let (local {res}) = uint256_addmod({op1}, {op2}, {op3})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_addmod"}}


class MulMod(Ternary):
    def bind_to_res(self, op1, op2, op3, res):
        return f"let (local {res}) = uint256_mulmod({op1}, {op2}, {op3})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mulmod"}}


class SignExtend(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res}) = uint256_signextend({op1}, {op2})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signextend"}}
