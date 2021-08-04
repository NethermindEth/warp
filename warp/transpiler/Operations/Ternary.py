from transpiler.Operations.EnforcedStack import EnforcedStack

class Ternary(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=3, has_output=True)
