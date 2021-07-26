import abc

from Operation import Operation
from Operations.Binary import Binary
from StackValue import Uint256


class Ternary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        c = state.stack.pop()
        res_ref_name = state.request_fresh_name()
        op1, op2, op3, evaluatable = self.can_eval(a, b, c)
        instruction, evaluated, evaluation = self.bind_to_res(
            op1, op2, op3, res_ref_name, evaluatable
        )
        if evaluated:
            state.stack.push_uint256(evaluation)
            state.n_locals -= 1
            return [instruction]
        else:
            state.stack.push_ref(res_ref_name)
            return [instruction]

    def can_eval(self, op1, op2, op3) -> (str, str, str, bool):
        op3_imm = isinstance(op3, Uint256)

        op1_inter, op2_inter, evaluatable = Binary.can_eval(Binary, op1, op2)
        if not evaluatable:
            return op1, op2, op3, False
        elif op3_imm:
            op3 = op3.x
            return op1_inter, op2_inter, op3, True
        else:
            return op1, op2, op3, False

    @abc.abstractmethod
    def bind_to_res(self, operand1, operand2, res_ref_name) -> str:
        """The instruction that binds the ternary operation result applied to
        `operand1`, `operand2` and `operand3` to a reference named `res_ref_name`

        """
