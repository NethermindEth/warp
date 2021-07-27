from __future__ import annotations
import abc
from dataclasses import dataclass

from Operation import Operation
from StackValue import Uint256
import Operations


class Binary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        res_ref_name = state.request_fresh_name()
        op1, op2, evaluatable = self.can_eval(a, b)
        instruction, evaluated, evaluation = self.bind_to_res(
            op1, op2, res_ref_name, evaluatable
        )
        if evaluated:
            state.stack.push_uint256(evaluation)
            state.n_locals -= 1
            return [instruction]
        else:
            state.stack.push_ref(res_ref_name)
            return [instruction]

    def can_eval(self, op1, op2) -> (str, str, bool):
        op1_imm = isinstance(op1, Uint256)
        op2_imm = isinstance(op2, Uint256)
        if op1_imm and op2_imm:
            op1 = op1.x
            op2 = op2.x
            return op1, op2, True
        else:
            return op1, op2, False

    @abc.abstractmethod
    def bind_to_res(self, operand1, operand2, res_ref_name) -> str:
        """The instruction that binds the binary operation result applied to
        `operand1` and `operand2` to a reference named `res_ref_name`

        """
