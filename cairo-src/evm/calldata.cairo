%builtins output range_check

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256, uint256_exp128, uint256_shl, uint256_or
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.math_cmp import is_le
from evm.bit_packing import read_uint128
from evm.memory import extract_byte
from evm.utils import floor_div, serialize_array

const SHIFT_BYTE = 8

func calldata_load{range_check_ptr}(offset, calldata : felt*) -> (res : Uint256):
    alloc_locals
    let (local return_arr : felt*) = alloc()
    let (local return_arr : felt*) = calldata_load_inner(offset, calldata, 0, return_arr)
    let (local low ) = merge_bytes(bytes=res, 0, Uint256(0,0))
    let (local high ) = merge_bytes(res-16, 0, Uint256(0,0))
    return (Uint256(low, high))
end

func calldata_load_inner{range_check_ptr}(return_arr : felt*, calldata : felt*, count, offset) -> (res: felt*):
    alloc_locals
    if count == 31:
        let (local off, rem) = unsigned_div_rem(offset+count, 16)
        let (_, local iter, _) = extract_byte([calldata + off], rem)
        assert [val] = iter
        return (val)
    end
    let (local off, rem) = unsigned_div_rem(offset+count, 16)
    let (_, local iter, _) = extract_byte([calldata + off], rem)
    assert [val] = iter
    return calldata_load_inner(offset=offset, calldata=calldata, count=count+1, val=val+1)
end

func merge_bytes{range_check_ptr}(bytes : felt*, count, merged: Uint256) -> (res: felt): 
    alloc_locals
    if count == 0:
        local first : Uint256 = Uint256([bytes], 0)
        local second : Uint256 = Uint256([bytes - 1], 0)
        let (local a : Uint256) = uint256_shl(first, Uint256(SHIFT_BYTE,0))
        let (local merged : Uint256) = uint256_or(a , second)
        return merge_bytes(bytes=bytes-2, count=count+2,merged=merged)
    end

    if count == 15:
        local first : Uint256 = merged
        local second : Uint256 = Uint256([bytes], 0)
        let (local a : Uint256) = uint256_shl(first, Uint256(SHIFT_BYTE,0))
        let (local merged : Uint256) = uint256_or(a , second)
        return (merged.low)
    end

    local first : Uint256 = merged
    local second : Uint256 = Uint256([bytes], 0)
    let (local a : Uint256) = uint256_shl(first, Uint256(SHIFT_BYTE,0))
    let (local merged : Uint256) = uint256_or(a , second)
    return merge_bytes(bytes=bytes-1, count=count+1,merged=merged)
end
