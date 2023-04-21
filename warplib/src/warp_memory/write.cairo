use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryWriteTrait {
    fn write_felt(ref self: WarpMemory, index: felt252, value: felt252);
}

impl WarpMemoryWriteImpl of WarpMemoryWriteTrait {
    fn write_felt(ref self: WarpMemory, index: felt252 , value: felt252) {
        self.write(index, value)
    }
}
