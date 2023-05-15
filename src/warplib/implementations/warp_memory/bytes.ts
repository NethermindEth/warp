import endent from 'endent';
import { forAllWidths, WarplibFunctionInfo } from '../../utils';

export function warp_memory_fixed_bytes(): WarplibFunctionInfo {
  const trait_def = endent`
    trait WarpMemoryBytesTrait{
      ${forAllWidths((width) => {
        const length = width / 8;
        return `fn bytes_to_fixed_bytes${length}(ref self: WarpMemory, location: felt252) -> bytes${length};`;
      }).join('\n')}
    }
    `;
  const recursive_converter = endent`
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
    }`;

  const trait_impl = endent`
    impl WarpMemoryBytesImpl of WarpMemoryBytesTrait{
      ${forAllWidths((width) => {
        const length = width / 8;
        if (length === 32) {
          return endent`
            fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> bytes32 {
              let data_len = self.read(location);
              
              let data_len_u256 = u256_from_felt252(data_len);
              let u256_literal_16 = u256{low: 16, high: 0};
              let u256_literal_32 = u256{low: 32, high: 0};
              if data_len_u256 >= u256_literal_16 {
                  let low_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, 16, 0);
                  if data_len_u256 >= u256_literal_32 {
                      let high_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, 16, 0);
                      return bytes32{ value: u256_from_felts(low_felt, high_felt) }; 
                  } else {
                      let high_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, data_len - 16, 0);
                      return bytes32{ value: u256_from_felts(low_felt, high_felt) }; 
                  }
              } else {
                  let low_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, data_len, 0);
                  return bytes32{ value: u256_from_felts(low_felt, 0) };
              }
            }
          `;
        }
        return endent`
          fn bytes_to_fixed_bytes${length}(ref self: WarpMemory, bytes_loc: felt252) -> bytes${length} {
            let data_len = self.read(bytes_loc);
            _bytes_to_fixed_recursive(ref self, bytes_loc + 1, ${length}, data_len, 0)
          }
        `;
      }).join('\n')}
    }
  `;

  return {
    fileName: 'bytes',
    imports: forAllWidths((width) => {
      const length = width / 8;
      return `use warplib::types::fixed_bytes::bytes${length}`;
    }),
    functions: [trait_def, recursive_converter, trait_impl],
  };
}
