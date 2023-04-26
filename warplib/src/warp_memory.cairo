use dict::Felt252Dict;
use dict::Felt252DictTrait;
use array::Array;
use array::ArrayTrait;
use serde::Serde;


struct WarpMemory {
    pointer: felt252,
    memory: Felt252Dict::<felt252>
}

impl DestructWarpMemory of Destruct::<WarpMemory> {
    fn destruct(self: WarpMemory) nopanic {
        self.memory.squash();
    }
}


trait MemoryTrait {
    fn initialize() -> WarpMemory;
    fn insert(ref self: WarpMemory, position: felt252, value: felt252);
    fn append(ref self: WarpMemory, value: felt252);
    fn append_array(ref self: WarpMemory, ref value: Array::<felt252>);
    fn to_mem<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T);
    fn raw(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252>;
    fn from_mem<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T;
}


impl WarpMemoryImpl of MemoryTrait {
    fn initialize() -> WarpMemory {
        return WarpMemory {memory: Felt252DictTrait::new(), pointer: 0};
    }

    fn insert(ref self: WarpMemory, position: felt252, value: felt252) {
        self.memory.insert(position, value);
        self.pointer += 1;
    }

    fn append(ref self: WarpMemory, value: felt252) {
        self.insert(self.pointer, value);
    }

    fn store_raw_array(ref self: WarpMemory, ref value: Array::<felt252>) {
        loop {
            if value.len() == 0 {
                break();
            }
            self.append(value.pop_front().unwrap());
        }
    }

    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T) {
        let mut serialization_array: Array<felt252> = ArrayImpl::<felt252>::new();
        TSerde::serialize(ref serialization_array, value);
        self.store_raw_array(ref serialization_array);
    }

    fn retrieve_raw(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252> {
        let mut index = start_pos;
        let mut array: Array<felt252> = ArrayImpl::<felt252>::new();
        loop {
            if index == end_pos {
                break();
            }
            array.append(self.memory.get(index));
            index+=1;
        };
        array
    }

    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T {
        let serialization_array: Array<felt252> = self.retrieve_raw(start_pos, end_pos);
        let mut span = ArrayImpl::<felt252>::span(@serialization_array);
        let value = TSerde::deserialize(ref span);
        value.unwrap()
    }
}