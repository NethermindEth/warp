from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_le, uint256_lt, uint256_mul
from warplib.maths.utils import felt_to_uint256, narrow_safe

# =================================THE PLAN=================================
# Memory needs to be able to handle the following types:
# Scalars
#     Ints, bools, addresses, etc
# Arrays
#     Static, and dynamic
# Structs

# Scalars are easy, they fit in one or two felts each, and read functions
# can be prewritten here

# Static arrays are just elements laid out consecutively in memory

# Dynamic arrays are harder, they are stored as felts that 'point' to an
# allocated data space that contains first the length and then the data
# This means that they can have a known size when being packed into a
# compound type but can still have a number of elements known only at runtime

# ===========================================================================

# -----------------Scalars-----------------

func wm_read_felt{warp_memory : DictAccess*}(loc : felt) -> (val : felt):
    let (res) = dict_read{dict_ptr=warp_memory}(loc)
    return (res)
end

func wm_read_256{warp_memory : DictAccess*}(loc : felt) -> (val : Uint256):
    let (low) = dict_read{dict_ptr=warp_memory}(loc)
    let (high) = dict_read{dict_ptr=warp_memory}(loc + 1)
    return (Uint256(low, high))
end

func wm_write_felt{warp_memory : DictAccess*}(loc : felt, value : felt) -> (res : felt):
    dict_write{dict_ptr=warp_memory}(loc, value)
    return (value)
end

func wm_write_256{warp_memory : DictAccess*}(loc : felt, value : Uint256) -> (res : Uint256):
    dict_write{dict_ptr=warp_memory}(loc, value.low)
    dict_write{dict_ptr=warp_memory}(loc + 1, value.high)
    return (value)
end

# -----------------Arrays-----------------

func wm_index_static{range_check_ptr}(
    arrayLoc : felt, index : Uint256, width : Uint256, length : Uint256
) -> (loc : felt):
    # Check that the array index is valid
    let (inRange) = uint256_lt(index, length)
    assert inRange = 1

    # Multiply index by element width to calculate felt offset
    let (offset : Uint256, overflow : Uint256) = uint256_mul(index, width)
    assert overflow.low = 0
    assert overflow.high = 0

    # Add felt offset to address of array to get address of element
    let (arrayLoc256 : Uint256) = felt_to_uint256(arrayLoc)
    let (res : Uint256, carry : felt) = uint256_add(arrayLoc256, offset)
    assert carry = 0

    # Safely narrow back to felt
    let (loc : felt) = narrow_safe(res)
    return (loc)
end

func wm_index_dyn{range_check_ptr, warp_memory : DictAccess*}(
    arrayLoc : felt, index : Uint256, width : Uint256
) -> (loc : felt):
    alloc_locals
    # Get the length of the array and check that the index is within bounds
    let (length : Uint256) = wm_read_256(arrayLoc)
    let (inRange) = uint256_lt(index, length)
    assert inRange = 1

    # Calculate the location of the element
    let (offset : Uint256, overflow : Uint256) = uint256_mul(index, width)
    assert overflow.low = 0
    assert overflow.high = 0

    let (elementZeroPtr) = felt_to_uint256(arrayLoc + 2)
    let (res256 : Uint256, carry) = uint256_add(elementZeroPtr, offset)
    assert carry = 0
    let (res) = narrow_safe(res256)

    return (res)
end

func wm_new{range_check_ptr, warp_memory : DictAccess*}(len : Uint256, elemWidth : Uint256) -> (
    loc : felt
):
    alloc_locals
    # Calculate space needed for array elements
    let (feltLength : Uint256, overflow : Uint256) = uint256_mul(len, elemWidth)
    assert overflow.low = 0
    assert overflow.high = 0

    # Add space required to include the length member
    let (feltLength : Uint256, carry : felt) = uint256_add(feltLength, Uint256(2, 0))
    assert carry = 0

    let (loc) = wm_alloc(feltLength)
    dict_write{dict_ptr=warp_memory}(loc, len.low)
    dict_write{dict_ptr=warp_memory}(loc + 1, len.high)
    return (loc)
end

func wm_dyn_array_length{warp_memory : DictAccess*}(arrayLoc : felt) -> (len: Uint256):
    let (low) = dict_read{dict_ptr=warp_memory}(loc)
    let (high) = dict_read{dict_ptr=warp_memory}(loc + 1)
    return (Uint256(low, high))
end

# -----------------Structs-----------------

func index_struct(loc : felt, index : felt) -> (indexLoc : felt):
    # No need to range check here, that was already done when the struct was allocated
    return (loc + index)
end

# -----------------Helper functions-----------------

# Moves the free-memory pointer to allocate the given number of cells, and returns the index
# of the start of the allocated space
func wm_alloc{range_check_ptr, warp_memory : DictAccess*}(space : Uint256) -> (start : felt):
    alloc_locals
    # Get current end pointer
    let (freeCell) = dict_read{dict_ptr=warp_memory}(0)

    # Widen to uint256 for safe calculation and because array lengths are uint256
    let (freeCell256) = felt_to_uint256(freeCell)
    let (newFreeCell256 : Uint256, carry) = uint256_add(freeCell256, space)
    assert carry = 0
    let (newFreeCell) = narrow_safe(newFreeCell256)
    dict_write{dict_ptr=warp_memory}(0, newFreeCell)
    return (freeCell)
end
