from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import Uint256
from warplib.memory import (wm_index_dyn, wm_read_felt, wm_write_felt)
from warplib.maths.utils import felt_to_uint256

# Copies felt values from a dynamic array into another
func dynamic_array_copy_felt{range_check_ptr, warp_memory : DictAccess*}(
    to_loc : felt, to_index : felt, to_final_index : felt, from_loc : felt, from_index : felt
):
    alloc_locals
    if to_index == to_final_index:
        return ()
    end
    let (to_index256) = felt_to_uint256(to_index)
    let (from_index256) = felt_to_uint256(from_index)
    let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0))
    let (from_index_loc) = wm_index_dyn(from_loc, from_index256, Uint256(1, 0))
    let (arg_elem) = wm_read_felt(from_index_loc)
    wm_write_felt(to_index_loc, arg_elem)
    return dynamic_array_copy_felt(to_loc, to_index + 1, to_final_index, from_loc, from_index + 1)
end
