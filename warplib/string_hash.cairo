// from starkware.cairo.common.alloc import alloc
// from starkware.cairo.common.cairo_builtins import HashBuiltin
// from starkware.cairo.common.dict_access import DictAccess
// from starkware.cairo.common.memcpy import memcpy
// from warplib.maths.utils import narrow_safe
// from warplib.memory import wm_to_felt_array


use array::Array;
use array::ArrayTrait;


fn hash_chain(arr: @Array::<felt>, pos: u32) -> felt {
    let next = pos + 1_u32;
    if (next == arr.len()) {
        return *arr.at(pos);
    }
    return pedersen(*arr.at(pos), hash_chain(arr, next));
}


fn string_hash(arr: @Array::<felt>) -> felt {
    return hash_chain(arr, 1_u32);
}

// func wm_string_hash{pedersen_ptr: HashBuiltin*, range_check_ptr, warp_memory: DictAccess*}(
//     mem_loc: felt
// ) -> felt {
//     let (len, ptr) = wm_to_felt_array(mem_loc);

//     let hashedValue = string_hash(len, ptr);
//     return hashedValue;
// }

// STRING HASH STORAGE IS CREATED DURING TRANSPILATION
