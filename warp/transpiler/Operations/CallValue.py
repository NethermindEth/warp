from transpiler.Operation import Operation


class CallValue(Operation):
    def proceed(self, state):
        res_ref_name = state.request_fresh_name()
        instruction = self.bind_to_res(res_ref_name)
        state.stack.push_ref(res_ref_name)
        return [instruction]

    def bind_to_res(self, res):
        return f"local {res} : Uint256 = Uint256(1000,1000)"
