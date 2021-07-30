from transpiler.Operation import Operation

class PC(Operation):
    @classmethod
    def required_imports(cls):
        return {}

    def proceed(self, state):
        state.stack.push_uint256(state.cur_evm_pc - 1)
        return []
