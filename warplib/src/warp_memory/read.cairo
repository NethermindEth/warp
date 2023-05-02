use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryReadTrait {
    fn read_felt(ref self: WarpMemory, index: felt252) -> felt252;
}

impl WarpMemoryReadImpl of WarpMemoryReadTrait {
    fn read_felt(ref self: WarpMemory, index: felt252) -> felt252 {
        self.read(index)
    }
}
