from transpiler.Operation import Operation
from transpiler.utils import EMPTY_OUTPUT


class Stop(Operation):
    def proceed(self, state):
        state.unreachable = True
        return state.make_return_instructions(EMPTY_OUTPUT)


"""
In the future, when StarkWare implements
revert semantics in the StarkNet VM, this will change
to something like:
return [f"[ap -1] = get_memory({offset}, {offset+size})", "assert 0 = 1"]
"""


class Revert(Operation):
    def proceed(self, state):
        offset = state.stack.pop()
        size = state.stack.pop()
        state.unreachable = True
        return ["assert 0 = 1", "jmp rel 0"]


class Invalid(Operation):
    def proceed(self, state):
        state.unreachable = True
        return ["assert 0 = 1", "jmp rel 0"]


class Return(Operation):
    def proceed(self, state):
        state.unreachable = True
        offset = state.stack.pop().get_low_bits()
        length = state.stack.pop().get_low_bits()
        return [
            f"let (local output : Output) = create_from_memory({offset}, {length})",
            *state.make_return_instructions("output"),
        ]

    def required_imports(self):
        return {"evm.output": {"create_from_memory"}}
