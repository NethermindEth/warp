from Operation import Operation, NoParse
from utils import is_valid_uintN


class Push(Operation):
    def __init__(self, bytes_in_value: int, value: int):
        if not (1 <= bytes_in_value <= 32):
            raise ValueError(
                f"PUSH can push values from 1 to 32 bytes, not {bytes_in_value}"
            )
        bits = 8 * bytes_in_value
        if not is_valid_uintN(bits, value):
            raise ValueError(f"{value} is not a valid uint{bits}")
        self.bytes_in_value = bytes_in_value
        self.value = value

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("PUSH"):
            raise NoParse(pos)
        bytes_in_value = int(words[pos][4:])
        value = int(words[pos + 1], 16)
        return (cls(bytes_in_value, value), pos + 2)

    @classmethod
    def associated_words(cls):
        return [f"PUSH{i}" for i in range(1, 33)]

    def size_in_bytes(self):
        return 1 + self.bytes_in_value

    def proceed(self, state):
        state.stack.push_uint256(self.value)
        return []


class Dup(Operation):
    def __init__(self, depth: int):
        if not (1 <= depth <= 16):
            raise ValueError(f"DUP depth must be in between 1 and 16, not {depth}")
        self.depth = depth

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("DUP"):
            raise NoParse(pos)
        depth = int(words[pos][3:])
        return (cls(depth), pos + 1)

    @classmethod
    def associated_words(cls):
        return [f"DUP{i}" for i in range(1, 17)]

    def proceed(self, state):
        state.stack.dup(self.depth)
        return []


class Swap(Operation):
    def __init__(self, depth: int):
        if not (1 <= depth <= 16):
            raise ValueError(f"SWAP depth must be in between 1 and 16, not {depth}")
        self.depth = depth

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("SWAP"):
            raise NoParse(pos)
        depth = int(words[pos][4:])
        return (cls(depth), pos + 1)

    @classmethod
    def associated_words(cls):
        return [f"SWAP{i}" for i in range(1, 17)]

    def proceed(self, state):
        state.stack.swap(self.depth)
        return []


class Pop(Operation):
    def proceed(self, state):
        state.stack.pop()
        return []
