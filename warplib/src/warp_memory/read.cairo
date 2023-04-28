use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryReadTrait {
    fn read_felt(ref self: WarpMemory, index: felt252) -> felt252;
    fn read_u256(ref self: WarpMemory, index: felt252) -> u256;
}

impl WarpMemoryReadImpl of WarpMemoryReadTrait {
    fn read_felt(ref self: WarpMemory, index: felt252) -> felt252 {
        self.read(index)
    }

    fn read_u256(ref self: WarpMemory, index: felt252) -> u256 {
        let low = self.read(index);
        let high = self.read(index + 1);
        u256{low, high}
    }
}
