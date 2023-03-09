// from starkware.cairo.common.cairo_builtins import BitwiseBuiltinœ
// from starkware.cairo.common.dict_access import DictAccess
// from starkware.cairo.common.uint256 import Uint256
// from starkware.cairo.common.math_cmp import is_le_felt

use array::ArrayTrait;
use warplib::integer::u256_from_felts;
use warplib::maths::pow2::pow2;
use warplib::maths::utils::felt_to_uint256;
use warplib::maths::utils::narrow_safe;
use warplib::maths::bytes_access::byte256_at_index;
use warplib::maths::bytes_access::byte_at_index;
use warplib::memory::wm_index_dyn;
use warplib::memory::wm_read_felt;
use warplib::memory::wm_write_felt;
use integer::u256_from_felt;
use integer::u32_from_felt;

// ----------------------- WARP Memory Dynamic Arrays Utils ----------------------------------
fn dynamic_array_copy_felt (to_loc: felt, to_index: felt, to_final_index: felt, from_loc: felt, from_index: felt) {
    if to_index == to_final_index {
        return ();
    }
    let to_index256: u256 = u256_from_felt(to_index);
    let from_index256: u256 = u256_from_felt(from_index);
    let to_index_loc: felt = wm_index_dyn(to_loc, to_index256, u256_from_felt(1));
    let from_index_loc: felt = wm_index_dyn(from_loc, from_index256, u256_from_felt(1));
    let from_elem: felt = wm_read_felt(from_index_loc);
    wm_write_felt(to_index_loc, from_elem);
    return dynamic_array_copy_felt(to_loc, to_index + 1, to_final_index, from_loc, from_index + 1);
}

fn fixed_bytes_to_dynamic_array (
    to_loc: felt,
    to_index: felt,
    to_final_index: felt,
    fixed_byte: felt,
    fixed_byte_index: felt,
    fixed_byte_width: felt,
) {
    if to_index == to_final_index {
        return ();
    }
    let to_index256: u256 = u256_from_felt(to_index);
    let to_index_loc: felt = wm_index_dyn(to_loc, to_index256, u256_from_felt(1));
    let from_elem: felt = byte_at_index(fixed_byte, fixed_byte_index, fixed_byte_width);
    wm_write_felt(to_index_loc, from_elem);
    return fixed_bytes_to_dynamic_array(
        to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1, fixed_byte_width
    );
}

fn fixed_bytes256_to_dynamic_array (to_loc: felt, to_index: felt, to_final_index: felt, fixed_byte: u256, fixed_byte_index: felt) {
    if to_index == to_final_index {
        return ();
    }
    let to_index256: u256 = u256_from_felt(to_index);
    let to_index_loc: felt = wm_index_dyn(to_loc, to_index256, u256_from_felt(1));
    let from_elem: felt  = byte256_at_index(fixed_byte, fixed_byte_index);
    wm_write_felt(to_index_loc, from_elem);
    return fixed_bytes256_to_dynamic_array(
        to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1
    );
}

fn byte_array_to_felt_value (index: felt, last_index: felt, mem_ptr: felt, acc_result: felt) -> felt {
    if index == last_index {
        return acc_result;
    }
    let index256: u256 = u256_from_felt(index);
    let byte_loc: felt = wm_index_dyn(mem_ptr, index256, u256_from_felt(1));
    let byte: felt = wm_read_felt(byte_loc);

    let power: felt = last_index - index - 1;
    // 256**power ->  2**(8 * power)
    let byte_power: felt = pow2(8 * power);
    let new_acc_val: felt = acc_result + (byte * byte_power);
    return byte_array_to_felt_value(index + 1, last_index, mem_ptr, new_acc_val);
}

fn byte_array_to_uint256_value (index: felt, last_index: felt, mem_ptr: felt, acc_low: felt, acc_high: felt) -> u256 {
    if index == last_index {
        return u256_from_felts(acc_low, acc_high);
    }

    let index256: u256 = u256_from_felt(index);
    let byte_loc: felt = wm_index_dyn(mem_ptr, index256, u256_from_felt(1));
    let byte: felt = wm_read_felt(byte_loc);

    let power: felt = last_index - index - 1;

    if power > 16 {
        let byte_power: felt = pow2(8 * (power - 16));
        let new_acc_high: felt = acc_high + (byte * byte_power);
        return byte_array_to_uint256_value(index + 1, last_index, mem_ptr, acc_low, new_acc_high);
    } else {
        let byte_power = pow2(8 * power);
        let new_acc_low = acc_low + (byte * byte_power);
        return byte_array_to_uint256_value(index + 1, last_index, mem_ptr, new_acc_low, acc_high);
    }
}

// Unsafe copy of elements from an array to the other from index to last_index
fn memory_dyn_array_copy (a_index: felt, a_ptr: felt, b_index: felt, b_last_index: felt, b_ptr: felt) {
    if b_index == b_last_index {
        return ();
    }
    // TODO: Check this dict_read and dict_write
    let elem = dict_read{dict_ptr=warp_memory}(a_ptr + 2 + a_index);
    dict_write{dict_ptr=warp_memory}(b_ptr + 2 + b_index, elem);
    return memory_dyn_array_copy(a_index + 1, a_ptr, b_index + 1, b_last_index, b_ptr);
}

