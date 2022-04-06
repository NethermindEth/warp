from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_eq, uint256_mul
from warplib.maths.utils import felt_to_uint256

# ------------------------------------------------------------------------------
# Warp memory schema
# Memory is represented as a time-ordered list of writes
# Reads work by starting at the latest and looking for writes to the cell to read
# Each object written has a unique name, and is comprised of one or more felts
# placed at incrementing offsets
#
# Special cells:
# Name = 0, offset = 0 contains the most recently generated name
# For arrays, the length is stored at offsets that are invalid uint256s
# ------------------------------------------------------------------------------

struct MemCell:
    member name : felt
    member offset : Uint256
    member value : felt
end

func warp_idx{range_check_ptr}(arrayIndex : Uint256, width : felt, offset : felt) -> (
    feltIndex : Uint256
):
    let (width256) = felt_to_uint256(width)
    let (offset256) = felt_to_uint256(offset)
    let (start : Uint256, overflow : Uint256) = uint256_mul(arrayIndex, width256)
    assert overflow.low = 0
    assert overflow.high = 0
    let (result : Uint256, carry : felt) = uint256_add(start, offset256)
    assert carry = 0
    return (result)
end

func warp_memory_init() -> (warp_memory : MemCell*):
    let (warp_memory : MemCell*) = alloc()
    assert warp_memory.name = 0
    assert warp_memory.offset.low = 0
    assert warp_memory.offset.high = 0
    assert warp_memory.value = 0
    return (warp_memory)
end

func warp_create_array{range_check_ptr, warp_memory : MemCell*}(len : Uint256) -> (name : felt):
    alloc_locals
    # Create a unique identifier for the array
    let (local name : felt) = _get_next_name()
    # Store the length starting at offset 0
    _set_array_length(name, len)
    # Fill the rest of the elements with 0s
    _init_arr(name, len, Uint256(0, 0))
    return (name=name)
end

func warp_memory_read{range_check_ptr}(warp_memory : MemCell*, name : felt, offset : Uint256) -> (
    res : felt
):
    let (is_correct_cell : felt) = _at_current_cell(warp_memory, name, offset)
    if is_correct_cell == 1:
        return (res=warp_memory.value)
    else:
        return warp_memory_read(warp_memory - MemCell.SIZE, name, offset)
    end
end

func warp_memory_write{warp_memory : MemCell*}(name : felt, offset : Uint256, value : felt) -> ():
    # First increment warp_memory, then set the properties of the new cell
    # This means that warp_memory always points to a valid cell
    let warp_memory = warp_memory + MemCell.SIZE
    assert warp_memory.name = name
    assert warp_memory.offset.low = offset.low
    assert warp_memory.offset.high = offset.high
    assert warp_memory.value = value
    return ()
end

# this is a uint256 that should never be generated from arithmetic or felt conversion
# this allows reads to use the full [0, 2^256) without clashing
const _len_offset_low = 2 ** 128
const _len_offset_high = 2 ** 128 + 1

func warp_get_array_length{range_check_ptr, warp_memory : MemCell*}(name : felt) -> (len : Uint256):
    alloc_locals
    let (local low : felt) = warp_memory_read(warp_memory, name, Uint256(_len_offset_low, 0))
    let (high : felt) = warp_memory_read(warp_memory, name, Uint256(_len_offset_high, 0))
    return (len=Uint256(low, high))
end

# ------------------------------implementation----------------------------------

func _set_array_length{warp_memory : MemCell*}(name : felt, len : Uint256) -> ():
    warp_memory_write(name, Uint256(_len_offset_low, 0), len.low)
    return warp_memory_write(name, Uint256(_len_offset_high, 0), len.high)
end

func _at_current_cell{range_check_ptr}(warp_memory : MemCell*, name : felt, offset : Uint256) -> (
    res : felt
):
    if warp_memory.name != name:
        return (0)
    end
    return uint256_eq(warp_memory.offset, offset)
end

func _get_next_name{range_check_ptr, warp_memory : MemCell*}() -> (name : felt):
    let (oldName : felt) = warp_memory_read(warp_memory, 0, Uint256(0, 0))
    let newName = oldName + 1
    warp_memory_write(0, Uint256(0, 0), newName)
    return (name=newName)
end

# recurse along the array, setting the length to the length and the values to 0
# start at curr = 0 and end once curr = len
func _init_arr{range_check_ptr, warp_memory : MemCell*}(
    name : felt, len : Uint256, curr : Uint256
) -> ():
    let (eq : felt) = uint256_eq(curr, len)
    if eq == 0:
        warp_memory_write(name, curr, 0)
        let (next : Uint256, _) = uint256_add(curr, Uint256(1, 0))
        return _init_arr(name, len, next)
    else:
        warp_memory_write(name, curr, 0)
        return ()
    end
end
