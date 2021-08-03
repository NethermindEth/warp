from __future__ import annotations
from transpiler.StackValue import Uint256, Str


def is_valid_uintN(n: int, x: int):
    return 0 <= x < 2 ** n


UINT256_BOUND = 2 ** 256
UINT256_HALF_BOUND = 2 ** 255
UINT128_BOUND = 2 ** 128


def get_low_high(x):
    if isinstance(x, str):
        return f"{x}.low", f"{x}.high"
    elif isinstance(x, Str):
        return f"{x}.low", f"{x}.high"
    elif isinstance(x, Uint256):
        return x.get_low_high()


def int256_to_uint256(x: int) -> int:
    assert -UINT256_HALF_BOUND <= x < UINT256_HALF_BOUND
    return UINT256_BOUND + x if x < 0 else x


def uint256_to_int256(x: int) -> int:
    assert 0 <= x < UINT256_BOUND
    return x - UINT256_BOUND if x >= UINT256_HALF_BOUND else x


def cairoize_bytes(bs: bytes) -> tuple(list[int], int):
    """Represent bytes as an array of 128-bit big-endian integers and
    return a number of unused bytes in the last array cell.
    """
    unused_bytes = -len(bs) % 16
    bs = bs.ljust(len(bs) + unused_bytes, b"\x00")
    arr = [int.from_bytes(bs[i : i + 16], "big") for i in range(0, len(bs), 16)]
    return (arr, unused_bytes)


# is_bit_set returns true if bit n-th is set, where n = 0 is LSB.
# The n must be <= 255.
def is_bit_set(x, n):
    x_bin_str = bin(x)[2:]
    x_bin_str = "0b" + "0" * (256 - len(x_bin_str)) + x_bin_str
    return int(x_bin_str[-n]) != 0


def bit_not(n, numbits=256):
    return (1 << numbits) - 1 - n