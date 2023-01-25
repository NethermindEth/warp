import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, Comparison, WarplibFunctionInfo } from '../../utils';

export function ge_signed(): WarplibFunctionInfo {
  return {
    fileName: 'ge_signed',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_signed_le',
      `from warplib.maths.lt_signed import ${mapRange(31, (n) => `warp_le_signed${8 * n + 8}`).join(
        ', ',
      )}`,
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_ge_signed256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt){',
          '     let (res) =  uint256_signed_le(rhs, lhs);',
          '     return (res,);',
          '}',
        ];
      } else {
        return [
          `func warp_ge_signed${width}{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(`,
          '        lhs : felt, rhs : felt) -> (res : felt){',
          `    let (res) = warp_le_signed${width}(rhs, lhs);`,
          `    return (res,);`,
          '}',
        ];
      }
    }),
  };
}

export function functionaliseGe(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean, signed: boolean): Implicits[] => {
    if (wide || !signed) return ['range_check_ptr'];
    else return ['range_check_ptr', 'bitwise_ptr'];
  };
  Comparison(node, 'ge', 'signedOrWide', true, implicitsFn, ast);
}
