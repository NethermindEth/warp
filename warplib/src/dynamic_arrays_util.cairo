// from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
// from starkware.cairo.common.dict import dict_read, dict_write
// from starkware.cairo.common.dict_access import DictAccess
// from starkware.cairo.common.uint256 import Uint256
// from starkware.cairo.common.math_cmp import is_le_felt
// from warplib.maths.pow2 import pow2
// from warplib.maths.utils import felt_to_uint256, narrow_safe
// from warplib.maths.bytes_access import byte256_at_index, byte_at_index
// from warplib.memory import wm_index_dyn, wm_read_felt, wm_write_felt

use array::Array;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;

trait DynamicArrayUtilTrait {
    // WARP Memory Dynamic Arrays Utils
    fn dynamic_array_copy_felt(ref self: WarpMemory, to_loc: felt252, to_index: felt252, to_final_index: felt252, from_loc: felt252, from_index: felt252);

    // Felt Dynamic Arrays Utils
    fn felt_array_to_warp_memory_array(index: felt252, array: @Array<felt252>, mem_index: felt252, mem_ptr:  @Array<felt252>, max_length: felt252);
    fn fixed_bytes256_to_felt_dynamic_array(array_index: felt252, array: @Array<felt252>, fixed_byte_index: felt252, fixed_byte: u256);

}


impl DynamicArrayUtilImpl of DynamicArrayUtilTrait {
    fn dynamic_array_copy_felt(ref self: WarpMemory, to_loc: felt252, to_index: felt252, to_final_index: felt252, from_loc: felt252, from_index: felt252){

    }

    fn felt_array_to_warp_memory_array(ref self: WarpMemory, index: felt252, array: @Array<felt252>, mem_index: felt252, mem_ptr:  @Array<felt252>, max_length: felt252){
        if index == max_length {
            return ();
        }
        let elem = array[index];

        // get the location in the memory based on the allocated space for mem_ptr: abiEncode.ts#L95
        let mem_index : felt252 = self.index_dyn(mem_ptr, mem_index, 1); 
        self.write(mem_index, elem);
        return felt_array_to_warp_memory_array(index + 1, array, mem_index + 1, mem_ptr, max_length);
    }

// func fixed_bytes256_to_felt_dynamic_array{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(array_index: felt252, array: felt252*, fixed_byte_index: felt252, fixed_byte: Uint256) {
//     alloc_locals;
//     if (fixed_byte_index == 32) {
//         return ();
//     }
//     let (byte) = byte256_at_index(fixed_byte, fixed_byte_index);
//     assert array[array_index] = byte;
//     return fixed_bytes256_to_felt_dynamic_array(
//         array_index + 1, array, fixed_byte_index + 1, fixed_byte
//     );
// }    


    fn fixed_bytes256_to_felt_dynamic_array(array_index: felt252, array: @Array<felt252>, fixed_byte_index: felt252, fixed_byte: u256) {
        if fixed_byte_index == 32 {
            return ();
        }

        let byte = fixed_byte_at_index(fixed_byte, fixed_byte_index);
        array[array_index] = byte;

        return fixed_bytes256_to_felt_dynamic_array(array_index + 1, array, fixed_byte_index + 1, fixed_byte);
    }
    
}


// ----------------------- WARP Memory Dynamic Arrays Utils ----------------------------------
// func dynamic_array_copy_felt{range_check_ptr, warp_memory: DictAccess*}(
//     to_loc: felt252, to_index: felt252, to_final_index: felt252, from_loc: felt252, from_index: felt252
// ) {
//     alloc_locals;
//     if (to_index == to_final_index) {
//         return ();
//     }
//     let (to_index256) = felt_to_uint256(to_index);
//     let (from_index256) = felt_to_uint256(from_index);
//     let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0));
//     let (from_index_loc) = wm_index_dyn(from_loc, from_index256, Uint256(1, 0));
//     let (from_elem) = wm_read_felt(from_index_loc);
//     wm_write_felt(to_index_loc, from_elem);
//     return dynamic_array_copy_felt(to_loc, to_index + 1, to_final_index, from_loc, from_index + 1);
// }

