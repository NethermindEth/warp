import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, IntxIntFunction, WarplibFunctionInfo } from '../../utils';

export function mod_signed(): WarplibFunctionInfo {
  return {
    fileName: 'mod_signed',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_div_rem',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.maths.int_conversions import ${mapRange(
        31,
        (n) => `warp_int${8 * n + 8}_to_int256`,
      ).join(', ')}, ${mapRange(31, (n) => `warp_int256_to_int${8 * n + 8}`).join(', ')}`,
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_mod_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){',
          `    if (rhs.high == 0 and rhs.low == 0){`,
          `        with_attr error_message("Modulo by zero error"){`,
          `           assert 1 = 0;`,
          `        }`,
          `    }`,
          '    let (_, res : Uint256) = uint256_signed_div_rem(lhs, rhs);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        return [
          `func warp_mod_signed${width}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){`,
          `    alloc_locals;`,
          `    if (rhs == 0){`,
          `        with_attr error_message("Modulo by zero error"){`,
          `            assert 1 = 0;`,
          `        }`,
          `    }`,
          `    let (local lhs_256) = warp_int${width}_to_int256(lhs);`,
          `    let (rhs_256) = warp_int${width}_to_int256(rhs);`,
          '    let (_, res256) = uint256_signed_div_rem(lhs_256, rhs_256);',
          `    let (truncated) = warp_int256_to_int${width}(res256);`,
          `    return (truncated,);`,
          '}',
        ].join('\n');
      }
    }),
  };
}

export function functionaliseMod(node: BinaryOperation, ast: AST): void {
  IntxIntFunction(node, 'mod', 'signedOrWide', true, false, ast);
}
