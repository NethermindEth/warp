from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.hash_chain import hash_chain
from starkware.cairo.common.memcpy import memcpy
from warplib.maths.utils import narrow_safe
from warplib.memory import wm_to_felt_array

func string_hash{pedersen_ptr: HashBuiltin*}(len: felt, ptr: felt*) -> (hashedValue: felt) {
    alloc_locals;
    if (len == 0) {
        return (0,);
    }

    let (temp) = alloc();
    assert [temp] = len;
    memcpy(temp + 1, ptr, len);

    let (hashedValue) = hash_chain{hash_ptr=pedersen_ptr}(temp);
    return (hashedValue,);
}

func wm_string_hash{pedersen_ptr: HashBuiltin*, range_check_ptr, warp_memory: DictAccess*}(
    mem_loc: felt
) -> (hashedValue: felt) {
    alloc_locals;
    let (len, ptr) = wm_to_felt_array(mem_loc);

    let (hashedValue) = string_hash{pedersen_ptr=pedersen_ptr}(len, ptr);
    return (hashedValue,);
}

// STRING HASH STORAGE IS CREATED DURING TRANSPILATION
