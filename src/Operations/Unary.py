import abc

from Operation import Operation
from StackValue import Uint256

class Unary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        res_ref_name = state.request_fresh_name()
        op1, evaluatable = self.can_eval(a)
        instruction, evaluated, evaluation = self.bind_to_res(op1, res_ref_name, evaluatable)
        if evaluated:
            state.stack.push_uint256(evaluation)
            return [instruction]
        else:
            state.stack.push_ref(res_ref_name)
            return [instruction]

    def can_eval(self, op1) -> (str, bool):
        op1_imm = isinstance(op1, Uint256)
        if op1_imm:
            op1 = op1.x
            return op1, True
        else:
            return op1, False

    @abc.abstractmethod
    def bind_to_res(self, operand1, res_ref_name) -> str:
        """The instruction that binds the unary operation result applied to
        `operand1` to a reference named `res_ref_name`

        """
