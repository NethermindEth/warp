from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import Uint256
from warplib.maths.utils import felt_to_uint256
from warplib.maths.bytes_access import byte256_at_index, byte_at_index
from warplib.memory import wm_index_dyn, wm_read_felt, wm_write_felt

# ----------------------- WARP Memory Dynamic Arrays Utils ----------------------------------
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
    let (from_elem) = wm_read_felt(from_index_loc)
    wm_write_felt(to_index_loc, from_elem)
    return dynamic_array_copy_felt(to_loc, to_index + 1, to_final_index, from_loc, from_index + 1)
end

func fixed_bytes_to_dynamic_array{
    bitwise_ptr : BitwiseBuiltin*, range_check_ptr, warp_memory : DictAccess*
}(
    to_loc : felt,
    to_index : felt,
    to_final_index : felt,
    fixed_byte : felt,
    fixed_byte_index : felt,
    fixed_byte_width : felt,
):
    alloc_locals
    if to_index == to_final_index:
        return ()
    end
    let (to_index256) = felt_to_uint256(to_index)
    let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0))
    let (from_elem) = byte_at_index(fixed_byte, fixed_byte_index, fixed_byte_width)
    wm_write_felt(to_index_loc, from_elem)
    return fixed_bytes_to_dynamic_array(
        to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1, fixed_byte_width
    )
end

func fixed_bytes256_to_dynamic_array{
    bitwise_ptr : BitwiseBuiltin*, range_check_ptr, warp_memory : DictAccess*
}(
    to_loc : felt,
    to_index : felt,
    to_final_index : felt,
    fixed_byte : Uint256,
    fixed_byte_index : felt,
):
    alloc_locals
    if to_index == to_final_index:
        return ()
    end
    let (to_index256) = felt_to_uint256(to_index)
    let (to_index_loc) = wm_index_dyn(to_loc, to_index256, Uint256(1, 0))
    let (from_elem) = byte256_at_index(fixed_byte, fixed_byte_index)
    wm_write_felt(to_index_loc, from_elem)
    return fixed_bytes256_to_dynamic_array(
        to_loc, to_index + 1, to_final_index, fixed_byte, fixed_byte_index + 1
    )
end

# ----------------------- Felt Dynamic Arrays Utils ----------------------------------
func fixed_bytes256_to_felt_dynamic_array{
    bitwise_ptr : BitwiseBuiltin*, range_check_ptr, warp_memory : DictAccess*
}(
    array_index : felt,
    array : felt*,
    fixed_byte_index : felt,
    fixed_byte : Uint256,
):
    alloc_locals
    if fixed_byte_index == 32:
        return ()
    end
    let (byte) = byte256_at_index(fixed_byte, fixed_byte_index)
    assert array[array_index] = byte
    return fixed_bytes256_to_felt_dynamic_array(
        array_index + 1, array, fixed_byte_index + 1, fixed_byte
    )
end
