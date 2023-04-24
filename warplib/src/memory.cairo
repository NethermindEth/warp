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
use warplib::integer::u256_from_felts;
use warplib::integer::u256_to_felt252_safe;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::MemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;

// -----------------Scalars-----------------

#[implicit(warp_memory: WarpMemory)]
fn wm_read_256(loc: felt252) -> u256 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 
    
    let low = warp_memory.get(loc);
    let high = warp_memory.get(loc + 1);
    u256_from_felts(low, high)
}

#[implicit(warp_memory: WarpMemory)]
fn wm_write_256(loc: felt252, value: u256) -> u256 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    warp_memory.insert(loc, u128_to_felt252(value.low));
    warp_memory.insert(loc + 1, u128_to_felt252(value.high));
    value
}

// -----------------Arrays-----------------

#[implicit(warp_memory: WarpMemory)]
fn wm_index_dyn(arrayLoc: felt252, index: u256, width: u256) -> felt252 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    // Get the length of the array and check that the index is within bounds
    assert(index < wm_dyn_array_length(arrayLoc), 'Index out of bound');

    // Calculate the location of the element
    let offset: u256 = index * width;
    let element_zero_ptr: u256 = u256_from_felt252(arrayLoc + 2);
    let loc = u256_to_felt252_safe(element_zero_ptr + offset);

    loc
}

#[implicit(warp_memory: WarpMemory)]
fn wm_new(len: u256, elemWidth: u256) -> felt252 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    // Calculate space needed for array elements
    let feltLength = len * elemWidth;

    // Add space required to include the length member
    let feltLength = feltLength + u256_from_felt252(2);

    let empty_memory_start = wm_alloc(feltLength);
    wm_write_256(empty_memory_start, len);
    empty_memory_start
}

#[implicit(warp_memory: WarpMemory)]
fn wm_dyn_array_length(arrayLoc: felt252) -> u256 {
    // TODO Clean this warp_memory initialization once plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 
    
    wm_read_256(arrayLoc)
}

// -----------------Structs-----------------


// -----------------Helper functions-----------------


// Moves the free-memory pointer to allocate the given number of cells, and returns the index
// of the start of the allocated space
#[implicit(warp_memory: WarpMemory)]
fn wm_alloc(space: u256) -> felt252 {
    // TODO Clean this warp_memory initialization once warp-memory plugin is supported
    let mut warp_memory: WarpMemory = WarpMemoryImpl::initialize(); 

    // Get current end pointer
    let freeCell = warp_memory.pointer;

    // Widen to u256 for safe calculation and because array lengths are u256
    let freeCell256 = u256_from_felt252(freeCell);
    let newFreeCell256 = freeCell256 + space;

    warp_memory.pointer = u256_to_felt252_safe(newFreeCell256);
    freeCell
}

