from Imports import UINT256_MODULE
from Operations.Binary import Binary
from Operation import Operation
from Operations.Unary import Unary


class CalldataLoad(Unary):
    def bind_to_res(self, operand1, res_ref_name):
        return

    @classmethod
    def required_imports(cls):
        return


class CalldataSize(Operation):
    def proceed(self, state):
        res_ref_name = f"tmp{state.n_locals}"
        instruction = self.bind_to_res(res_ref_name)
        state.stack.push_ref(res_ref_name)
        state.n_locals += 1
        return [instruction]

    def bind_to_res(self, res_ref_name):
        return

    def required_imports(cls):
        return


class CalldataCopy(Operation):
    def proceed(self, state):
        mem_offset = state.stack.pop()
        data_offset = state.stack.pop()
        length = state.stack.pop()
        res_ref_name = f"tmp{state.n_locals}"
        instruction = self.bind_to_res(res_ref_name)
        return [instruction]

    def bind_to_res(self, res_ref_name):
        return

    def required_imports(cls):
        return
