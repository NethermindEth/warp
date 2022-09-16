%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_keccak.keccak import keccak_bigend
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256

from warplib.maths.pow2 import pow2
from warplib.maths.utils import get_min
from warplib.memory import wm_to_felt_array

const BYTES_IN_FELT = 8;
const BITS_IN_BYTE = 8;

func warp_keccak{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*, keccak_ptr: felt*
}(loc: felt) -> (output: Uint256) {
    alloc_locals;
    let (input_len, input) = wm_to_felt_array(loc);
    let (packed_bytes) = pack_bytes_felt(input_len, input);

    let (res: Uint256) = keccak_bigend{keccak_ptr=keccak_ptr}(packed_bytes, input_len);

    return (res,);
}

func pack_bytes_felt{range_check_ptr}(input_len: felt, input: felt*) -> (output: felt*) {
    alloc_locals;
    let (bytes_buffer: felt*) = alloc();
    pack_bytes_felt_loop(0, bytes_buffer, input_len, input);
    return (bytes_buffer,);
}

func pack_bytes_felt_loop{range_check_ptr}(
    index: felt, bytes_buffer: felt*, input_len: felt, input: felt*
) -> () {
    alloc_locals;
    let (chunk_size) = get_min(input_len, BYTES_IN_FELT);

    let (packed_words) = pack_bytes_in_felt(0, chunk_size, input, 0);
    assert bytes_buffer[index] = packed_words;

    let chunk_unaligned = is_le_felt(input_len, BYTES_IN_FELT);

    if (chunk_unaligned == 1) {
        return ();
    } else {
        return pack_bytes_felt_loop(
            index + 1, bytes_buffer, input_len - BYTES_IN_FELT, &input[BYTES_IN_FELT]
        );
    }
}

func pack_bytes_in_felt{range_check_ptr}(
    byte_index: felt, chunk_size: felt, input: felt*, byte_buffer: felt
) -> (packed_byte: felt) {
    alloc_locals;

    if (byte_index == chunk_size) {
        return (byte_buffer,);
    }

    let byte = input[byte_index];
    let (shift_offset) = pow2(BITS_IN_BYTE * byte_index);
    let shifted_val = byte * shift_offset;

    let byte_buffer = byte_buffer + shifted_val;

    return pack_bytes_in_felt(byte_index + 1, chunk_size, input, byte_buffer);
}
