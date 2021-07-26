from Operations.Binary import Binary
from Operations.Unary import Unary
from Operations.Arithmetics import Sdiv
from Imports import UINT256_MODULE
from utils import bit_not, is_bit_set


class And(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if evaluatable:
            evaluated = op1 & op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_and({op1}, {op2})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_and"}}


class Or(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if evaluatable:
            evaluated = op1 | op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_or({op1}, {op2})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_or"}}


class Not(Unary):
    def bind_to_res(self, op1, res, evaluatable):
        if evaluatable:
            evaluated = bit_not(op1)
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_not({op})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_not"}}


class Xor(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if evaluatable:
            evaluated = op1 ^ op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_xor({op1}, {op2})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_xor"}}


class Shl(Binary):
    def bind_to_res(self, op1, op2, res, can_eval):
        if can_eval:
            evaluated = (op1 << op2) % 2 ** 256
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_shl({op1}, {op2})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shl"}}


class Shr(Binary):
    def bind_to_res(self, op1, op2, res, can_eval):
        if can_eval:
            evaluated = op1 >> op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        else:
            return (
                f"let (local {res} : Uint256) = uint256_shr({op1}, {op2})",
                False,
                0,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_shr"}}


class Sar(Binary):
    def bind_to_res(self, op1, op2, res, can_eval):
        if can_eval:
            evaluated = op1 >> op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )
        return f"let (local {res} : Uint256) = uint256_sar({op1}, {op2})", False, 0

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_sar"}}


class Byte(Binary):
    def bind_to_res(self, th, value, res, can_eval):
        if can_eval:
            evaluated = self.eval_byte(th, value)
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

        return f"let (local {res} : Uint256) = uint256_byte({op1}, {op2})", False, 0

    def eval_byte(self, th, value):
        bin_str = bin(value)[2:]
        bin_str = "0" * (256 - len(bin_str)) + bin_str
        bit = th * 8
        return int(bin_str[bit : bit + 8], 2)

    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_byte"}}
