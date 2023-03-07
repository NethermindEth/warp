
// =================================THE PLAN=================================
// Memory needs to be able to handle the following types:
// Scalars
//     Ints, bools, addresses, etc
// Arrays
//     Static, and dynamic
// Structs

// Scalars are easy, they fit in one or two felts each, and read functions
// can be prewritten here

// Static arrays are just elements laid out consecutively in memory

// Dynamic arrays are harder, they are stored as felts that 'point' to an
// allocated data space that contains first the length and then the data
// This means that they can have a known size when being packed into a
// compound type but can still have a number of elements known only at runtime

// ===========================================================================

// -----------------Scalars-----------------

use core::dict::DictFeltToTrait;
use core::integer;
use core::integer::u128_from_felt;
use core::integer::u128_to_felt;
use core::integer::u256_from_felt;
use core::array::ArrayTrait;

extern fn narrow_safe(x: u256) -> felt nopanic; // can be replaced with import once available


fn wm_read_felt(ref warp_memory: DictFeltTo::<felt> ,  loc: felt) -> felt {
    warp_memory.get(loc)
}

fn wm_read_256(ref warp_memory: DictFeltTo::<felt> ,  loc: felt) -> u256 {
    let low = u128_from_felt(warp_memory.get(loc));
    let high = u128_from_felt(warp_memory.get(loc + 1));
    return u256{low, high};
}

fn wm_write_felt(ref warp_memory: DictFeltTo::<felt>, loc: felt, value: felt) -> felt {
    warp_memory.insert(loc, value);
    value
}

fn wm_write_256(ref warp_memory: DictFeltTo::<felt> ,loc: felt, value: u256) -> u256 {
    warp_memory.insert(loc, u128_to_felt(value.low));
    warp_memory.insert(loc + 1, u128_to_felt(value.high));
    value
}

// -----------------Arrays-----------------

fn wm_index_static(
    arrayLoc: felt, index: u256, width: u256, length: u256
) -> felt {
    // Check that the array index is valid
    assert(index < length, 'Index out of bounds');

    let offset = index * width;

    // Add felt offset to address of array to get address of element
    let arrayLoc256: u256 = u256_from_felt(arrayLoc);

    let res = arrayLoc256 + offset;

    // Safely narrow back to felt
    narrow_safe(res)
}

fn wm_index_dyn(ref warp_memory: DictFeltTo::<felt> ,
    arrayLoc: felt, index: u256, width: u256
) -> felt {
    
    // Get the length of the array and check that the index is within bounds
    let length: u256 = wm_read_256(ref warp_memory, arrayLoc);

    assert( index < length, 'Index out of bounds');

    // Calculate the location of the element
    let offset = index * width;

    let elementZeroPtr = u256_from_felt(arrayLoc + 2);
    let res256= elementZeroPtr +  offset;
    
    narrow_safe(res256)
}

fn wm_new(ref warp_memory: DictFeltTo::<felt> ,len: u256, elemWidth: u256) -> felt {
    
    // Calculate space needed for array elements
    let mut feltLength = len * elemWidth;

    // Add space required to include the length member
    let feltLength = feltLength + u256_from_felt(2);

    let loc = wm_alloc(ref warp_memory, feltLength);
    warp_memory.insert(loc, u128_to_felt(len.low));
    warp_memory.insert(loc + 1, u128_to_felt(len.high));
    return loc;
}

fn wm_dyn_array_length(ref warp_memory: DictFeltTo::<felt> ,arrayLoc: felt) -> u256 {
    let low = warp_memory.get(arrayLoc);
    let high = warp_memory.get(arrayLoc + 1);
    u256 { low: u128_from_felt(low), high: u128_from_felt(high) }
}

// The wm_bytes methods below are not currently in use since solidity dynamic
// memory arrays do not support `push` and `pop` operations. They are kept with
// the expectation that they will likely be added to solidity soon.
fn wm_bytes_new(ref warp_memory: DictFeltTo::<felt> ,len: u256) -> felt {
    
    // Create an array to hold the bytes
    let arrayLoc = wm_alloc(ref warp_memory, len);

    // Create a location with the metadata for the bytesLoc
    // Size is five for (lenght: u256, capacity: u256, ptr: felt)
    let loc = wm_alloc(ref warp_memory, u256{low: u128_from_felt(5), high:u128_from_felt(0)});
    warp_memory.insert(loc,  u128_to_felt(len.low));
    warp_memory.insert(loc + 1, u128_to_felt(len.high));
    warp_memory.insert(loc + 2, u128_to_felt(len.low));
    warp_memory.insert(loc + 3, u128_to_felt(len.high));
    warp_memory.insert(loc + 4, arrayLoc);

    return loc;
}

