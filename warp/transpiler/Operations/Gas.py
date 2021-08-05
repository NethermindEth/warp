from transpiler.Operation import Operation

MAX_VAL = 2 ** 64 - 1

class Gas(Operation):
    def proceed(self, state):
        """
        The current approach is to set the gas cost to a big constant,
        instead of doing the gas book keeping in the cairo code.
        It is assumed that the gas cost will not be higher than 64 bits
        """
        state.stack.push_uint256(MAX_VAL)
        return []
