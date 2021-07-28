from __future__ import annotations
import os, sys

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../../.."))
sys.path.append(os.path.join(WARP_ROOT, "src"))
import os, sys
from cli.compilation.utils import is_entry_seq, get_jumpdest_offset
import json


class InstructionIterator:
    def __init__(self, bytecode):
        self.bytecode = [bytecode[x : x + 2] for x in range(0, len(bytecode), 2)]
        self.op_table = self.load_op_table()
        self.cur_op = self.bytecode[0]
        self.cur_op_str = self.op_str()
        self.arg = []
        self.pc = 0
        self.started = False
        self.error = None

    def load_op_table(
        self,
    ):
        path=os.path.abspath(os.path.join(__file__, "../../", "opcode_tables", "op_to_str.json"))
        with open(path) as f:
            table = json.load(f)
        return table

    def next(self) -> bool:
        if len(self.bytecode) <= self.pc or self.error != None:
            return False
        if self.started:
            if self.arg != None:
                self.pc += len(self.arg)
            self.pc += 1
        else:
            self.started = True

        if len(self.bytecode) <= self.pc:
            return False

        self.cur_op = self.bytecode[self.pc]
        self.cur_op_str = self.op_str()
        push_op, size = self.is_push(self.cur_op_str)
        if push_op:
            u = self.pc + size + 1
            if len(self.bytecode) <= self.pc or len(self.bytecode) < u:
                self.error = (
                    f"Incomplete push instruction at {self.pc}\n curr_op: {self.cur_op_str}"
                )
            self.arg = self.bytecode[self.pc + 1 : u]
            self.arg_padded = self.pad_arg(self.arg)
        else:
            self.arg = None
        return True

    def disassemble(self) -> Dict[str, str]:
        self.instructions = {}
        while self.next():
            if self.arg != None and len(self.arg) > 0:
                self.instructions[hex(self.pc)] = f"{self.op_str()} {self.arg_padded}"
            else:
                self.instructions[hex(self.pc)] = f"{self.op_str()}"
        return self.instructions

    def is_push(self, op_str) -> (bool, int):
        if "PUSH" in op_str:
            return True, self.push_arg_size(op_str)
        else:
            return False, 0

    def create_entrypoint(self, instructions: List[str], selectors, lang):
        selector = instructions[1]
        offset = get_jumpdest_offset(lang)
        jumpdest = instructions[offset]
        func_sig = selectors[instructions[1]]
        return {
            "signature": func_sig,
            "selector": selector,
            "jumpdest": jumpdest,
        }

    def push_arg_size(self, op_str) -> int:
        return int(op_str[op_str.find("H") + 1 :])

    def op_str(self):
        try:
            return self.op_table[self.cur_op]
        except KeyError:
            val = f"INVALID"
            return val

    def pad_arg(self, arg):
        len_push = self.push_arg_size(self.cur_op_str) * 2
        arg_hex = hex(int("".join(arg), 16))
        l_arg = len(arg_hex[2:])
        arg = "0x" + "0" * (len_push - l_arg) + arg_hex[2:]
        return arg



if __name__ == '__main__':
    with open("weth10.bin") as f:
        bytecode = f.read()
    it = InstructionIterator(bytecode) 
    dis = it.disassemble()
    with open("weth.json", 'w') as f:
        json.dump(dis, f, indent=4)
