from transpiler.Operations.EnforcedStack import EnforcedStack

from transpiler.Operation import Operation
from transpiler.Operations.Binary import Binary
from transpiler.StackValue import Uint256

class Ternary(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=3, has_output=True)
