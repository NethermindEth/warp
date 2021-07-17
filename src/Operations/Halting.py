from Operation import Operation


class Stop(Operation):
    def proceed(self, state):
        return ["if 1 == 1:", "return (memory_dict, stack, Uint256(-1,0))", "end"]


""" 
In the future, when StarkWare has implementent 
revert semantics in the StarkNet VM, this will change
to something like:

return [f"[ap -1] = get_memory({offset}, {offset+size})", "assert 0 = 1"]
"""
class Revert(Operation):
    def proceed(self, state):
        offset = state.stack.pop()
        size = state.stack.pop()
        return ["assert 0 = 1"]


class Invalid(Operation):
    def proceed(self, state):
        return ["assert 0 = 1"]
