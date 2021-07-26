from EvmToCairo import EMPTY_OUTPUT
from Operation import Operation
from StackValue import Uint256


class Stop(Operation):
    def proceed(self, state):
        state.unreachable = True
        return state.make_return_instructions(Uint256(0), EMPTY_OUTPUT)


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
        return ["assert 0 = 1"]


class Invalid(Operation):
    def proceed(self, state):
        state.unreachable = True
        return ["assert 0 = 1"]


class Return(Operation):
    def proceed(self, state):
        state.unreachable = True
        offset = state.stack.pop().get_low_bits()
        length = state.stack.pop().get_low_bits()
        return [
            f"let (output) = create_from_memory({offset}, {length})",
            *state.make_return_instructions(Uint256(0), "output"),
        ]

    def required_imports(self):
        return {"evm.output": {"create_from_memory"}}
