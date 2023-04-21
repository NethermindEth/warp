use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;

trait WarpMemoryArraysTrait {
    /// reads the pointer of an array. If it does not exists, it creates a new one
    fn read_id(ref self: WarpMemory, location: felt252, size: felt252) -> felt252;

    /// Given the length and the felt size of an element, allocates the space
    /// in memory and returns a pointer to it
    fn new_dynamic_array(ref self: WarpMemory, len: felt252, elem_width: felt252) -> felt252;

    /// Given a pointer to a dynamic array, the index you want to access from it
    /// and the size of the element in such array, returns a pointer to the element
    fn index_dyn(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252) -> felt252;

    /// Given a pointer to a static array, the index you want to access from it,
    /// the size of the elements in the array and the it's length,  returns a pointer
    /// to the element
    fn index_static(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252, length: felt252) -> felt252;

    /// Given the pointer to a dynamic array, it returns it's length
    fn lenght_dyn(ref self: WarpMemory, array_ptr: felt252) -> felt252;
}

impl WarpMemoryArraysImpl of WarpMemoryArraysTrait {
    fn read_id(ref self: WarpMemory, location: felt252, size: felt252) -> felt252{
        // Get the id at the location
        let id = self.read(location);
        if id != 0 {
            return id;
        }

        // If no id was found create a new one
        let id = self.alloc(size);
        self.unsafe_write(location, id);
        id
    }

    fn new_dynamic_array(ref self: WarpMemory, len: felt252, elem_width: felt252) -> felt252 {
        // The max space needed for the array in memory
        // plus one to store the length
        let max_size = len * elem_width + 1;

        let array_ptr = self.alloc(max_size);
        self.unsafe_write(array_ptr, len);
        array_ptr
    }

    fn index_dyn(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252) -> felt252 {
        let length = self.read(array_ptr);
        if index >= length {
            panic('Index out of range');
        } 

        let index_location = array_ptr + 1 + index * elem_width;
        self.read(index_location)
    }

    fn index_static(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252, length: felt252) -> felt252 {
        if index >= length {
            panic('Index out of range');
        } 

        let index_location = array_ptr + index * elem_width;
        self.read(index_location) 
    }

    fn lenght_dyn(ref self: WarpMemory, array_ptr: felt252) -> felt252 {
        self.read(array_ptr)
    }
}
