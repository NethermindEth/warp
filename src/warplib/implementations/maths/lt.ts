import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, Comparison, WarplibFunctionInfo } from '../../utils';

export function lt_signed(): WarplibFunctionInfo {
  return {
    fileName: 'lt_signed',
    imports: [
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_lt',
      'from warplib.maths.utils import felt_to_uint256',
      `from warplib.maths.le_signed import ${mapRange(31, (n) => `warp_le_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_lt_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){',
          '    let (res) = uint256_signed_lt(lhs, rhs);',
          '    return (res,);',
          '}',
        ];
      } else {
        return [
          `func warp_lt_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          '        lhs : felt, rhs : felt) -> (res : felt){',
          '    if (lhs == rhs){',
          '        return (0,);',
          '    }',
          `    let (res) = warp_le_signed${width}(lhs, rhs);`,
          `    return (res,);`,
          '}',
        ];
      }
    }),
  };
}

export function functionaliseLt(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (!wide && signed) return ['range_check_ptr', 'bitwise_ptr'];
    else return ['range_check_ptr'];
  };

  Comparison(node, 'lt', 'signedOrWide', true, implicitsFn, ast);
}