// ----------------------- Felt Dynamic Arrays Utils ----------------------------------
fn felt_array_to_warp_memory_array (index: felt, ref array: Array::<felt>, mem_index: felt, mem_ptr: felt, max_length: felt) {
    if index == max_length {
        return ();
    }
    let elem: felt = *array.at(u32_from_felt(index));
    let mem_index256: u256 = u256_from_felt(mem_index);
    let elem_loc: felt = wm_index_dyn(mem_ptr, mem_index256, u256_from_felt(1));
    wm_write_felt(elem_loc, elem);
    return felt_array_to_warp_memory_array(index + 1, ref array, mem_index + 1, mem_ptr, max_length);
}

fn fixed_bytes256_to_felt_dynamic_array (array_index: felt, ref array: Array::<felt>, fixed_byte_index: felt, fixed_byte: u256) {
    if fixed_byte_index == 32 {
        return ();
    }
    let byte: felt = byte256_at_index(fixed_byte, fixed_byte_index);
    array.append(byte);
    return fixed_bytes256_to_felt_dynamic_array(
        array_index + 1, ref array, fixed_byte_index + 1, fixed_byte
    );
}

fn fixed_bytes256_to_felt_dynamic_array_spl(array_index: felt, ref array: Array::<felt>, fixed_byte_index: felt, fixed_byte: u256) -> felt {
    if fixed_byte_index == 32 {
        return array_index;
    }
    let byte: felt = byte256_at_index(fixed_byte, fixed_byte_index);
    array.append(byte);
    return fixed_bytes256_to_felt_dynamic_array_spl(
        array_index + 1, ref array, fixed_byte_index + 1, fixed_byte
    );
}

fn fixed_bytes_to_felt_dynamic_array (array_index: felt, ref array: Array::<felt>, fixed_byte_index: felt, fixed_byte: felt, fixed_byte_size: felt) {
    if fixed_byte_index == fixed_byte_size {
        return ();
    }
    let byte: felt = byte_at_index(fixed_byte, fixed_byte_index, fixed_byte_size);
    array.append(byte);
    return fixed_bytes_to_felt_dynamic_array(
        array_index + 1, ref array, fixed_byte_index + 1, fixed_byte, fixed_byte_size
    );
}

fn bytes_to_felt_dynamic_array (array_index: felt, array_offset: felt, ref array: Array::<felt>, element_offset: felt, mem_ptr: felt) -> (felt, felt) {
    // Store pointer to data
    let offset256: u256 = u256_from_felt(array_offset - element_offset);
    fixed_bytes256_to_felt_dynamic_array(array_index, ref array, 0, offset256);
    let new_index: felt = array_index + 32;
    // Store length
    let length_low: felt = wm_read_felt(mem_ptr);
    let length_high: felt = wm_read_felt(mem_ptr + 1);
    let length256: u256 = u256_from_felts(length_low, length_high);
    fixed_bytes256_to_felt_dynamic_array(array_offset, ref array, 0, length256);
    let new_offset: felt = array_offset + 32;
    // Store the data
    let length: felt = narrow_safe(length256);
    let bytes_needed: felt = bytes_upper_bound(length);
    let max_offset = new_offset + bytes_needed;
    bytes_to_felt_dynamic_array_inline(new_offset, max_offset, ref array, 0, length, mem_ptr + 2);
    return (new_index, max_offset);
}

fn bytes_to_felt_dynamic_array_spl(array_index: felt, ref array: Array::<felt>, mem_ptr: felt) -> felt {
    let length_low: felt = wm_read_felt(mem_ptr);
    let length_high: felt = wm_read_felt(mem_ptr + 1);
    let length256: u256 = u256_from_felts(length_low, length_high);
    let length: felt = narrow_safe(length256);
    let bytes_needed: felt = bytes_upper_bound(length);
    bytes_to_felt_dynamic_array_inline(
        array_index, array_index + bytes_needed, ref array, 0, length, mem_ptr + 2
    );
    return array_index + bytes_needed;
}

fn bytes_to_felt_dynamic_array_spl_without_padding(array_index: felt, ref array: Array::<felt>, mem_ptr: felt) -> felt {
    let length_low: felt = wm_read_felt(mem_ptr);
    let length_high: felt = wm_read_felt(mem_ptr + 1);
    let length256: u256 = u256_from_felts(length_low, length_high);
    let length: felt = narrow_safe(length256);
    bytes_to_felt_dynamic_array_inline(
        array_index, array_index + length, ref array, 0, length, mem_ptr + 2
    );
    return array_index + length;
}

fn bytes_to_felt_dynamic_array_inline(
    array_index: felt,
    array_offset: felt,
    ref array: Array::<felt>,
    mem_index: felt,
    mem_length: felt,
    mem_ptr: felt,
) {
    if array_index == array_offset {
        // Everything have been stored
        return ();
    }
    if mem_index <= mem_length - 1 {
        // Read each byte and copy it
        //TODO: Must be updated dict_read
        let byte: felt = dict_read{dict_ptr=warp_memory}(mem_ptr + mem_index);
        array.append(byte);
        return bytes_to_felt_dynamic_array_inline(
            array_index + 1, array_offset, ref array, mem_index + 1, mem_length, mem_ptr
        );
    } else {
        // Pad the rest of the slot with 0s
        array.append(0);
        return bytes_to_felt_dynamic_array_inline(
            array_index + 1, array_offset, ref array, mem_index, mem_length, mem_ptr
        );
    }
}

fn bytes_upper_bound(number: felt) -> felt {
    if number == 0 {
        return 0;
    }
    if number <= 32 {
        return 32;
    }
    let result = bytes_upper_bound(number - 32);
    return 32 + result;
}