fn wm_bytes_push(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt, value: felt) -> u256 {
    

    // Compute the new length
    let length = wm_read_256(ref warp_memory, bytesLoc);
    let newLength = length + u256{low: u128_from_felt(1), high: u128_from_felt(0)};

    // Update the length in memory
    warp_memory.insert(bytesLoc, u128_to_felt(newLength.low));
    warp_memory.insert(bytesLoc + 1, u128_to_felt(newLength.high));

    let capacity = wm_read_256(ref warp_memory, bytesLoc + 2);
    let arrayLoc = wm_read_felt(ref warp_memory, bytesLoc + 4);

    // Check our memory array has enough capacity
    if (length < capacity) {
        // Add length to address of array to get address of the new slot
        let arrayLoc256 = u256_from_felt(arrayLoc);
        let res: u256 = arrayLoc256 + length;
        // Safely narrow back to felt
        let loc: felt = narrow_safe(res);
        // Write the new value
        warp_memory.insert(loc, value);
    } else {
        // Double the capacity
        let newCapacity = capacity * u256{low:u128_from_felt(2), high: u128_from_felt(0)};
        // This assert isn't perfect, if the old capacity is >= 2^255 this will
        // fail while there may still be plenty of capacity left. However there
        // is no computer capable of hitting this bound so I'm happy to fail
        // early
        let newArrayLoc = wm_alloc(ref warp_memory, newCapacity);

        // Copy the old array to the new one
        let len = narrow_safe(length);
        wm_copy(ref warp_memory, arrayLoc, newArrayLoc, len);

        // Update the capacity in memory
        warp_memory.insert(bytesLoc + 2, u128_to_felt(newCapacity.low));
        warp_memory.insert(bytesLoc + 3, u128_to_felt(newCapacity.high));
        // Update the array pointer
        warp_memory.insert(bytesLoc + 4, newArrayLoc);

        // Add length to address of array to get address of the new slot
        let arrayLoc256 = u256_from_felt(newArrayLoc);
        let res = arrayLoc256 +  length;
        
        // Safely narrow back to felt
        let loc = narrow_safe(res);

        // Write the new value
        warp_memory.insert(loc, value);
    }
    return newLength;
}

fn wm_bytes_pop(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt) -> (
    felt, u256
) {
    
    let length = wm_read_256(ref warp_memory, bytesLoc);
    
    assert(length != u256_from_felt(0), 'Empty Array');

    // Compute the new length
    let newLength = length- u256{low:u128_from_felt(1), high:u128_from_felt(0)};

    // Read the popped value

    // Read the pointer to array
    let arrayLoc = wm_read_felt(ref warp_memory, bytesLoc + 4);
    // Add newLength to address of array to get address of the tail
    let arrayLoc256 = u256_from_felt(arrayLoc);
    let res: u256 = arrayLoc256 + newLength;

    // Safely narrow back to felt
    let loc = narrow_safe(res);

    // Read the value
    let value = warp_memory.get(loc);

    // Write the new length
    warp_memory.insert(bytesLoc, u128_to_felt(newLength.low));
    warp_memory.insert(bytesLoc + 1, u128_to_felt(newLength.high));

    return (value, newLength);
}

fn wm_bytes_index(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt, index: u256) -> felt {
    

    // Get the arrayLoc
    let arrayLoc = wm_read_felt(ref warp_memory, bytesLoc + 4);

    // Get the length of the array and check that the index is within bounds
    let length = wm_read_256(ref warp_memory, bytesLoc);

    assert(index < length, 'Index out of bounds');

    let arrayLoc256 = u256_from_felt(arrayLoc);
    let res256: u256 = arrayLoc256 + index;
    
    narrow_safe(res256)
}

fn wm_bytes_length(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt) -> u256 {
     wm_read_256(ref warp_memory, bytesLoc)
}

