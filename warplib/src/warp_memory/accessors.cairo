use array::Array;
use array::ArrayTrait;
use serde::Serde;
use option::OptionTrait;
use integer::u32_to_felt252;

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


impl WarpMemoryMultiCellAccessor of WarpMemoryMultiCellAccessorTrait{
    fn write_multiple(ref self: WarpMemory, position: felt252, ref value: Array::<felt252>) {
        loop {
            if value.len() == 0 {
                break();
            }
            self.write(position, value.pop_front().unwrap());
        }
    }

    fn read_multiple(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252> {
        let mut index = start_pos;
        let mut array: Array<felt252> = ArrayImpl::<felt252>::new();
        loop {
            if index == end_pos {
                break();
            }
            array.append(self.memory.get(index));
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

        let position = self.pointer;
        self.alloc(u32_to_felt252(serialization_array.len()));
        self.write_multiple(position, ref serialization_array);
    }

    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T {
        let serialization_array: Array<felt252> = self.read_multiple(start_pos, end_pos);
        let mut span = ArrayImpl::<felt252>::span(@serialization_array);
        let value = TSerde::deserialize(ref span);

        value.unwrap()
    }
}
