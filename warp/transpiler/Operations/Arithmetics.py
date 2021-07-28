from transpiler.Imports import UINT256_MODULE
from transpiler.Operations.Binary import Binary
from transpiler.Operations.Ternary import Ternary
import math
from transpiler.utils import is_bit_set, bit_not
from transpiler.Operations.Ternary import Ternary


class Add(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}, _) = uint256_add({op1}, {op2})", False, 0
        else:
            evaluated = (op1 + op2) % 2 ** 256
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_add"}}


class Mul(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}, _) = uint256_mul({op1}, {op2})", False, 0
        else:
            evaluated = (op1 * op2) % 2 ** 256
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mul"}}


class Sub(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}) = uint256_sub({op1}, {op2})", False, 0
        else:
            evaluated = (op1 - op2) % 2 ** 256
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_sub"}}


class Div(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return (
                f"let (local {res}, _) = uint256_unsigned_div_rem({op1}, {op2})",
                False,
                0,
            )
        else:
            evaluated = int(math.floor(op1 / op2))
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_unsigned_div_rem"}}


class Sdiv(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return (
                "",
                False,
                0,
            )
        else:
            evaluated = self.sdiv_eval(op1, op2)
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    def sdiv_eval(self, op1, op2):
        op1 = -op1 if op1 > (2 ** 255 - 1) else op1
        op2 = -op2 if op1 > (2 ** 255 - 1) else op2
        return int(math.floor(op1 / op2))

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signed_div_rem"}}


class Exp(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}, _) = uint256_exp({op1}, {op2})", False, 0
        else:
            evaluated = (op1 ** op2) % 2 ** 256
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_exp"}}


class Mod(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}) = uint256_mod({op1}, {op2})", False, 0
        else:
            evaluated = op1 % op2
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mod"}}


class SMod(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}) = smod({op1}, {op2})", False, 0
        else:
            evaluated = self.smod_eval(op1, op2)
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    def smod_eval(self, op1, op2):
        op1 = -op1 if op1 > ((2 ** 255) - 1) else op1
        op2 = -op2 if op2 > ((2 ** 255) - 1) else op2
        return op1 % op2

    @classmethod
    def required_imports(cls):
        return {"evm.uint256": {"smod"}}


class AddMod(Ternary):
    def bind_to_res(self, op1, op2, op3, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}) = uint256_addmod({op1}, {op2}, {op3})", False, 0
        else:
            evaluated = (op1 + op2) % op3
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_addmod"}}


class MulMod(Ternary):
    def bind_to_res(self, op1, op2, op3, res, evaluatable):
        if not evaluatable:
            return (
                "",
                False,
                0,
            )
        else:
            evaluated = (op1 * op2) % op3
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_mulmod"}}


class SignExtend(Binary):
    def bind_to_res(self, op1, op2, res, evaluatable):
        if not evaluatable:
            return f"let (local {res}) = uint256_signextend({op1}, {op2})", False, 0
        else:
            evaluated = self.sign_extend_eval(op1, op2)
            res_high, res_low = divmod(evaluated, 2 ** 128)
            return (
                "",
                True,
                evaluated,
            )

    def sign_extend_eval(self, x, byteNum):
        if byteNum > 31:
            return x
        bit = (byteNum * 8) + 7
        mask = (1 << bit) - 1
        if is_bit_set(x, bit):
            return x | bit_not(mask)
        else:
            return x & mask

    @classmethod
    def required_imports(cls):
        return {UINT256_MODULE: {"uint256_signextend"}}
