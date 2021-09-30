from transpiler.Operation import Operation


class PC(Operation):
    def proceed(self, state):
        state.stack.push_uint256(state.cur_evm_pc - 1)
        return []
