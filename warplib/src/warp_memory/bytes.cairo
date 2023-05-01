use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> u256;
}
