import abc

from Operation import Operation


class Unary(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        res_ref_name = f"tmp{state.n_locals}"
        instruction = self.bind_to_res(a, res_ref_name)
        state.stack.push_ref(res_ref_name)
        state.n_locals += 1
        return [instruction]

    @abc.abstractmethod
    def bind_to_res(self, operand1, res_ref_name) -> str:
        """The instruction that binds the unary operation result applied to
        `operand1` to a reference named `res_ref_name`

        """
