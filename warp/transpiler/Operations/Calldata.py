from transpiler.Imports import UINT256_MODULE
from transpiler.Operations.Binary import Binary
from transpiler.Operation import Operation
from transpiler.Operations.Unary import Unary


class CalldataLoad(Operation):
    def proceed(self, state):
        offset = state.stack.pop()
        res_ref_name = f"tmp{state.n_locals}"
        state.stack.push_ref(res_ref_name)
        return [instruction]

    def bind_to_res(self, offset, res_ref_name):
        return f"let (local {res_ref_name} : Uint256) = calldata_load(offset, calldata)"

    @classmethod
    def required_imports(cls):
        return {"evm.calldata" : "calldata_load"}
        

class CalldataSize(Operation):
    def proceed(self, state):
        res_ref_name = state.request_fresh_name()
        instruction = self.bind_to_res(res_ref_name)
        state.stack.push_ref(res_ref_name)
        return [instruction]

    def bind_to_res(self, res_ref_name):
        return f"local {res_ref_name} = calldata_size"

    def required_imports(cls):
        return


class CalldataCopy(Operation):
    def proceed(self, state):
        raise NotImplementedError

    def bind_to_res(self, res_ref_name):
        raise NotImplementedError

    def required_imports(cls):
        raise NotImplementedError
