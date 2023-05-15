import endent from 'endent';
import { TranspileFailedError } from '../../../export';
import { forAllWidths, WarplibFunctionInfo } from '../../utils';

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
      fn and_bitwise(self: T, other: T) -> bool; // a & b
      fn or_bitwise(self: T, other: T) -> bool; // a | b
      fn exclusive_or_bitwise(self: T, other: T) -> bool; // a ^ b
      // Bitwise negation is not currently supported
      // Shift operators are not currently supported
    }
  `;

  const fixed_bytes_types = forAllWidths((width) => {
    const length = width / 8;
    const max_width = width_to_store_nlen_bytes(length);
    return endent`
      #[derive(Copy, Drop)]
      struct bytes${length} {
        value: u${max_width},
      }

      impl Bytes${length}Impl of BytesTrait<bytes${length}>{
        fn atIndex(self: bytes${length}, index: u8) -> bytes1 {
          assert(index < self.length(), 'Index out of range');
          //let mask = 0xFF_u${max_width};
          //let bits_wanted = mask * 0x10_u${max_width} * U8IntoU16::into(index);
          TODO
          bytes1{ value: 0_u8 }
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
          bytes${length}{ value: self.value & other.value }
        }
        fn or_bitwise(self: bytes${length}, other: bytes${length}) -> bytes${length} {
          bytes${length}{ value: self.value | other.value }
        }
        fn exclusive_or_bitwise(self: bytes${length}, other: bytes${length}) -> bytes${length} {
          bytes${length}{ value: self.value ^ other.value }
        }
        // Bitwise negation is not currently supported
        // Shift operators are not currently supported
      }
      `;
  }).join(`\n\n`);

  return {
    fileName: 'fixed_bytes',
    imports: [
      'use integer::U8IntoU16;',
      'use integer::U8IntoU32;',
      'use integer::U8IntoU64;',
      'use integer::U8IntoU128;',
    ],
    functions: [fixed_bytes_trait, fixed_bytes_types],
  };
}

function width_to_store_nlen_bytes(length: number) {
  if (length == 1) {
    return 8;
  } else if (length == 2) {
    return 16;
  } else if (length <= 4) {
    return 32;
  } else if (length <= 8) {
    return 64;
  } else if (length <= 16) {
    return 128;
  } else if (length <= 32) {
    return 256;
  } else {
    throw new TranspileFailedError('Bytes length is too big for any uN variable');
  }
}
