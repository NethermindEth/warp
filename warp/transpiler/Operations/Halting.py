from transpiler.Operation import Operation
from transpiler.StackValue import Uint256

EMPTY_OUTPUT = "Output(1, cast(0, felt*), 0)"


class Stop(Operation):
    def proceed(self, state):
        state.unreachable = True
        return state.make_return_instructions(Uint256(0), EMPTY_OUTPUT)


EMPTY_OUTPUT = "Output(1, cast(0, felt*), 0)"

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
        return [
            "assert 0 = 1",
            "local item : StackItem =StackItem(value=Uint256(0, 0),next=stack0)",
            "return (stack=&item, evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))",
        ]


class Invalid(Operation):
    def proceed(self, state):
        state.unreachable = True
        return [
            "local item : StackItem =StackItem(value=Uint256(0, 0),next=stack0)",
            "assert 0 = 1",
            "return (stack=&item,evm_pc=Uint256(-1, 0), output=Output(0, cast(0, felt*), 0))",
        ]


class Return(Operation):
    def proceed(self, state):
        state.unreachable = True
        offset = state.stack.pop().get_low_bits()
        length = state.stack.pop().get_low_bits()
        return [
            f"let (local output : Output) = create_from_memory({offset}, {length})",
            *state.make_return_instructions(Uint256(0), "output"),
        ]

    def required_imports(self):
        return {"evm.output": {"create_from_memory"}}
