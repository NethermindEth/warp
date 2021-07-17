from Imports import UINT256_MODULE
from Operation import Operation


class Jumpdest(Operation):
    def proceed(self, state):
        build_instructions, stack_ref = state.stack.build_stack_instructions()
        return [
            *build_instructions,
            f"return (stack={stack_ref}, evm_pc={state.cur_evm_pc})",
        ]

    def process_structural_changes(self, evmToCairo):
        evmToCairo.finish_segment()
        evmToCairo.start_new_segment()


class Jump(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        build_instructions, stack_ref = state.stack.build_stack_instructions()
        state.unreachable = True
        return [
            *build_instructions,
            f"return (stack={stack_ref}, evm_pc={a})",
        ]


class JumpI(Operation):
    def proceed(self, state):
        a = state.stack.pop()
        b = state.stack.pop()
        build_instructions, stack_ref = state.stack.build_stack_instructions()
        return [
            f"let (immediate) = uint256_eq({b}, Uint256(0, 0))",
            f"if immediate == 0:",
            *build_instructions,
            f"return (stack={stack_ref}, evm_pc={a})",
            "end",
        ]

    def required_imports(self):
        return {UINT256_MODULE: {"uint256_eq"}}
