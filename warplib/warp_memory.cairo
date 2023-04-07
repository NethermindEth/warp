use dict::Felt252Dict;
use dict::Felt252DictTrait;


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
}
