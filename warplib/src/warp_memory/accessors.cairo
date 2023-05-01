use array::Array;
use array::ArrayTrait;
use serde::Serde;
use option::OptionTrait;
use integer::u256_from_felt252;
use integer::u32_to_felt252;


trait WarpMemoryAccesssorTrait {
    fn store<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, position: felt252, value: T);
    fn retrieve<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> T;
    fn create<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(ref self: WarpMemory, value: T);
}

trait WarpMemoryMultiCellAccessorTrait {
    fn write_multiple(ref self: WarpMemory, position: felt252, ref value: Array::<felt252>);
    fn read_multiple(ref self: WarpMemory, start_pos: felt252, end_pos: felt252) -> Array::<felt252>;
}

trait WarpMemoryCellAccessorTrait {
    fn initialize() -> WarpMemory;

    fn unsafe_write(ref self: WarpMemory, position: felt252, value: felt252);
    fn write(ref self: WarpMemory, position: felt252, value: felt252);

    fn unsafe_read(ref self: WarpMemory, position: felt252) -> felt252;
    fn read(ref self: WarpMemory, position: felt252) -> felt252;

    /// Given a certain size, it allocates the space for writing
    fn unsafe_alloc(ref self: WarpMemory, size: felt252) -> felt252;
    fn alloc(ref self: WarpMemory, size: felt252) -> felt252;
}


impl WarpMemoryCellAccessorImpl of WarpMemoryCellAccessorTrait {
    fn initialize() -> WarpMemory {
        return WarpMemory {memory: Felt252DictTrait::new(), pointer: 0};
    }

    fn unsafe_write(ref self: WarpMemory, position: felt252, value: felt252){
        self.memory.insert(position, value);
    }

    fn write(ref self: WarpMemory, position: felt252, value: felt252){
        let position_256 = u256_from_felt252(position);
        let pointer_256 = u256_from_felt252(self.pointer);
        if position_256 >= pointer_256 {
           panic_with_felt252('Writing on unreserved position');
        }
        self.memory.insert(position, value);
    }

    fn unsafe_read(ref self: WarpMemory, position: felt252) -> felt252 {
        self.memory.get(position)
    }

    fn read(ref self: WarpMemory, position: felt252) -> felt252 {
        let position_256 = u256_from_felt252(position);
        let pointer_256 = u256_from_felt252(self.pointer);
        if position_256 >= pointer_256 {
            panic_with_felt252('Reading on unreserved position');
        }
        self.memory.get(position)
    }

    fn unsafe_alloc(ref self: WarpMemory, size: felt252) -> felt252 {
        let reserved_pointer = self.pointer;
        self.pointer += size;
        
        reserved_pointer
    }
    fn alloc(ref self: WarpMemory, size: felt252) -> felt252 {
        let pointer_256 = u256_from_felt252(self.pointer);
        let size_256 = u256_from_felt252(size);

        let MAX_FELT_256: u256 = u256_from_felt252(-1);
        if (pointer_256 + size_256 > MAX_FELT_256){
            panic_with_felt252('Maximum memory size exceded');
        }

        let reserved_pointer= self.pointer;
        self.pointer += size;
        reserved_pointer
    }
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