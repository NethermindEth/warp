use dict::Felt252Dict;
use dict::Felt252DictTrait;
use integer::u256_from_felt252;

mod arrays;
use arrays::WarpMemoryArraysTrait;

mod bytes;
use bytes::WarpMemoryBytesTrait;

mod accessors;
use accessors::WarpMemoryAccessorTrait;
use accessors::WarpMemoryMultiCellAccessorTrait;


struct WarpMemory {
    free_space_pointer: felt252,
    memory: Felt252Dict::<felt252>
}

impl DestructWarpMemory of Destruct::<WarpMemory> {
    fn destruct(self: WarpMemory) nopanic {
        self.memory.squash();
    }
}


trait WarpMemoryTrait {
    fn initialize() -> WarpMemory;

    fn unsafe_write(ref self: WarpMemory, position: felt252, value: felt252);
    fn write(ref self: WarpMemory, position: felt252, value: felt252);

    fn unsafe_read(ref self: WarpMemory, position: felt252) -> felt252;
    fn read(ref self: WarpMemory, position: felt252) -> felt252;

    // Given a certain size, it allocates the space for writing
    fn unsafe_alloc(ref self: WarpMemory, size: felt252) -> felt252;
    fn alloc(ref self: WarpMemory, size: felt252) -> felt252;
}


impl WarpMemoryImpl of WarpMemoryTrait {
    fn initialize() -> WarpMemory {
        return WarpMemory {memory: Felt252DictTrait::new(), free_space_pointer: 0};
    }

    fn unsafe_write(ref self: WarpMemory, position: felt252, value: felt252){
        self.memory.insert(position, value);
    }

    fn write(ref self: WarpMemory, position: felt252, value: felt252){
        let position_256 = u256_from_felt252(position);
        let pointer_256 = u256_from_felt252(self.free_space_pointer);
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
        let pointer_256 = u256_from_felt252(self.free_space_pointer);
        if position_256 >= pointer_256 {
            panic_with_felt252('Reading on unreserved position');
        }
        self.memory.get(position)
    }

    fn unsafe_alloc(ref self: WarpMemory, size: felt252) -> felt252 {
        let reserved_pointer = self.free_space_pointer;
        self.free_space_pointer += size;
        
        reserved_pointer
    }

    fn alloc(ref self: WarpMemory, size: felt252) -> felt252 {
        let pointer_256 = u256_from_felt252(self.free_space_pointer);
        let size_256 = u256_from_felt252(size);

        let MAX_FELT_256: u256 = u256_from_felt252(-1);
        if (pointer_256 + size_256 > MAX_FELT_256){
            panic_with_felt252('Maximum memory size exceded');
        }

        let reserved_pointer = self.free_space_pointer;
        self.free_space_pointer += size;
        reserved_pointer
    }
}
