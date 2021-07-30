from __future__ import annotations
from typing import Optional
import abc

from transpiler.StackValue import Uint256, UINT256_BOUND
from transpiler.Operation import Operation


def get_arg(state, arg_spec):
    assert arg_spec == "l" or arg_spec == "w"
    arg = state.stack.pop()
    return arg.get_low_bits() if arg_spec == "l" else arg


class EnforcedStack(Operation):
    def __init__(
        self, args_spec: str = None, n_args: int = None, has_output: bool = False
    ):
        """Parameters:

        'args_spec' — specifies arguments number and type. It is a
          string of argument types. Each type is either "w" — *w*hole
          Uint256, or "l" — just *l*ower 128-bits. It is useful since
          many EVM values are expected to be less than 2^64 and
          working with simple felts is more efficient in cairo. By
          default, if 'n_args' is specified, it is assumed to be a
          string of "w"s, i.e. all arguments are whole Uin256's.

        'n_args' — a number of arguments. By default, can be inferred
          from 'args_spec' if it is specified.

        'has_output' — whether the operation has output to put on top
          of the EVM stack.

        """
        if args_spec is None:
            assert (
                n_args is not None
            ), "Either supply a number of arguments, or their spec"
            self.args_spec = "w" * n_args
        else:
            assert (n_args is None) or n_args == len(
                args_spec
            ), "Arguments number must conform to their spec"
            self.args_spec = args_spec
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
        args = [get_arg(state, arg_spec) for arg_spec in self.args_spec]
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
          - 'n_args' stack values starting with the top ones;
          - an output variable name if 'has_output' is True;

        Operation results should be bound to the output variable
        names.

        """
