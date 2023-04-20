use dict::Felt252Dict;
use dict::Felt252DictTrait;

mod read;
use read::WarpMemoryReadTrait;

mod write;
use write::WarpMemoryWriteTrait;

mod arrays;
use arrays::WarpMemoryArraysTrait;

mod bytes:
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
    fn insert(ref self: WarpMemory, index: felt252, value: felt252);
    fn append(ref self: WarpMemory, value: felt252);
    fn read(ref self: WarpMemory, index: felt252) -> felt252;
}


impl WarpMemoryImpl of WarpMemoryTrait {
    fn initialize() -> WarpMemory {
        return WarpMemory {memory: Felt252DictTrait::new(), pointer: 0};
    }

    fn insert(ref self: WarpMemory, index: felt252, value: felt252) {
        self.memory.insert(index, value);
        self.pointer += 1;
    }

    fn append(ref self: WarpMemory, value: felt252) {
        self.memory.insert(self.pointer, value);
        self.pointer += 1;
    }

    fn read(ref self: WarpMemory, index: felt252) -> felt252 {
        self.memory.get(index)
    }
}
