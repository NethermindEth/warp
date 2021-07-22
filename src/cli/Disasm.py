data2 = [data[x:x+2] for x in range(0, len(data),2)]

class InstructionIterator:
    def __init__(self, file_path):
