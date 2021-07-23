from Operation import Operation, NoParse

class Log(Operation):
    def __init__(self, topics_amount: int):
        if not (0 <= topics_amount <= 4):
            raise ValueError(
                f"LOG can take from 0 to 4 topics, not {topics_amount}"
            )
        self.topics_amount = topics_amount

    @classmethod
    def parse_from_words(cls, words, pos):
        if not words[pos].startswith("LOG"):
            raise NoParse(pos)
        topics_amount = int(words[pos][3:])
        return (cls(topics_amount), pos + 1)

    @classmethod
    def associated_words(cls):
        return [f"LOG{i}" for i in range(5)]

    def proceed(self, state):
        """
        Log operation is currently implemented as no-op.
        It has the proper behavior in regards to popping things from stack 
        and updating the memory consumption counter
        """

        offset = state.stack.pop().get_low_bits()
        length = state.stack.pop().get_low_bits()
        instruction = f"let (local msize) = update_msize(msize, {offset}, {length})"
        topics = [state.stack.pop() for _ in range(self.topics_amount)]

        return [instruction]

    def required_imports(self):
        return {"evm.utils": {"update_msize"}}