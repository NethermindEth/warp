%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_keccak.keccak import keccak_bigend
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and

from warplib.maths.pow2 import pow2
from warplib.maths.utils import get_min, narrow_safe
from warplib.memory import wm_to_felt_array

const BYTES_IN_FELT = 8;
const BITS_IN_BYTE = 8;

func warp_keccak{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, warp_memory: DictAccess*, keccak_ptr: felt*
}(loc: felt) -> (output: Uint256) {
    alloc_locals;
    let (input_len, input) = wm_to_felt_array(loc);
    let (packed_bytes_len, packed_bytes) = pack_bytes_felt(BYTES_IN_FELT, 0, input_len, input);

    let (res: Uint256) = keccak_bigend{keccak_ptr=keccak_ptr}(packed_bytes, input_len);

    return (res,);
}

func pack_bytes_felt{range_check_ptr}(
    packing_bytes: felt, big_endian: felt, input_len: felt, input: felt*
) -> (output_len: felt, output: felt*) {
    alloc_locals;
    let (bytes_buffer: felt*) = alloc();
    let (output_len: felt) = pack_bytes_felt_loop(
        packing_bytes, big_endian, 0, bytes_buffer, input_len, input
    );
    return (output_len, bytes_buffer,);
}

func pack_bytes_felt_loop{range_check_ptr}(
    packing_bytes: felt,
    big_endian: felt,
    index: felt,
    bytes_buffer: felt*,
    input_len: felt,
    input: felt*,
) -> (output_len: felt) {
    alloc_locals;

    let (chunk_size) = get_min(input_len, packing_bytes);

    if (chunk_size == 0) {
        return (index,);
    }

    let (packed_words) = pack_bytes_in_felt(packing_bytes, big_endian, 0, chunk_size, input, 0);
    assert bytes_buffer[index] = packed_words;

    let chunk_unaligned = is_le_felt(input_len, packing_bytes);

    if (chunk_unaligned == 1) {
        return (index + 1,);
    } else {
        return pack_bytes_felt_loop(
            packing_bytes,
            big_endian,
            index + 1,
            bytes_buffer,
            input_len - packing_bytes,
            &input[packing_bytes],
        );
    }
}

func pack_bytes_in_felt{range_check_ptr}(
    packing_bytes: felt,
    big_endian: felt,
    byte_index: felt,
    chunk_size: felt,
    input: felt*,
    byte_buffer: felt,
) -> (packed_byte: felt) {
    alloc_locals;

    if (byte_index == chunk_size) {
        return (byte_buffer,);
    }

    let byte = input[byte_index];

    if (big_endian == 1) {
        let (shift_offset) = pow2(BITS_IN_BYTE * (packing_bytes - byte_index - 1));
    } else {
        let (shift_offset) = pow2(BITS_IN_BYTE * byte_index);
    }

    let shifted_val = byte * shift_offset;

    let byte_buffer = byte_buffer + shifted_val;

    return pack_bytes_in_felt(
        packing_bytes, big_endian, byte_index + 1, chunk_size, input, byte_buffer
    );
}

func felt_array_concat{range_check_ptr}(
    src_len: felt, src_index: felt, src: felt*, dest_index: felt, dest: felt*
) -> (dest_len: felt) {
    alloc_locals;

    let src_index_pos = is_le_felt(src_len, src_index);
    if (src_index_pos == 1) {
        return (dest_index,);
    }
    assert dest[dest_index] = src[src_index];
    return felt_array_concat(src_len, src_index + 1, src, dest_index + 1, dest);
}

func append_felt_to_felt_array{range_check_ptr}(input: felt, dest_index: felt, dest: felt*) -> (
    dest_len: felt
) {
    alloc_locals;
    assert dest[dest_index] = input;
    return (dest_index + 1,);
}
