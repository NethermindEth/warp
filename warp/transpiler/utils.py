from __future__ import annotations

def is_valid_uintN(n: int, x: int):
    return 0 <= x < 2 ** n


def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)  # compute negative value
    return val


# is_bit_set returns true if bit n-th is set, where n = 0 is LSB.
# The n must be <= 255.
def is_bit_set(x, n):
    x_bin_str = bin(x)[2:]
    x_bin_str = "0b" + "0" * (256 - len(x_bin_str)) + x_bin_str
    return int(x_bin_str[-n]) != 0

def bit_not(n, numbits=256):
    return (1 << numbits) - 1 - n