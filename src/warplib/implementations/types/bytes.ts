import endent from 'endent';
import {
  forAllWidths,
  necessary_width_to_store_nlen_bytes,
  WarplibFunctionInfo,
} from '../../utils';

export function fixed_bytes_types(): WarplibFunctionInfo {
  const fixed_bytes_trait = endent`
    trait FixedBytesTrait<T> {
      fn atIndex(self: T, index: u8) -> bytes1;
      fn length(self: T) -> u8;
      // Comparison
      fn less_or_equal_comparison(self: T, other: T) -> bool; // a <= b
      fn less_comparison(self: T, other: T) -> bool; // a < b
      fn equal_comparison(self: T, other: T) -> bool; // a == b
      fn distinct_comparison(self: T, other: T) -> bool; // a != b
      fn greater_or_equal_comparison(self: T, other: T) -> bool; // a >= b
      fn greater_comparison(self: T, other: T) -> bool; // a > b
      // Bitwise
      // TODO: Bitwise is not natively supported for all uN types. We can convert them into the ones that
      // implement the operation and go back to the original type 
      fn and_bitwise(self: T, other: T) -> T; // a & b
      fn or_bitwise(self: T, other: T) -> T; // a | b
      fn exclusive_or_bitwise(self: T, other: T) -> T; // a ^ b
      // Bitwise negation is not currently supported
      // Shift operators are not currently supported
    }
  `;

  const fixed_bytes_types = forAllWidths((width) => {
    const length = width / 8;
    const max_width = necessary_width_to_store_nlen_bytes(length);
    return endent`
      #[derive(Copy, Drop)]
      struct bytes${length} {
        value: u${max_width},
      }

      impl FixedBytes${length}Impl of FixedBytesTrait<bytes${length}>{
        fn atIndex(self: bytes${length}, index: u8) -> bytes1 {
          assert(index < self.length(), 'Index out of range');

          ${
            max_width === 256
              ? endent`
                let value_u256 = self.value;
              `
              : endent`
                let value_felt252 = u${max_width}_to_felt252(self.value);
                let value_u256 = u256_from_felt252(value_felt252);
              `
          }
          ${
            length > 16
              ? endent`
                let mut value_shifted = 0_u128;
                if index < 16_u8 {
                  value_shifted = value_u256.high / pow2_n(u8_to_felt252(self.length() - 17_u8 - index) * 8);
                } else {
                  value_shifted = value_u256.low / pow2_n(u8_to_felt252(self.length() - 1_u8 - index) * 8);
                }
              `
              : endent`
                let value_shifted = value_u256.low / pow2_n(u8_to_felt252(self.length() - 1_u8 - index) * 8);
              `
          }
          let value_at_index_u128 = value_shifted & 0xFF_u128;

          let value_at_index_felt252 = u128_to_felt252(value_at_index_u128);
          let value_at_index_u8 = u8_try_from_felt252(value_at_index_felt252).unwrap();

          bytes1{ value: value_at_index_u8}
        }
        fn length(self: bytes${length}) -> u8 {
          ${length}_u8
        }
        // Comparison
        fn less_or_equal_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value <= other.value
        } 
        fn less_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value < other.value
        }
        fn equal_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value == other.value
        }
        fn distinct_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value != other.value
        }
        fn greater_or_equal_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value >= other.value
        }
        fn greater_comparison(self: bytes${length}, other: bytes${length}) -> bool {
          self.value > other.value
        }
        // Bitwise 
        fn and_bitwise(self: bytes${length}, other: bytes${length}) -> bytes${length} {
          ${body_for_bitwise_operations(max_width, length, '&')}
        }
        fn or_bitwise(self: bytes${length}, other: bytes${length}) -> bytes${length} {
          ${body_for_bitwise_operations(max_width, length, '|')}
        }
        fn exclusive_or_bitwise(self: bytes${length}, other: bytes${length}) -> bytes${length} {
          ${body_for_bitwise_operations(max_width, length, '^')}
        }
        // Bitwise negation is not currently supported
        // Shift operators are not currently supported
      }
      `;
  }).join(`\n\n`);

  return {
    fileName: 'fixed_bytes',
    imports: [
      'use integer::u8_to_felt252;',
      'use integer::u16_to_felt252;',
      'use integer::u32_to_felt252;',
      'use integer::u64_to_felt252;',
      'use integer::u128_to_felt252;',
      'use integer::u8_try_from_felt252;',
      'use integer::u16_try_from_felt252;',
      'use integer::u32_try_from_felt252;',
      'use integer::u64_try_from_felt252;',
      'use integer::u128_try_from_felt252;',
      'use integer::u256_from_felt252;',
      'use option::OptionTrait;',
      'use warplib::maths::pow2::pow2_n;',
    ],
    functions: [fixed_bytes_trait, fixed_bytes_types],
  };
}

function body_for_bitwise_operations(max_width: number, length: number, operator: string) {
  return max_width >= 128 // uN types lower than 128 bits don't have an implementation for bitwise operations
    ? `bytes${length}{ value: self.value ${operator} other.value }`
    : endent`
      let self_value_felt252 = u${max_width}_to_felt252(self.value);
      let other_value_felt252 = u${max_width}_to_felt252(other.value);
      let self_value_u128 = u128_try_from_felt252(self_value_felt252).unwrap();
      let other_value_u128 = u128_try_from_felt252(other_value_felt252).unwrap();
      let result_u128 = self_value_u128 ${operator} other_value_u128;
      let result_felt252 = u128_to_felt252(result_u128);
      bytes${length}{ value: u${max_width}_try_from_felt252(result_felt252).unwrap() }
    `;
}
