from __future__ import annotations
from typing import Union

import transpiler.StackValue as StackValue


class EvmStack:
    """
    Simulates the EVM stack.
    """

    def __init__(self):
        # The last value in self.values represents the value at the top of the stack.
        self.values: list[StackValue.StackValue] = []
        # If more values of the stack are required, those values will be dynamically added.
        # self.depth represents how many such values were added to self.values.
        self.depth = 0

    def pad_up_to(self, n):
        """
        Makes sure there are at least n elements in the stack. Adds variables to the bottom
        of the stack if needed.
        """
        padding = max(0, n - len(self.values))
        new_depth = self.depth + padding
        padding_values = [
            StackValue.Str(f"stack{d}.value") for d in range(self.depth, new_depth)
        ]
        padding_values.reverse()

        self.depth = new_depth
        self.values = padding_values + self.values

    def push_ref(self, x: str):
        self.values.append(StackValue.Str(x))

    def push_uint256(self, x: Union[int, StackValue.Uint256]):
        self.values.append(
            x if isinstance(x, StackValue.Uint256) else StackValue.Uint256(x)
        )

    def pop(self):
        self.pad_up_to(1)
        return self.values.pop(-1)

    def dup(self, i):
        v = self.get(i)
        self.values.append(v)

    def get(self, i):
        self.pad_up_to(i)
        return self.values[-i]

    def swap(self, i):
        self.pad_up_to(i + 1)
        self.values[-i - 1], self.values[-1] = self.values[-1], self.values[-i - 1]

    def __repr__(self):
        return repr(self.values)

    def prepare(self):
        """
        Creates local variables for the stack items that were read.
        """
        return [
            f"local stack{i + 1} : StackItem* = stack{i}.next"
            for i in range(self.depth)
        ]

    def build_stack_instructions(self):
        """
        Returns the Cairo instruction for constructing the stack.
        """
        for i, val in enumerate(self.values):
            if str(val) != f"stack{self.depth - i - 1}.value":
                break
        else:
            i = len(self.values)
        cur_stack = f"stack{self.depth - i}"

        res = []
        for i, val in enumerate(self.values[i:], start=i):
            res.append(
                f"local newitem{i} : StackItem = "
                f"StackItem(value={val}, next={cur_stack})"
            )
            cur_stack = f"&newitem{i}"
        return res, cur_stack
