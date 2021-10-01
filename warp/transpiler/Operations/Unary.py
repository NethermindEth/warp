from transpiler.Operations.EnforcedStack import EnforcedStack


class Unary(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=1, has_output=True)
