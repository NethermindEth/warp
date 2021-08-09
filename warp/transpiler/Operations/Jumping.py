from transpiler.Imports import UINT256_MODULE
from transpiler.Operation import Operation
from transpiler.StackValue import Uint256


class Jumpdest(Operation):
    def proceed(self, state):
        # The EVM treats jumps as if they jump right before JUMPDEST
        # (JUMPDEST is the next operation), so PC needs to be
        # decremented by one.
        return state.make_jump_instructions(Uint256(state.cur_evm_pc - 1))

    def process_structural_changes(self, evmToCairo):
        evmToCairo.finish_segment()
        evmToCairo.start_new_segment()


class Jump(Operation):
    def proceed(self, state):
        state.unreachable = True
        a = state.stack.pop()
        return state.make_jump_instructions(a)


class JumpI(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        return_instructions = state.make_jump_instructions(a)
        if not isinstance(b, Uint256):
            return [
                f"let (immediate) = uint256_eq({b}, Uint256(0, 0))",
                "if immediate == 0:",
                *return_instructions,
                "end",
            ]
        elif b.get_int_repr() == 0:
            return []
        else:
            return return_instructions

    def required_imports(self):
        return {UINT256_MODULE: {"uint256_eq"}}
