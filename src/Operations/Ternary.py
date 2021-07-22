import abc

from Operation import Operation


class Ternary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        c = state.stack.pop()
        res_ref_name = state.request_fresh_name()
        instruction = self.bind_to_res(a, b, c, res_ref_name)
        state.stack.push_ref(res_ref_name)
        return [instruction]

    @abc.abstractmethod
    def bind_to_res(self, operand1, operand2, res_ref_name) -> str:
        """The instruction that binds the ternary operation result applied to
        `operand1`, `operand2` and `operand3` to a reference named `res_ref_name`

        """
