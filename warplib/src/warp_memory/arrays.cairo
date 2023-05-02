use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;
use integer::u256_from_felt252;
use integer::u128_try_from_felt252;
use integer::Into;
use option::OptionTrait;

trait WarpMemoryArraysTrait {
    /// Reads the pointer of an array. If it does not exist, it creates a new one
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
    fn length_dyn(ref self: WarpMemory, array_ptr: felt252) -> felt252;
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
        let len_256 = u256_from_felt252(len);
        let elem_width_256 = u256{low: u128_try_from_felt252(elem_width).unwrap(), high: 0_u128};
        let one_256 = u256{low: 1_u128, high: 0_u128};

        let max_size_256 = len_256 * elem_width_256 + one_256;

        let MAX_FELT_256 = u256_from_felt252(-1);
        if max_size_256 > MAX_FELT_256 {
           panic_with_felt252('Overflow in new_dynamic_array');
        }

        let max_size: felt252 =  len * elem_width + 1;

        let array_ptr = self.alloc(max_size);
        self.unsafe_write(array_ptr, len);
        array_ptr
    }

    fn index_dyn(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252) -> felt252 {
        let length = self.read(array_ptr);

        let index_256 = u256_from_felt252(index);
        let length_256 = u256_from_felt252(length);
        if index_256 >= length_256 {
            panic_with_felt252('Index out of range');
        } 

        let index_location = array_ptr + 1 + index * elem_width;
        self.read(index_location)
    }

    fn index_static(ref self: WarpMemory, array_ptr: felt252, index: felt252, elem_width: felt252, length: felt252) -> felt252 {
        let index_256 = u256_from_felt252(index);
        let length_256 = u256_from_felt252(length);
        if index_256 >= length_256 {
             panic_with_felt252('Index out of range');
        } 

        let index_location = array_ptr + index * elem_width;
        self.read(index_location) 
    }

    fn length_dyn(ref self: WarpMemory, array_ptr: felt252) -> felt252 {
        self.read(array_ptr)
    }
}
