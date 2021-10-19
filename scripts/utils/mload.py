#!/usr/bin/env python

import argparse
from collections import defaultdict

from starkware.cairo.lang.cairo_constants import DEFAULT_PRIME
from starkware.cairo.lang.compiler.cairo_compile import compile_cairo_files

# A script to check values in EVM-like simulated memory. You just
# enter memory writes, an offset, and get a mload of uint256 split
# into two uint128.
#
# Memory writes have the following format: "m KEY1 BYTE2 KEY2 BYTE2 M
# KEY1 LOW1 HIGH1 LOW2 HIGH2 m KEY3 BYTE3...". You can do byte-level
# writes, prefixed by 'm' and uint256-level writex, prefixed by
# 'M'. Byte-level writes consist of a memory offset KEY and a byte to
# write BYTE. uint256-level writes consist of a memory offset KEY and
# two uint128's: LOW and HIGH. Writing and reading is performed
# according to the EVM specification.


def byte_to_hex(x: int) -> str:
    assert 0 <= x < 256
    return hex(x)[2:].zfill(2)


def uint128_to_hex(x: int) -> str:
    assert 0 <= x < 2 ** 128
    return hex(x)[2:].zfill(32)


def count_uint16(offset, memory):
    arr = [byte_to_hex(0) for _ in range(16)]
    for (k, v) in memory.items():
        if offset <= k < offset + 16:
            arr[k - offset] = v
    return int("".join(arr), 16)


def read_int(x: str) -> int:
    return int(x, 16) if x.startswith("0x") else int(x)


def parse_memory(mem: str) -> dict:
    words = mem.split()
    i = 0

    memory = {}
    mode = "m8"
    while i < len(words):
        if words[i] == "m":
            mode = "m8"
            i += 1
        elif words[i] == "M":
            mode = "m256"
            i += 1
        elif mode == "m8":
            k = int(words[i])
            v = read_int(words[i + 1])
            i += 2
            memory[k] = byte_to_hex(v)
        else:
            assert mode == "m256"
            k_start = int(words[i])
            low = read_int(words[i + 1])
            high = read_int(words[i + 2])
            byte_arr = uint128_to_hex(high) + uint128_to_hex(low)
            i += 3
            for j in range(0, 32):
                memory[k_start + j] = byte_arr[j * 2 : j * 2 + 2]

    return memory


def main():
    parser = argparse.ArgumentParser(
        description="Given memory writes, perform mload16 at the given offset."
    )

    parser.add_argument("--memory", "-m", required=True)
    parser.add_argument("--offset", "-o")
    parser.add_argument("--print-memory", "-p", action="store_true")

    args = parser.parse_args()

    memory = parse_memory(args.memory)
    print_memory = args.print_memory
    offset = args.offset
    if print_memory:
        for i in range(0, 200):
            v = memory.get(i, byte_to_hex(0))
            print(f"{i:>6}: {v}")

    if offset:
        offset = int(args.offset)
        print("low =", count_uint16(offset + 16, memory))
        print("high =", count_uint16(offset, memory))


if __name__ == "__main__":
    main()
