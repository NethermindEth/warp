from __future__ import annotations
from typing import Optional
import abc

from StackValue import Uint256, UINT256_BOUND
from Operation import Operation


class EnforcedStack(Operation):
    def __init__(self, n_args: int, has_output: bool):
        self.n_args = n_args
        self.has_output = has_output

    def __try_eager_evaluation(self, state, args: list[Uint256]):
        try:
            output = self.evaluate_eagerly(*(arg.x for arg in args))
        except NotImplementedError:
            return False
        assert self.has_output == (output is not None)
        if output is not None:
            state.stack.push_uint256(output % UINT256_BOUND)
        return True

    def proceed(self, state: "EvmToCairo.SegmentState") -> list[str]:
        args = [state.stack.pop() for _ in range(self.n_args)]
        if all(isinstance(arg, Uint256) for arg in args):
            if self.__try_eager_evaluation(state, args):
                return []
        if self.has_output:
            output_name = state.request_fresh_name()
            state.stack.push_ref(output_name)
            return self.generate_cairo_code(*args, output_name)
        else:
            return self.generate_cairo_code(*args)

    def evaluate_eagerly(self, *args: tuple[int]) -> Optional[int]:
        """Eagerly evaluates the operation, given 'self.n_args' uint256
        arguments starting from the top of the stack.

        If there is only one output, you can return it without
        wrapping into a tuple. If eager evaluation is not possible (or
        feasible), return 'None'.

        Note: all outputs are used modulo 2^256.

        """
        raise NotImplementedError

    @abc.abstractmethod
    def generate_cairo_code(self, *args: tuple) -> list[str]:
        """Generate cairo code that performs this operation.

        Parameters:
          - 'self.n_args' stack values starting with the top ones;
          - 'self.n_outputs' output variable names starting with the bottom ones;

        Operation results should be bound to the output variable
        names.

        """
