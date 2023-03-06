use array::ArrayTrait;
use memory::wm_to_felt_array;

const BYTES_IN_FELT: felt = 8;
const BITS_IN_BYTE: felt = 8;

fn warp_keccak(loc: felt) -> u256 {
    let (input_len, input) = wm_to_felt_array(loc);
    let (packed_bytes_len, packed_bytes) = pack_bytes_felt(BYTES_IN_FELT, 0, input_len, input);
    // return statement
    return keccak_bigend(packed_bytes, input_len);
}

fn pack_bytes_felt(
    packing_bytes: felt, big_endian: felt, input_len: felt, ref input: Array::<felt>
) -> (felt, Array::<felt>) {
    let mut bytes_buffer = ArrayTrait::new();
    let output_len = pack_bytes_felt_loop(
        packing_bytes, big_endian, 0, ref bytes_buffer, input_len, ref input, 0
    );
    return (output_len, bytes_buffer);
}

fn pack_bytes_felt_loop(
    packing_bytes: felt,
    big_endian: felt,
    index: felt,
    ref bytes_buffer: Array<felt>,
    input_len: felt,
    ref input: Array::<felt>,
    input_offset : felt,
) -> felt {
    let mut chunk_size: felt = 0;

    if input_len < packing_bytes {
        chunk_size = input_len;
    }else {
        chunk_size = packing_bytes;
    }


    if chunk_size == 0 {
        return index;
    }

    let packed_words = pack_bytes_in_felt(packing_bytes, big_endian, 0, chunk_size, ref input, 0, input_offset);

    bytes_buffer.append(packed_words);

    if input_len <= packing_bytes {
        return index + 1;
    } else {
        return pack_bytes_felt_loop(
            packing_bytes,
            big_endian,
            index + 1,
            ref bytes_buffer,
            input_len - packing_bytes,
            ref input, 
            input_offset + packing_bytes
        );
    }
}

fn pack_bytes_in_felt(
    packing_bytes: felt,
    big_endian: felt,
    byte_index: felt,
    chunk_size: felt,
    ref input: Array::<felt>, 
    byte_buffer: felt,
    input_offset: felt,
) -> felt {

    if (byte_index == chunk_size) {
        return byte_buffer;
    }

    let mut shift_offset: felt = 0;

    let byte:felt = *input.at(integer::u32_from_felt(byte_index + input_offset)); 
    if (big_endian == 1) {
        shift_offset = pow2(BITS_IN_BYTE * (packing_bytes - byte_index - 1));
    } else {
        shift_offset = pow2(BITS_IN_BYTE * byte_index);
    }

    let shifted_val = byte * shift_offset;

    let byte_buffer = byte_buffer + shifted_val;

    return pack_bytes_in_felt(
        packing_bytes, big_endian, byte_index + 1, chunk_size, ref input, byte_buffer, input_offset
    );
}

fn felt_array_concat(
    src_len: felt, src_index: felt, ref src: Array::<felt> , dest_index: felt, ref dest: Array::<felt>) -> felt {

    if src_len <= src_index {
        return dest_index;
    }
    dest.append(*src.at(integer::u32_from_felt(src_index)));
    return felt_array_concat(src_len, src_index + 1,ref src, dest_index + 1, ref dest);
}

fn append_felt_to_felt_array(input: felt, dest_index: felt, ref dest: Array::<felt>) -> felt {
    dest.append(input);
    return dest_index + 1;
}
