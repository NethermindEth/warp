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

use integer::u256_from_felt252;
use integer::u128_to_felt252;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::MemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;

// -----------------Scalars-----------------

// -----------------Arrays-----------------

#[implicit(warp_memory)]
fn wm_new(len: u256, elemWidth: u256) -> felt252 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    // Calculate space needed for array elements
    let feltLength = len * elemWidth;

    // Add space required to include the length member
    let feltLength = feltLength + u256_from_felt252(2);

    let empty_memory_start = wm_alloc(feltLength);
    warp_memory.insert(empty_memory_start, u128_to_felt252(len.low));
    warp_memory.insert(empty_memory_start + 1, u128_to_felt252(len.high));
    empty_memory_start
}

// -----------------Structs-----------------


// -----------------Helper functions-----------------


// Moves the free-memory pointer to allocate the given number of cells, and returns the index
// of the start of the allocated space
#[implicit(warp_memory)]
fn wm_alloc(space: u256) -> felt252 {
    // TODO Clean this warp_memory initialization once warp-memory plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    // Get current end pointer
    let freeCell = warp_memory.pointer;

    let spaceFelt252 = u128_to_felt252(space.low) + u128_to_felt252(space.high);
    let newFreeCell = freeCell + spaceFelt252;

    // Widen to u256 for safe calculation and because array lengths are u256
    let freeCell256 = u256_from_felt252(freeCell);
    let newFreeCell256 = freeCell256 + space;

    //Check if an overflow  didn't happen
    assert (newFreeCell256 != u256_from_felt252(newFreeCell), 'Overflow after addition');

    warp_memory.pointer = newFreeCell;
    freeCell
}

