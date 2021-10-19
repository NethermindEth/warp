from __future__ import annotations

from collections.abc import Callable

from transpiler.Operations.EnforcedStack import EnforcedStack


class Binary(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=2, has_output=True)


class SimpleBinary(Binary):
    def __init__(
        self,
        eager_eval: Callable[[int, int], int],
        module: str,
        function_name: str,
    ):
        super().__init__()
        self.eager_eval = eager_eval
        self.module = module
        self.function_name = function_name

    def evaluate_eagerly(self, a, b):
        return self.eager_eval(a, b)

    def generate_cairo_code(self, op1, op2, res):
        return [
            f"let (local {res} : Uint256) = {self.function_name}({op1}, {op2})",
        ]

    def required_imports(self):
        return {self.module: {self.function_name}}
