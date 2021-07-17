from Operations.Binary import Binary
from Operations.Unary import Unary
from Imports import UINT256_MODULE


class And(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_and({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_and"}}


class Or(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_or({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_or"}}


class Not(Unary):
    def bind_to_res(self, op, res):
        return f"let (local {res} : Uint256) = uint256_not({op})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_not"}}


class Xor(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_xor({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_xor"}}


class Shl(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_shl({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shl"}}


class Shr(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_shr({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shr"}}


class Sar(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_sar({op1}, {op2})"

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_sar"}}


class Byte(Binary):
    def bind_to_res(self, op1, op2, res):
        return f"let (local {res} : Uint256) = uint256_byte({op1}, {op2})"

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_byte"}}
