from __future__ import annotations
import abc

from Imports import Imports


class Operation(abc.ABC):
    @classmethod
    def parse_from_words(cls, words: list[str], pos: int) -> tuple(cls, int):
        """Given a list of words and a current position, try to parse the
        operation as a word.

        Return `(op, pos')`, where `op` is the parsed operation and
        `pos'` is a new position in the list after parsing.

        Throw NoParse if parsing is unsuccessful.

        """
        word = cls.__name__.upper()
        if words[pos] != word:
            raise NoParse(pos)
        return (cls(), pos + 1)

    def size_in_bytes(self):
        """Size of the operation in bytes. Might be different from 1 for PUSH
        operations, which take argument of variable size.
        """
        return 1

    @classmethod
    def associated_words(cls) -> list[str]:
        """E.g. [POP], [MLOAD], [PUSH1, .., PUSH32]"""
        return [cls.__name__.upper()]

    @classmethod
    def required_imports(cls) -> Imports:
        """Returns a dictionary of imports required to use this operation. A
        dictionary key is a module to import from and a dictionary
        value is a set of names from that module to import.

        """
        return {}

    @classmethod
    def inspect_program(self, code):
        pass

    @abc.abstractmethod
    def proceed(self, state: "EvmToCairo.SegmentState") -> list[str]:
        pass

    def process_structural_changes(self, evmToCairo: "EvmToCairo"):
        """Perform additional transformations on the transpilation process,
        after all state changes and cairo instructions have been
        processed.

        Primarily a hack to allow 'JUMPDEST' to create new segments.

        """


class NoParse(BaseException):
    def __init__(self, word_no: int):
        self.word_no = word_no


# The following piece of code serves for automatic discovery of
# operations.
import importlib
import os

with os.scandir("src/Operations") as it:
    for entry in it:
        if entry.is_file() and entry.name.endswith(".py"):
            importlib.import_module(f".{entry.name[:-3]}", package="Operations")
