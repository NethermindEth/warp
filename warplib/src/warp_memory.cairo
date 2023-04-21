use dict::Felt252Dict;
use dict::Felt252DictTrait;

mod read;
use read::WarpMemoryReadTrait;

mod write;
use write::WarpMemoryWriteTrait;

mod arrays;
use arrays::WarpMemoryArraysTrait;

mod bytes;
use bytes::WarpMemoryBytesTrait;

struct WarpMemory {
    pointer: felt252,
    memory: Felt252Dict::<felt252>
}

impl DestructWarpMemory of Destruct::<WarpMemory> {
    fn destruct(self: WarpMemory) nopanic {
        self.memory.squash();
    }
}


trait WarpMemoryTrait {
    fn initialize() -> WarpMemory;
    fn unsafe_write(ref self: WarpMemory, index: felt252, value: felt252);
    fn write(ref self: WarpMemory, index: felt252, value: felt252);
    fn read(ref self: WarpMemory, index: felt252) -> felt252;

    /// Given a certain size, it allocates the space for writing
    fn alloc(ref self: WarpMemory, size: felt252) -> felt252;
}


impl WarpMemoryImpl of WarpMemoryTrait {
    fn initialize() -> WarpMemory {
        return WarpMemory {memory: Felt252DictTrait::new(), pointer: 0};
    }

    fn unsafe_write(ref self: WarpMemory, position: felt252, value: felt252){
        self.memory.insert(position, value);
    }

    fn write(ref self: WarpMemory, position: felt252, value: felt252){
        if position >= self.pointer {
            panic('Writing on unreserved position');
        }
        self.memory.insert(position, value);
    }

    fn read(ref self: WarpMemory, index: felt252) -> felt252 {
        self.memory.get(index)
    }

    fn alloc(ref self: WarpMemory, size: felt252) -> felt252 {
        let reserved_pointer = self.pointer;
        self.pointer += size;
        
        reserved_pointer
    }
}
