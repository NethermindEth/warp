use integer::u128_to_felt252;
use integer::u256_from_felt252;
use warplib::integer::u256_from_felts;
use warplib::integer::u256_into_felt_unsafe;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> u256;
    fn bytes_to_fixed_bytesN(self: WarpMemory, bytes_loc: felt252, width: felt252) -> felt252 ;
}

impl WarpMemoryBytesImpl of WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(self: WarpMemory, bytes_loc: felt252) -> u256 {
        // TODO Is this self call to read_felt enough, don't we need to import from WarpMemoryReadTrait??
        let data_len = self.read(bytes_loc);
        
        // TODO With the former approach if the array was of x < 32 bytes it copied the fist 16 and fill the rest with 0's. 
        // I change that, was that behavior the one wanted? 
        if data_len >= 16 {
            let low_felt = self._bytes_to_fixed_recursive(bytes_loc + 1, 16, 16, 0);
            if data_len >= 32 {
                let high_felt = self._bytes_to_fixed_recursive(bytes_loc + 17, 16, 16, 0);
                return u256_from_felts(low_felt, high_felt); 
            } else {
                let high_felt = self._bytes_to_fixed_recursive(bytes_loc + 17, 16, data_len - 16, 0);
                return u256_from_felts(low_felt, high_felt); 
            }
        } else {
            let low_felt = self._bytes_to_fixed_recursive(bytes_loc + 1, 16, data_len, 0);
            return u256_from_felts(low_felt, 0);
        }
    }

    // TODO This function will convert to fixed but store it in a felt, so will only be saved the last 31 bytes. Is this the approach we want??
    fn bytes_to_fixed_bytesN(self: WarpMemory, bytes_loc: felt252, width: felt252) -> felt252 {
        let data_len = self.read(bytes_loc);
        self._bytes_to_fixed_recursive(bytes_loc + 1, width, data_len, 0)
    }

    fn _bytes_to_fixed_recursive(self: WarpMemory, bytes_data_loc: felt252, target_width: felt252, data_len: felt252, representation: felt252) -> felt252 {
        if target_width == 0 {
            return representation;
        }
        if data_len == 0 {
            return self._bytes_to_fixed_recursive(bytes_data_loc + 1, target_width - 1, data_len, 256 * representation);
        } else {
            // TODO Is this self call to read_felt enough, don't we need to import from WarpMemoryReadTrait??
            let byte = self.read_felt(bytes_data_loc);
            return self._bytes_to_fixed_recursive(bytes_data_loc + 1, target_width - 1, data_len - 1, 256 * representation + byte);
        }
    }
}