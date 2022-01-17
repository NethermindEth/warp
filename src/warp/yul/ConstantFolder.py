from __future__ import annotations

from typing import Union

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper
from warp.yul.WarpException import WarpException

REDUCERS = {
    "add": lambda x, y: x + y,
    "sub": lambda x, y: x - y,
    "mul": lambda x, y: x * y,
    "div": lambda x, y: x / y if y != 0 else 0,
    "mod": lambda x, y: x % y if y != 0 else 0,
    "exp": lambda x, y: x ** y,
    "not": lambda x: ~x % uint256,
    "eq": lambda x, y: int(x == y),
    "and": lambda x, y: x & y,
    "or": lambda x, y: x | y,
    "xor": lambda x, y: x ^ y,
    "shl": lambda x, y: y << x,
    "shr": lambda x, y: y >> x,
    "addmod": lambda x, y, m: (x + y) % m if m != 0 else 0,
    "mulmod": lambda x, y, m: (x * y) % m if m != 0 else 0,
}


uint256 = 2 ** 256


def overflow_check(res):
    if res > uint256:
        raise WarpException("ConstantFolder detected an overflow")
    return res


class ConstantFolder(AstMapper):
    """This class optimises arithmetic and logical on literals.

    Run VariableInliner before this pass, to maximise the chances of
    optimisation.
    """

    def visit_function_call(
        self, node: ast.FunctionCall
    ) -> Union[ast.Literal, ast.FunctionCall]:
        reduced_args = self.visit_list(node.arguments)
        reducer = REDUCERS.get(node.function_name.name)
        if reducer and all(
            isinstance(arg, ast.Literal) and isinstance(arg.value, int)
            for arg in reduced_args
        ):
            return ast.Literal(
                overflow_check(reducer(*[arg.value for arg in reduced_args]))
            )

        return ast.FunctionCall(
            function_name=self.visit(node.function_name),
            arguments=reduced_args,
        )
