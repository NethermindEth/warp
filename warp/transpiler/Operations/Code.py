from __future__ import annotations
from transpiler.Operation import Operation

class CodeSize(Operation):
    code_size: int

    def proceed(self, state):
        state.stack.push_uint256(self.code_size)
        return []

    @classmethod
    def inspect_program(self, code: list[Operation]):
        code_size = 0
        for op in code:
            code_size += op.size_in_bytes()
        self.code_size = code_size
