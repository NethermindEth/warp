use integer::u128_to_felt252;
use integer::u256_from_felt252;
use warplib::integer::u256_from_felts;
use warplib::integer::u256_into_felt_unsafe;
use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

trait WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> u256;
    fn bytes_to_fixed_bytesN(self: WarpMemory, bytesLoc: felt252, width: felt252) -> felt252 ;
}

impl WarpMemoryBytesImpl of WarpMemoryBytesTrait{
    fn bytes_to_fixed_bytes32(self: WarpMemory, bytesLoc: felt252) -> u256 {
        // TODO Is this self call to read_felt enough, don't we need to import from WarpMemoryReadTrait??
        let data_len = self.read_u256(bytesLoc);
        
        // TODO With the former approach if the array was of x < 32 bytes it copied the fist 16 and fill the rest with 0's. 
        // I change that, was that behavior the one wanted? 
        let literal_16 = u256{low: 16, high: 0};
        let literal_32 = u256{low: 32, high: 0};
        if data_len >= literal_16 {
            let low_felt = self._bytes_to_fixed_recursive(bytesLoc + 2, 16, 16, 0);
            if data_len >= literal_32 {
                let high_felt = self._bytes_to_fixed_recursive(bytesLoc + 18, 16, 16, 0);
                return u256_from_felts(low_felt, high_felt); 
            } else {
                let amount_to_read = u128_to_felt252((data_len - literal_16).low);
                let high_felt = self._bytes_to_fixed_recursive(bytesLoc + 18, 16, amount_to_read, 0);
                return u256_from_felts(low_felt, high_felt); 
            }
        } else {
            let amount_to_read = u128_to_felt252(data_len.low);
            let low_felt = self._bytes_to_fixed_recursive(bytesLoc + 2, 16, amount_to_read, 0);
            return u256_from_felts(low_felt, 0);
        }
    }

    // TODO This function will convert to fixed but store it in a felt, so will only be saved the last 31 bytes. Is this the approach we want??
    fn bytes_to_fixed_bytesN(self: WarpMemory, bytesLoc: felt252, width: felt252) -> felt252 {
        let data_len = self.read_u256(bytesLoc);
        if data_len >= u256_from_felt252(width) {
            self._bytes_to_fixed_recursive(bytesLoc + 2, width, width, 0)
        } else {
            let data_len_felt = u256_into_felt_unsafe(data_len);
            self._bytes_to_fixed_recursive(bytesLoc + 2, width, data_len_felt, 0)
        }
    }

    fn _bytes_to_fixed_recursive(self: WarpMemory, bytesDataLoc: felt252, targetWidth: felt252, data_len: felt252, representation: felt252) -> felt252 {
        if targetWidth == 0 {
            return representation;
        }
        if data_len == 0 {
            return self._bytes_to_fixed_recursive(bytesDataLoc + 1, targetWidth - 1, data_len, 256 * representation);
        } else {
            // TODO Is this self call to read_felt enough, don't we need to import from WarpMemoryReadTrait??
            let byte = self.read_felt(bytesDataLoc);
            return self._bytes_to_fixed_recursive(bytesDataLoc + 1, targetWidth - 1, data_len - 1, 256 * representation + byte);
        }
    }
}