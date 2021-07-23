import abc

from Operation import Operation


class Binary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        res_ref_name = state.request_fresh_name()
        instruction = self.bind_to_res(a, b, res_ref_name)
        state.stack.push_ref(res_ref_name)
        return [instruction]

    @abc.abstractmethod
    def bind_to_res(self, operand1, operand2, res_ref_name) -> str:
        """The instruction that binds the binary operation result applied to
        `operand1` and `operand2` to a reference named `res_ref_name`

        """
