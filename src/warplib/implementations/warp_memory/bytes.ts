import endent from 'endent';
import {
  forAllWidths,
  necessary_width_to_store_nlen_bytes,
  WarplibFunctionInfo,
} from '../../utils';

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
      match gas::withdraw_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
             panic_with_felt252('Out of gas');
        }
      }
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
        const max_width = necessary_width_to_store_nlen_bytes(length);
        if (length === 32) {
          return endent`
            fn bytes_to_fixed_bytes32(ref self: WarpMemory, location: felt252) -> bytes32 {
              let data_len = self.read(location);
              let data_len_u256 = u256_from_felt252(data_len);
              let u256_literal_16 = u256{low: 16, high: 0};
              let u256_literal_32 = u256{low: 32, high: 0};

              // It will be stored right-padded: 0x<some_values>000...0
              if data_len_u256 >= u256_literal_16 {
                  let high_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, 16, 0);
                  if data_len_u256 >= u256_literal_32 {
                      let low_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, 16, 0);
                      return bytes32{ value: u256_from_felts(low_felt, high_felt) }; 
                  } else {
                      let low_felt = _bytes_to_fixed_recursive(ref self, location + 17, 16, data_len - 16, 0);
                      return bytes32{ value: u256_from_felts(low_felt, high_felt) }; 
                  }
              } else {
                  let high_felt = _bytes_to_fixed_recursive(ref self, location + 1, 16, data_len, 0);
                  return bytes32{ value: u256_from_felts(0, high_felt) };
              }
            }
          `;
        }
        return endent`
          fn bytes_to_fixed_bytes${length}(ref self: WarpMemory, bytes_loc: felt252) -> bytes${length} {
            let data_len = self.read(bytes_loc);
            let value_felt = _bytes_to_fixed_recursive(ref self, bytes_loc + 1, ${length}, data_len, 0);
            ${
              max_width === 256
                ? `bytes${length} { value: u256_from_felt252(value_felt) }`
                : `bytes${length} { value: u${max_width}_try_from_felt252(value_felt).unwrap() }`
            }
          }
        `;
      }).join('\n')}
    }
  `;

  return {
    fileName: 'bytes',
    imports: [
      'use integer::u128_to_felt252;',
      'use integer::u8_try_from_felt252;',
      'use integer::u16_try_from_felt252;',
      'use integer::u32_try_from_felt252;',
      'use integer::u64_try_from_felt252;',
      'use integer::u128_try_from_felt252;',
      'use integer::u256_from_felt252;',
      'use option::OptionTrait;',
      'use warplib::conversions::integer_conversions::u256_from_felts;',
      'use warplib::warp_memory::WarpMemory;',
      'use warplib::warp_memory::WarpMemoryTrait;',
      ...forAllWidths((width) => {
        const length = width / 8;
        return `use warplib::types::fixed_bytes::bytes${length};`;
      }),
    ],
    functions: [trait_def, recursive_converter, trait_impl],
  };
}
