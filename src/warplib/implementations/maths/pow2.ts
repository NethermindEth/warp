import endent from 'endent';
import { BigNumber } from 'bignumber.js';
import { mapRange } from '../../../export';
import { msb, WarplibFunctionInfo } from '../../utils';

export function pow2_constants(): WarplibFunctionInfo {
  const pow2_values = mapRange(128, (n) => n).map((n) => {
    return endent`
      fn pow2_${n}() -> u128 {
        ${msb(n + 1)}_u128
      }
    `;
  });
  const pow2_dispatcher = endent`
    fn pow2_n(n: felt252) -> u128 {
        if n == 0 {
            return pow2_0();
        ${mapRange(127, (m) => m + 1)
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
        0_u128
    }
  `;
  return {
    fileName: 'pow2',
    imports: [],
    functions: [pow2_dispatcher, ...pow2_values],
  };
}
