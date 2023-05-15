use integer::u128_to_felt252;
use integer::u256_from_felt252;
use warplib::conversions::integer_conversions::u256_from_felts;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> u256;
    fn bytes_to_fixed_bytesN(ref self: WarpMemory, bytes_loc: felt252, width: felt252) -> felt252 ;
}

impl WarpMemoryBytesImpl of WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> u256 {
        let data_len = self.read(location);
        
        let data_len_u256 = u256_from_felt252(data_len);
        let u256_literal_16 = u256{low: 16, high: 0};
        let u256_literal_32 = u256{low: 32, high: 0};
        if data_len_u256 >= u256_literal_16 {
            let low_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, 16, 0);
            if data_len_u256 >= u256_literal_32 {
                let high_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, 16, 0);
                return u256_from_felts(low_felt, high_felt); 
            } else {
                let high_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, data_len - 16, 0);
                return u256_from_felts(low_felt, high_felt); 
            }
        } else {
            let low_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, data_len, 0);
            return u256_from_felts(low_felt, 0);
        }
    }

    // TODO This function will convert to fixed but store it in a felt, so will only be saved the last 31 bytes. Is this the approach we want??
    fn bytes_to_fixed_bytesN(ref self: WarpMemory, bytes_loc: felt252, width: felt252) -> felt252 {
        let data_len = self.read(bytes_loc);
        _bytes_to_fixed_recursive(ref self, bytes_loc + 1, width, data_len, 0)
    }
}

fn _bytes_to_fixed_recursive(ref memory: WarpMemory, bytes_data_loc: felt252, target_width: felt252, data_len: felt252, representation: felt252) -> felt252 {
    if target_width == 0 {
        return representation;
    }
    if data_len == 0 {
        return _bytes_to_fixed_recursive(ref memory, bytes_data_loc + 1, target_width - 1, data_len, 256 * representation);
    } else {
        let byte = memory.read(bytes_data_loc);
        return _bytes_to_fixed_recursive(ref memory, bytes_data_loc + 1, target_width - 1, data_len - 1, 256 * representation + byte);
    }
}
