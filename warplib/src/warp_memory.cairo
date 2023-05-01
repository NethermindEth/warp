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

mod accessors;
use accessors::WarpMemoryCellAccessor;
use accessors::WarpMemoryAccesssor;


struct WarpMemory {
    pointer: felt252,
    memory: Felt252Dict::<felt252>
}

impl DestructWarpMemory of Destruct::<WarpMemory> {
    fn destruct(self: WarpMemory) nopanic {
        self.memory.squash();
    }
}