// func fixed_bytes_to_dynamic_array{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(
//     to_loc: felt252,
//     to_index: felt252,
//     to_final_index: felt252,
//     fixed_byte: felt252,
//     fixed_byte_index: felt252,
//     fixed_byte_width: felt252,
// ) {
//     alloc_locals;
//     if (to_index == to_final_index) {
//         return ();
//     }
//     let (to_index256) = felt_to_uint256(to_index);
//     let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0));
//     let (from_elem) = byte_at_index(fixed_byte, fixed_byte_index, fixed_byte_width);
//     wm_write_felt(to_index_loc, from_elem);
//     return fixed_bytes_to_dynamic_array(
//         to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1, fixed_byte_width
//     );
// }

// func fixed_bytes256_to_dynamic_array{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(to_loc: felt252, to_index: felt252, to_final_index: felt252, fixed_byte: Uint256, fixed_byte_index: felt252) {
//     alloc_locals;
//     if (to_index == to_final_index) {
//         return ();
//     }
//     let (to_index256) = felt_to_uint256(to_index);
//     let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0));
//     let (from_elem) = byte256_at_index(fixed_byte, fixed_byte_index);
//     wm_write_felt(to_index_loc, from_elem);
//     return fixed_bytes256_to_dynamic_array(
//         to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1
//     );
// }

// func byte_array_to_felt_value{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(index: felt252, last_index: felt252, mem_ptr: felt252, acc_result: felt252) -> (res: felt252) {
//     alloc_locals;
//     if (index == last_index) {
//         return (res=acc_result);
//     }
//     let (index256) = felt_to_uint256(index);
//     let (byte_loc) = wm_index_dyn(mem_ptr, index256, Uint256(1, 0));
//     let (byte) = wm_read_felt(byte_loc);

//     let power = last_index - index - 1;
//     // 256**power ->  2**(8 * power)
//     let (byte_power) = pow2(8 * power);
//     let new_acc_val = acc_result + (byte * byte_power);
//     return byte_array_to_felt_value(index + 1, last_index, mem_ptr, new_acc_val);
// }

// func byte_array_to_uint256_value{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(index: felt252, last_index: felt252, mem_ptr: felt252, acc_low: felt252, acc_high) -> (res: Uint256) {
//     alloc_locals;
//     if (index == last_index) {
//         return (res=Uint256(acc_low, acc_high));
//     }

//     let (index256) = felt_to_uint256(index);
//     let (byte_loc) = wm_index_dyn(mem_ptr, index256, Uint256(1, 0));
//     let (byte) = wm_read_felt(byte_loc);

//     let power = last_index - index - 1;
//     let first_bytes = is_le_felt(16, power);

//     if (first_bytes == 1) {
//         let (byte_power) = pow2(8 * (power - 16));
//         let new_acc_high = acc_high + (byte * byte_power);
//         return byte_array_to_uint256_value(index + 1, last_index, mem_ptr, acc_low, new_acc_high);
//     } else {
//         let (byte_power) = pow2(8 * power);
//         let new_acc_low = acc_low + (byte * byte_power);
//         return byte_array_to_uint256_value(index + 1, last_index, mem_ptr, new_acc_low, acc_high);
//     }
// }

// // Unsafe copy of elements from an array to the other from index to last_index
// func memory_dyn_array_copy{bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*}(
//     a_index: felt252, a_ptr: felt252, b_index: felt252, b_last_index: felt252, b_ptr: felt252
// ) {
//     if (b_index == b_last_index) {
//         return ();
//     }
//     let (elem) = dict_read{dict_ptr=warp_memory}(a_ptr + 2 + a_index);
//     dict_write{dict_ptr=warp_memory}(b_ptr + 2 + b_index, elem);
//     return memory_dyn_array_copy(a_index + 1, a_ptr, b_index + 1, b_last_index, b_ptr);
// }

// // ----------------------- Felt Dynamic Arrays Utils ----------------------------------


// func fixed_bytes256_to_felt_dynamic_array_spl{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(array_index: felt252, array: felt252*, fixed_byte_index: felt252, fixed_byte: Uint256) -> (
//     final_index: felt252
// ) {
//     alloc_locals;
//     if (fixed_byte_index == 32) {
//         return (array_index,);
//     }
//     let (byte) = byte256_at_index(fixed_byte, fixed_byte_index);
//     assert array[array_index] = byte;
//     return fixed_bytes256_to_felt_dynamic_array_spl(
//         array_index + 1, array, fixed_byte_index + 1, fixed_byte
//     );
// }

