use array::Array;
use array::ArrayTrait;
use integer::u32_to_felt252;
use integer::u256_from_felt252;
use option::OptionTrait;
use serde::Serde;
use traits::Into;

use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;


trait WarpMemoryAccessorTrait {
    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, value: T);
    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, size: felt252) -> T;
    fn create<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T);
}

trait WarpMemoryMultiCellAccessorTrait {
    fn write_multiple(ref self: WarpMemory, position: felt252, ref value: Array::<felt252>);
    fn read_multiple(ref self: WarpMemory, position: felt252, size: felt252) -> Array::<felt252>;
}


impl WarpMemoryMultiCellAccessor of WarpMemoryMultiCellAccessorTrait {
    fn write_multiple(ref self: WarpMemory, mut position: felt252, ref value: Array::<felt252>) {
        let position_256 = u256_from_felt252(position);
        let len_256: u256 = u256_from_felt252(u32_to_felt252(value.len()));
        let final_location_256 = position_256 + len_256;

        let MAX_FELT_256 = u256_from_felt252(-1);
        if final_location_256 > MAX_FELT_256 {
            panic_with_felt252('Multiple writing overflow');
        }

        let pointer_256 = u256_from_felt252(self.free_space_pointer);
        if final_location_256 > pointer_256 {
            panic_with_felt252('MWriting on unreserved position')
        }

        loop {
            match gas::withdraw_gas() {
               Option::Some(_) => {},
               Option::None(_) => {
                    panic_with_felt252('Out of gas');
               }
            }

            if value.len() == 0 {
                break();
            }
            self.unsafe_write(position, value.pop_front().unwrap());
            position += 1;
        }
    }

    fn read_multiple(ref self: WarpMemory, position: felt252, size: felt252) -> Array::<felt252> {
        let start_256 = u256_from_felt252(position);
        let size_256 = u256_from_felt252(size);
        let final_location_256 = start_256 + size_256;

        let MAX_FELT_256 = u256_from_felt252(-1);
        if final_location_256 > MAX_FELT_256 {
            panic_with_felt252('Multiple reading overflow');
        }

        let pointer_256 = u256_from_felt252(self.free_space_pointer);
        if final_location_256 > pointer_256 {
            panic_with_felt252('MReading on unreserved position')
        }

        let mut index = position;
        let mut array: Array<felt252> = ArrayTrait::<felt252>::new();
        let final_location = position + size;
        loop {
            match gas::withdraw_gas() {
               Option::Some(_) => {},
               Option::None(_) => {
                    panic_with_felt252('Out of gas');
               }
            }

            if index == final_location {
                break();
            }
            array.append(self.unsafe_read(index));
            index += 1;
        };
        array
    }
}


impl WarpMemoryAccessor of WarpMemoryAccessorTrait {
    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, value: T) {
        let mut serialization_array: Array<felt252> = ArrayTrait::<felt252>::new();
        TSerde::serialize(@value, ref serialization_array);

        self.write_multiple(position, ref serialization_array);
    }

    fn create<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T) {
        let mut serialization_array: Array<felt252> = ArrayTrait::<felt252>::new();
        TSerde::serialize(@value, ref serialization_array);

        let position = self.alloc(serialization_array.len().into());
        self.write_multiple(position, ref serialization_array);
    }

    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, size: felt252) -> T {
        let serialization_array: Array<felt252> = self.read_multiple(position, size);
        let mut span = ArrayTrait::<felt252>::span(@serialization_array);
        let value = TSerde::deserialize(ref span);

        value.unwrap()
    }
}
