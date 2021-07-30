from __future__ import annotations
import sys
from dataclasses import dataclass
from collections import defaultdict

from starkware.cairo.lang.compiler.parser import parse_file

from transpiler.Operation import Operation
from transpiler.Imports import UINT256_MODULE, format_imports, merge_imports
from transpiler.EvmStack import EvmStack
import transpiler.StackValue as StackValue
from transpiler.Operations.Storage import STORAGE_DECLS

LANGUAGE = "%lang starknet"
BUILTINS = ["pedersen", "range_check"]

COMMON_IMPORTS = {
    "starkware.cairo.common.registers": {"get_fp_and_pc"},
    "starkware.cairo.common.dict_access": {"DictAccess"},
    "starkware.cairo.common.default_dict": {
        "default_dict_new",
    },
    UINT256_MODULE: {"Uint256", "uint256_eq"},
    "starkware.cairo.common.cairo_builtins": {"HashBuiltin"},
    "starkware.starknet.common.storage": {"Storage"},
    "evm.stack": {"StackItem"},
    "evm.output": {"Output"},
    "evm.exec_env": {"ExecutionEnvironment"},
}

MAIN = """
@external
func main{storage_ptr: Storage*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
   unused_bits, payload_len, payload: felt*,
   ):
   alloc_locals
   let (local __fp__, _) = get_fp_and_pc()

   local exec_env: ExecutionEnvironment = ExecutionEnvironment(
      payload_len = payload_len,
      payload = payload,
   )

   let (local memory_dict : DictAccess*) = default_dict_new(0)
   local memory_start : DictAccess* = memory_dict

   tempvar msize = 0

   local stack0 : StackItem
   assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

   let (local stack, local output) = run_from{
      storage_ptr=storage_ptr,
      pedersen_ptr=pedersen_ptr,
      range_check_ptr=range_check_ptr,
      msize=msize, memory_dict=memory_dict
      }(&exec_env, Uint256(0, 0), &stack0)

   return ()
end
"""

NO_OUTPUT = "Output(0, cast(0, felt*), 0)"
EMPTY_OUTPUT = "Output(1, cast(0, felt*), 0)"


@dataclass
class SegmentState:
    stack: EvmStack
    n_locals: int
    unreachable: bool
    msize: int
    cur_evm_pc: StackValue.Uint256

    def __init__(self, cur_evm_pc: StackValue.Uint256):
        self.stack = EvmStack()
        self.n_locals = 0
        self.unreachable = False
        self.msize = 0
        self.cur_evm_pc = cur_evm_pc

    def make_return_instructions(
        self, pc: StackValue, output: str = NO_OUTPUT
    ) -> list[str]:
        build_instructions, stack_ref = self.stack.build_stack_instructions()
        return [
            *build_instructions,
            f"return (stack={stack_ref}, evm_pc={pc}, output={output})",
        ]

    def request_fresh_name(self) -> str:
        var_name = f"tmp{self.n_locals}"
        self.n_locals += 1
        return var_name