fn wm_bytes_to_fixed32(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt) -> u256 {
    
    let dataLength = wm_read_256(ref warp_memory, bytesLoc);
    if (dataLength.high == u128_from_felt(0)) {
        let high = wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 2, 16, u128_to_felt(dataLength.low), 0);

        if (dataLength.low< u128_from_felt(16)) {
            let low = wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 18, 16, u128_to_felt(dataLength.low) - 16, 0);
            return u256{low:u128_from_felt(low), high:u128_from_felt(high)};
        } else {
            return u256{low:u128_from_felt(0), high:u128_from_felt(high)};
        }
    } else {
        let high = wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 2, 16, 16, 0);
        let low = wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 18, 16, 16, 0);
        return u256{low:u128_from_felt(low), high:u128_from_felt(high)};
    }
}

fn wm_bytes_to_fixed(ref warp_memory: DictFeltTo::<felt> ,bytesLoc: felt, width: felt) -> felt {
    
    let dataLength = wm_read_256(ref warp_memory, bytesLoc);
    if (dataLength.high == u128_from_felt(0)) {
        return wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 2, width, u128_to_felt(dataLength.low), 0);
    } else {
        return wm_bytes_to_fixed_helper(ref warp_memory, bytesLoc + 2, width, width, 0);
    }
}

// -----------------Structs-----------------

fn index_struct(loc: felt, index: felt) -> felt {
    // No need to range check here, that was already done when the struct was allocated
    return loc + index;
}

// -----------------Helper functions-----------------

// Returns an exisiting pointer to a reference data type structure. If it does not exist, it will
// create a new pointer
fn wm_read_id(ref warp_memory: DictFeltTo::<felt> ,loc: felt, size: u256) -> felt{
    let id = warp_memory.get(loc);
    if (id != 0) {
        return id;
    }
    let id = wm_alloc(ref warp_memory, size);
    warp_memory.insert(loc, id);
    return id;
}

// Moves the free-memory pointer to allocate the given number of cells, and returns the index
// of the start of the allocated space
fn wm_alloc(ref warp_memory: DictFeltTo::<felt> ,space: u256) -> felt {
    
    // Get current end pointer
    let freeCell = warp_memory.get(0);

    // Widen to u256 for safe calculation and because array lengths are u256
    let freeCell256 = u256_from_felt(freeCell);
    let newFreeCell256 = freeCell256 + space;
    
    let newFreeCell = narrow_safe(newFreeCell256);
    warp_memory.insert(0, newFreeCell);
    return freeCell;
}

// Copies length felts from src to dst
fn wm_copy(ref warp_memory: DictFeltTo::<felt> ,src: felt, dst: felt, length: felt) {
    
    if (length == 0) {
        return ();
    }

    let srcVal = warp_memory.get(src);
    warp_memory.insert(dst, srcVal);

    wm_copy(ref warp_memory, src + 1, dst + 1, length - 1);
    return ();
}

// Converts an array in memory to a felt array
fn wm_to_felt_array(ref warp_memory: DictFeltTo::<felt> ,loc: felt) -> (
    felt , @Array::<felt>
) {
    
    let mut output= ArrayTrait::<felt>::new() ;

    let lengthu256: u256 = wm_read_256(ref warp_memory, loc);
    let length_felt: felt = narrow_safe(lengthu256);

    wm_to_felt_array_helper(ref warp_memory, loc + 2, 0, length_felt, ref output);

    return (length_felt, @output);
}

fn wm_to_felt_array_helper(ref warp_memory: DictFeltTo::<felt> ,
    loc: felt, index: felt, length: felt, ref output: Array::<felt>
) {
    
    if (index == length) {
        return ();
    }

    let value: felt = warp_memory.get(loc);

    output.append(value);

    return wm_to_felt_array_helper(ref warp_memory, loc + 1, index + 1, length, ref output);
}

fn wm_bytes_to_fixed_helper(ref warp_memory: DictFeltTo::<felt> ,
    bytesDataLoc: felt, targetWidth: felt, dataLength: felt, acc: felt
) -> felt {
    
    if (targetWidth == 0) {
        return acc;
    }
    if (dataLength == 0) {
        return wm_bytes_to_fixed_helper(ref warp_memory, 
            bytesDataLoc + 1, targetWidth - 1, dataLength - 1, 256 * acc
        );
    } else {
        let byte = wm_read_felt(ref warp_memory, bytesDataLoc);
        return wm_bytes_to_fixed_helper(ref warp_memory, 
            bytesDataLoc + 1, targetWidth - 1, dataLength - 1, 256 * acc + byte
        );
    }
}
