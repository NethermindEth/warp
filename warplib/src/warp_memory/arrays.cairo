use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;

trait WarpMemoryArraysTrait {
    /// reads the pointer of an array. If it does not exists, it creates a new one
    fn read_id(index: felt252, size: felt252);

    /// Given the length and the felt size of an element, allocates the space
    /// in memory and returns a pointer to it
    fn new_dynamic_array(len: felt252, elem_width: felt252) -> felt252;

    /// Given a pointer to a dynamic array, the index you want to access from it
    /// and the size of the element in such array, returns a pointer to the element
    fn index_dyn(array_ptr: felt252, index: felt252, elem_width: felt252) -> felt252;

    /// Given a pointer to a static array, the index you want to access from it,
    /// the size of the elements in the array and the it's length,  returns a pointer
    /// to the element
    fn index_static(array_ptr: felt252, index: felt252, elem_width: felt252, length: felt252) -> felt252;
}