class EvmToCairo:
    def __init__(self, cur_evm_pc: int):
        self.code_segments: list[StackValue.Uint256] = []
        self.text_segments = []
        self.state = SegmentState(StackValue.Uint256(cur_evm_pc))
        self.imports = defaultdict(set)
        merge_imports(self.imports, COMMON_IMPORTS)
        self.requires_storage = False

        self.start_new_segment()

    def finish_segment(self):
        segment_pc_txt = self.segment_pc.get_int_repr()
        self.text_segments.append(
            "\n".join(
                [
                    f"func segment{segment_pc_txt}{self.__make_implicit_args()}"
                    "(exec_env: ExecutionEnvironment*, stack : StackItem*) -> "
                    "(stack : StackItem*, evm_pc : Uint256, output: Output):",
                    "alloc_locals",
                    "let stack0 = stack",
                    "let (local __fp__, _) = get_fp_and_pc()",
                ]
                + self.state.stack.prepare()
                + self.instructions
                + ["end"]
            )
        )

    def start_new_segment(self):
        self.instructions = []
        self.state = SegmentState(self.state.cur_evm_pc)
        self.segment_pc = self.state.cur_evm_pc
        self.code_segments.append(self.segment_pc)

    def process_operation(self, operation: Operation):
        self.state.cur_evm_pc += operation.size_in_bytes()
        if not self.state.unreachable:
            more_instructions = operation.proceed(self.state)
            self.instructions.extend(more_instructions)
            merge_imports(self.imports, operation.required_imports())
        operation.process_structural_changes(self)

    def __make_implicit_args(self):
        return "{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize, memory_dict: DictAccess*}"

    def construct_run_from_function(self):
        run_from = [
            f"func run_from{self.__make_implicit_args()}"
            "(exec_env: ExecutionEnvironment*, evm_pc: Uint256, stack: StackItem*) "
            "-> (stack: StackItem*, output: Output):"
        ]

        for segment_pc in self.code_segments:
            segment_pc_txt = segment_pc.get_int_repr()
            run_from.extend(
                [
                    f"let (immediate) = uint256_eq(evm_pc, {segment_pc})",
                    f"if immediate == 1:",
                    f"let (stack, evm_pc, output) = segment{segment_pc_txt}(exec_env, stack)",
                    "if output.active == 1:",
                    "return (stack, output)",
                    "end",
                    f"return run_from(exec_env, evm_pc, stack)",
                    "end",
                ]
            )

        run_from.extend(
            [
                f"let (immediate) = uint256_eq(evm_pc, Uint256(-1, 0))",
                f"if immediate == 1:",
                f"return (stack, {EMPTY_OUTPUT})",
                "end",
            ]
        )

        run_from.append("# Fail.")
        run_from.append("assert 0 = 1")
        run_from.append("jmp rel 0")
        run_from.append("end")
        return "\n".join(run_from)

    def finish(self, dump_all):
        if dump_all and not self.state.unreachable:
            insts, new_stack = self.state.stack.build_stack_instructions()
            self.instructions.extend(insts)
            self.instructions.append(
                f"return (stack={new_stack}, "
                f"evm_pc=Uint256(0, 0), output={EMPTY_OUTPUT})"
            )
        self.finish_segment()
        builtins_line = "%builtins " + " ".join(BUILTINS) if BUILTINS else ""
        return "\n\n".join(
            [
                LANGUAGE,
                builtins_line,
                format_imports(self.imports),
            ]
            + ([STORAGE_DECLS] if self.requires_storage else [])
            + [
                *self.text_segments,
                self.construct_run_from_function(),
                self.__make_main(),
            ]
        )

    def __make_main(self):
        return MAIN


def get_subclasses(cls):
    direct = cls.__subclasses__()
    indirect = [subsubcls for subcls in direct for subsubcls in get_subclasses(subcls)]
    return direct + indirect


def read_words(file):
    for line in file:
        yield from line.partition("#")[0].split()  # skip comments


def parse_operations(file):
    words = tuple(read_words(file))
    operation_classes = get_subclasses(Operation)

    word_to_cls = {}
    for cls in operation_classes:
        word_to_cls.update({word: cls for word in cls.associated_words()})
    i = 0
    while i < len(words):
        correct_cls = word_to_cls[words[i]]
        (op, i) = correct_cls.parse_from_words(words, i)
        yield op

def parse_ops_direct(words):
    operation_classes = get_subclasses(Operation)

    word_to_cls = {}
    for cls in operation_classes:
        word_to_cls.update({word: cls for word in cls.associated_words()})

    i = 0
    while i < len(words):
        correct_cls = word_to_cls[words[i]]
        (op, i) = correct_cls.parse_from_words(words, i)
        yield op

USAGE = f"Usage: python {sys.argv[0]} EVM-OPCODES-FILE [--dump-all]"


def main():
    argc = len(sys.argv)
    if argc == 2:
        dump_all = False
    elif argc == 3:
        if sys.argv[2] != "--dump-all":
            sys.exit(USAGE)
        dump_all = True
    else:
        sys.exit(USAGE)

    evm_to_cairo = EvmToCairo(cur_evm_pc=0)

    with open(sys.argv[1], "r") as opcodes_file:
        operations = list(parse_operations(opcodes_file))
        for op in operations:
            op.inspect_program(operations)

        for op in operations:
            evm_to_cairo.process_operation(op)

    print(parse_file(evm_to_cairo.finish(dump_all)).format())


if __name__ == "__main__":
    main()
