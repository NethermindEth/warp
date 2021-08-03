from transpiler.Operation import Operation, NoParse
from transpiler.Operations.EnforcedStack import EnforcedStack


class Log(EnforcedStack):
    def __init__(self, topics_amount: int):
        if not (0 <= topics_amount <= 4):
            raise ValueError(f"LOG can take from 0 to 4 topics, not {topics_amount}")
        super().__init__(args_spec="ll" + "w" * topics_amount, has_output=False)

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("LOG"):
            raise NoParse(pos)
        topics_amount = int(words[pos][3:])
        return (cls(topics_amount), pos + 1)

    @classmethod
    def associated_words(cls):
        return [f"LOG{i}" for i in range(5)]

    def generate_cairo_code(self, offset, length, *topics):
        """
        Log operation is currently implemented as no-op.
        It has the proper behavior in regards to popping things from stack
        and updating the memory consumption counter
        """
        return [
            f"let (local msize) = update_msize(msize, {offset}, {length})",
            "local memory_dict : DictAccess* = memory_dict",
        ]

    def required_imports(self):
        return {"evm.utils": {"update_msize"}}
