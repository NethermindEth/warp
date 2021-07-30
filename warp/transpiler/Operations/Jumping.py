from transpiler.Imports import UINT256_MODULE
from transpiler.Operation import Operation


class Jumpdest(Operation):
    def proceed(self, state):
        return state.make_return_instructions(state.cur_evm_pc)

    def process_structural_changes(self, evmToCairo):
        evmToCairo.finish_segment()
        evmToCairo.start_new_segment()


class Jump(Operation):
    def proceed(self, state):
        state.unreachable = True
        a = state.stack.pop()
        return state.make_return_instructions(a)


class JumpI(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        return_instructions = state.make_return_instructions(a)
        return [
            f"let (immediate) = uint256_eq({b}, Uint256(0, 0))",
            "if immediate == 0:",
            *return_instructions,
            "end",
        ]

    def required_imports(self):
        return {UINT256_MODULE: {"uint256_eq"}}
