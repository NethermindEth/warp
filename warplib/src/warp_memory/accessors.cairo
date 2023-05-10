use array::Array;
use array::ArrayTrait;
use serde::Serde;
use option::OptionTrait;
use integer::u32_to_felt252;
use integer::u256_from_felt252;

use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;


trait WarpMemoryAccesssorTrait {
    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, value: T);
    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T;
    fn create<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T);
}

trait WarpMemoryMultiCellAccessorTrait {
    fn write_multiple(ref self: WarpMemory, position: felt252, ref value: Array::<felt252>);
    fn read_multiple(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252>;
}


impl WarpMemoryMultiCellAccessor of WarpMemoryMultiCellAccessorTrait {
    fn write_multiple(ref self: WarpMemory, mut position: felt252, ref value: Array::<felt252>) {
        let position_256 = u256_from_felt252(position);
        let len_256: u256 = u256_from_felt252(u32_to_felt252(value.len()));
        let final_location_256 = position_256 + len_256;

        let pointer_256 = u256_from_felt252(self.pointer);
        if final_location_256 > pointer_256 {
            panic_with_felt252('Writing on unreserved position')
        }

        let MAX_FELT_256 = u256_from_felt252(-1);
        if final_location_256 > MAX_FELT_256 {
            panic_with_felt252('Memory overflow');
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

    fn read_multiple(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252> {
        let start_256 = u256_from_felt252(start_pos);
        let end_256 = u256_from_felt252(end_pos);
        let final_location_256 = start_256 + end_256;

        let pointer_256 = u256_from_felt252(self.pointer);
        if final_location_256 > pointer_256 {
            panic_with_felt252('Reading on unreserved position')
        }

        let MAX_FELT_256 = u256_from_felt252(-1);
        if final_location_256 > MAX_FELT_256 {
            panic_with_felt252('Memory overflow');
        }

        let mut index = start_pos;
        let mut array: Array<felt252> = ArrayImpl::<felt252>::new();
        loop {
            match gas::withdraw_gas() {
               Option::Some(_) => {},
               Option::None(_) => {
                    panic_with_felt252('Out of gas');
               }
            }

            if index == end_pos {
                break();
            }
            array.append(self.read(index));
            index += 1;
        };
        array
    }
}


impl WarpMemoryAccesssor of WarpMemoryAccesssorTrait {
    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, value: T) {
        let mut serialization_array: Array<felt252> = ArrayImpl::<felt252>::new();
        TSerde::serialize(ref serialization_array, value);

        self.write_multiple(position, ref serialization_array);
    }

    fn create<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T) {
        let mut serialization_array: Array<felt252> = ArrayImpl::<felt252>::new();
        TSerde::serialize(ref serialization_array, value);

        let position = self.alloc(u32_to_felt252(serialization_array.len()));
        self.write_multiple(position, ref serialization_array);
    }

    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T {
        let serialization_array: Array<felt252> = self.read_multiple(start_pos, end_pos);
        let mut span = ArrayImpl::<felt252>::span(@serialization_array);
        let value = TSerde::deserialize(ref span);

        value.unwrap()
    }
}