// func fixed_bytes_to_felt_dynamic_array{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(
//     array_index: felt252, array: felt252*, fixed_byte_index: felt252, fixed_byte: felt252, fixed_byte_size: felt252
// ) {
//     alloc_locals;
//     if (fixed_byte_index == fixed_byte_size) {
//         return ();
//     }
//     let (byte) = byte_at_index(fixed_byte, fixed_byte_index, fixed_byte_size);
//     assert array[array_index] = byte;
//     return fixed_bytes_to_felt_dynamic_array(
//         array_index + 1, array, fixed_byte_index + 1, fixed_byte, fixed_byte_size
//     );
// }

// func bytes_to_felt_dynamic_array{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(array_index: felt252, array_offset: felt252, array: felt252*, element_offset: felt252, mem_ptr: felt252) -> (
//     final_index: felt252, final_offset: felt252
// ) {
//     alloc_locals;
//     // Store pointer to data
//     let (offset256) = felt_to_uint256(array_offset - element_offset);
//     fixed_bytes256_to_felt_dynamic_array(array_index, array, 0, offset256);
//     let new_index = array_index + 32;
//     // Store length
//     let (length_low) = wm_read_felt(mem_ptr);
//     let (length_high) = wm_read_felt(mem_ptr + 1);
//     let length256 = Uint256(length_low, length_high);
//     fixed_bytes256_to_felt_dynamic_array(array_offset, array, 0, length256);
//     let new_offset = array_offset + 32;
//     // Store the data
//     let (length) = narrow_safe(length256);
//     let (bytes_needed) = bytes_upper_bound(length);
//     let max_offset = new_offset + bytes_needed;
//     bytes_to_felt_dynamic_array_inline(new_offset, max_offset, array, 0, length, mem_ptr + 2);
//     return (new_index, max_offset);
// }

// func bytes_to_felt_dynamic_array_spl{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(array_index: felt252, array: felt252*, mem_ptr: felt252) -> (final_index: felt252) {
//     alloc_locals;
//     let (length_low) = wm_read_felt(mem_ptr);
//     let (length_high) = wm_read_felt(mem_ptr + 1);
//     let length256 = Uint256(length_low, length_high);
//     let (length) = narrow_safe(length256);
//     let (bytes_needed) = bytes_upper_bound(length);
//     bytes_to_felt_dynamic_array_inline(
//         array_index, array_index + bytes_needed, array, 0, length, mem_ptr + 2
//     );
//     return (array_index + bytes_needed,);
// }

// func bytes_to_felt_dynamic_array_spl_without_padding{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(array_index: felt252, array: felt252*, mem_ptr: felt252) -> (final_index: felt252) {
//     alloc_locals;
//     let (length_low) = wm_read_felt(mem_ptr);
//     let (length_high) = wm_read_felt(mem_ptr + 1);
//     let length256 = Uint256(length_low, length_high);
//     let (length) = narrow_safe(length256);
//     bytes_to_felt_dynamic_array_inline(
//         array_index, array_index + length, array, 0, length, mem_ptr + 2
//     );
//     return (array_index + length,);
// }

// func bytes_to_felt_dynamic_array_inline{
//     bitwise_ptr: BitwiseBuiltin*, range_check_ptr, warp_memory: DictAccess*
// }(
//     array_index: felt252,
//     array_offset: felt252,
//     array: felt252*,
//     mem_index: felt252,
//     mem_length: felt252,
//     mem_ptr: felt252,
// ) {
//     alloc_locals;
//     if (array_index == array_offset) {
//         // Everything have been stored
//         return ();
//     }
//     let lesser = is_le_felt(mem_index, mem_length - 1);
//     if (lesser == 1) {
//         // Read each byte and copy it
//         let (byte) = dict_read{dict_ptr=warp_memory}(mem_ptr + mem_index);
//         assert array[array_index] = byte;
//         return bytes_to_felt_dynamic_array_inline(
//             array_index + 1, array_offset, array, mem_index + 1, mem_length, mem_ptr
//         );
//     } else {
//         // Pad the rest of the slot with 0s
//         assert array[array_index] = 0;
//         return bytes_to_felt_dynamic_array_inline(
//             array_index + 1, array_offset, array, mem_index, mem_length, mem_ptr
//         );
//     }
// }

// func bytes_upper_bound{range_check_ptr: felt252}(number: felt252) -> (upper_bound: felt252) {
//     if (number == 0) {
//         return (0,);
//     }
//     let lesser = is_le_felt(number, 32);
//     if (lesser == 1) {
//         return (32,);
//     }
//     let (result) = bytes_upper_bound(number - 32);
//     return (32 + result,);
// }
