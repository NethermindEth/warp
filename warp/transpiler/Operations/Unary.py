from transpiler.Operations.EnforcedStack import EnforcedStack

from transpiler.Operation import Operation
from transpiler.StackValue import Uint256

class Unary(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=1, has_output=True)
