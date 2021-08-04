from transpiler.Operation import NoParse, Operation 
from transpiler.utils import is_valid_uintN

class NoOp(Operation):
    def __init__(self, bytes_in_value: int, value: int):
        if not (1 <= bytes_in_value <= 32):
            raise ValueError(
                f"NOOP can push values from 1 to 32 bytes, not {bytes_in_value}"
            )
        bits = 8 * bytes_in_value
        if not is_valid_uintN(bits, value):
            raise ValueError(f"{value} is not a valid uint{bits}")
        self.bytes_in_value = bytes_in_value
        self.value = value

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("NOOP"):
            raise NoParse(pos)
        value = int(words[pos + 1], 16)
        bytes_in_value = int(words[pos][4:])
        return (cls(bytes_in_value, value), pos + 2)

    @classmethod
    def associated_words(cls):
        return [f"NOOP{i}" for i in range(1, 33)]

    def size_in_bytes(self):
        return 1 + self.bytes_in_value

    def proceed(self, state):
        return []

class Pass(Operation):
    def proceed(self, state):
        return []
    