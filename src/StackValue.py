import abc

from utils import is_valid_uintN

UINT256_BOUND = 2 ** 256
UINT128_BOUND = 2 ** 128


class StackValue:
    @abc.abstractmethod
    def __str__(self):
        pass


# SHOULD BE IMMUTABLE
class Uint256(StackValue):
    def __init__(self, x: int):
        if not is_valid_uintN(256, x):
            raise ValueError(f"{x} is not a valid uint256")
        self.x = x

    def __str__(self):
        high, low = divmod(self.x, UINT128_BOUND)
        return f"Uint256({low}, {high})"

    def __add__(self, y: int):
        return Uint256((self.x + y) % UINT256_BOUND)

    def __sub__(self, y: int):
        return Uint256((self.x - y) % UINT256_BOUND)

    def get_int_repr(self) -> str:
        return repr(self.x)

    def get_low_bits(self):
        high, low = divmod(self.x, UINT128_BOUND)
        return f"{low}"

    def get_low_high(self):
        high, low = divmod(self.x, UINT128_BOUND)
        return low, high


class Str(StackValue):
    def __init__(self, x: str):
        self.x = x

    def __str__(self):
        return self.x

    def get_low_bits(self):
        return f"{self.x}.low"
