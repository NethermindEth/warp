import endent from 'endent';
import { BigNumber } from 'bignumber.js';
import { mapRange } from '../../../export';
import { msb, WarplibFunctionInfo } from '../../utils';

export function pow2_constants(): WarplibFunctionInfo {
  const pow2_values = mapRange(256, (n) => n).map((n) => {
    return endent`
      fn pow2_${n}() -> u256 {
        ${
          n < 128
            ? `u256{ low:${msb(n + 1)}_u128, high:0_u128 }`
            : `u256{ low:0_u128, high:${msb(n - 128 + 1)}_u128 }`
        }
      }
    `;
  });
  const pow2_dispatcher = endent`
    fn pow2_n(n: felt252) -> u256 {
        if n == 0 {
            return pow2_0();
        ${mapRange(255, (m) => m + 1)
          .map((n) => {
            return endent`
                } else if n == ${n} {
                    return pow2_${n}();
            `;
          })
          .join('\n')}
        } else {
            panic_with_felt252('Not pow2 stored for index');
        }
        u256{ low:0_u128, high:0_u128}
    }
  `;
  return {
    fileName: 'pow2',
    imports: [],
    functions: [pow2_dispatcher, ...pow2_values],
  };
}
