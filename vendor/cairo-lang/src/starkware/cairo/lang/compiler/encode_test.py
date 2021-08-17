import dataclasses

from starkware.cairo.lang.compiler.encode import (
    decode_instruction, encode_instruction, is_call_instruction)
from starkware.cairo.lang.compiler.instruction import Instruction, Register
from starkware.cairo.lang.compiler.instruction_builder import build_instruction
from starkware.cairo.lang.compiler.parser import parse_instruction

PRIME = 2**64 + 13


def test_assert_eq():
    encoded = [0x480680017fff8000, 1]
    instruction = Instruction(
        off0=0,
        off1=-1,
        off2=1,
        imm=1,
        dst_register=Register.AP,
        op0_register=Register.FP,
        op1_addr=Instruction.Op1Addr.IMM,
        res=Instruction.Res.OP1,
        pc_update=Instruction.PcUpdate.REGULAR,
        ap_update=Instruction.ApUpdate.ADD1,
        fp_update=Instruction.FpUpdate.REGULAR,
        opcode=Instruction.Opcode.ASSERT_EQ,
    )
    assert build_instruction(parse_instruction('[ap] = 1; ap++')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction

    # Remove "ap++".
    instruction = dataclasses.replace(instruction, ap_update=Instruction.ApUpdate.REGULAR)
    encoded = [0x400680017fff8000, 1]
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(*encoded) is False


def test_jmp():
    encoded = [0x0129800080027fff]
    instruction = Instruction(
        off0=-1,
        off1=2,
        off2=0,
        imm=None,
        dst_register=Register.FP,
        op0_register=Register.AP,
        op1_addr=Instruction.Op1Addr.FP,
        res=Instruction.Res.ADD,
        pc_update=Instruction.PcUpdate.JUMP_REL,
        ap_update=Instruction.ApUpdate.REGULAR,
        fp_update=Instruction.FpUpdate.REGULAR,
        opcode=Instruction.Opcode.NOP,
    )
    assert build_instruction(parse_instruction('jmp rel [ap + 2] + [fp]')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction

    # Change to jmp abs.
    instruction = dataclasses.replace(instruction, pc_update=Instruction.PcUpdate.JUMP)
    encoded = [0x00a9800080027fff]
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(encoded[0], None) is False


def test_jnz():
    encoded = [0x020a7ff07fff8003]
    instruction = Instruction(
        off0=3,
        off1=-1,
        off2=-16,
        imm=None,
        dst_register=Register.AP,
        op0_register=Register.FP,
        op1_addr=Instruction.Op1Addr.FP,
        res=Instruction.Res.UNCONSTRAINED,
        pc_update=Instruction.PcUpdate.JNZ,
        ap_update=Instruction.ApUpdate.REGULAR,
        fp_update=Instruction.FpUpdate.REGULAR,
        opcode=Instruction.Opcode.NOP,
    )
    assert build_instruction(parse_instruction('jmp rel [fp - 16] if [ap + 3] != 0')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(encoded[0], None) is False


def test_call():
    encoded = [0x1104800180018000, 1234]
    instruction = Instruction(
        off0=0,
        off1=1,
        off2=1,
        imm=1234,
        dst_register=Register.AP,
        op0_register=Register.AP,
        op1_addr=Instruction.Op1Addr.IMM,
        res=Instruction.Res.OP1,
        pc_update=Instruction.PcUpdate.JUMP_REL,
        ap_update=Instruction.ApUpdate.ADD2,
        fp_update=Instruction.FpUpdate.AP_PLUS2,
        opcode=Instruction.Opcode.CALL,
    )
    assert build_instruction(parse_instruction('call rel 1234')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(*encoded) is True


def test_ret():
    encoded = [0x208b7fff7fff7ffe]
    instruction = Instruction(
        off0=-2,
        off1=-1,
        off2=-1,
        imm=None,
        dst_register=Register.FP,
        op0_register=Register.FP,
        op1_addr=Instruction.Op1Addr.FP,
        res=Instruction.Res.OP1,
        pc_update=Instruction.PcUpdate.JUMP,
        ap_update=Instruction.ApUpdate.REGULAR,
        fp_update=Instruction.FpUpdate.DST,
        opcode=Instruction.Opcode.RET,
    )
    assert build_instruction(parse_instruction('ret')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(encoded[0], None) is False


def test_addap():
    encoded = [0x40780017fff7fff, 123]
    instruction = Instruction(
        off0=-1,
        off1=-1,
        off2=1,
        imm=123,
        dst_register=Register.FP,
        op0_register=Register.FP,
        op1_addr=Instruction.Op1Addr.IMM,
        res=Instruction.Res.OP1,
        pc_update=Instruction.PcUpdate.REGULAR,
        ap_update=Instruction.ApUpdate.ADD,
        fp_update=Instruction.FpUpdate.REGULAR,
        opcode=Instruction.Opcode.NOP)
    assert build_instruction(parse_instruction('ap += 123')) == instruction
    assert encode_instruction(instruction, prime=PRIME) == encoded
    assert decode_instruction(*encoded) == instruction
    assert is_call_instruction(*encoded) is False
