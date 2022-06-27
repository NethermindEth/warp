import { generalizeType, getNodeType, IntType, UnaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { bound, forAllWidths, generateFile, IntFunction, mask } from '../../utils';
import { mapRange } from '../../../utils/utils';

// This satisfies the solidity convention of -type(intX).min = type(intX).min
export function negate(): void {
  generateFile(
    'negate',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_neg',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_negate256{range_check_ptr}(op : Int256) -> (res : Int256):',
          '    let (res : Uint256) = uint256_neg(op.value)',
          `    return (Int256(value=res))`,
          'end',
          'func warp_unegate256{range_check_ptr}(op : Uint256) -> (res : Uint256):',
          '    return uint256_neg(op)',
          'end',
        ];
      } else {
        // Could also have if op == 0: 0 else limit-op
        return [
          `func warp_negate${width}{bitwise_ptr : BitwiseBuiltin*}(op : Int${width}) -> (res : Int${width}):`,
          `    let raw_res = ${bound(width)} - op.value`,
          `    let (trunc_res) =  bitwise_and(raw_res, ${mask(width)})`,
          `    return (Int${width}(value=trunc_res))`,
          `end`,
          `func warp_unegate${width}{bitwise_ptr : BitwiseBuiltin*}(op : Uint${width}) -> (res : Uint${width}):`,
          `    let raw_res = ${bound(width)} - op.value`,
          `    let (trunc_res) =  bitwise_and(raw_res, ${mask(width)})`,
          `    return (Uint${width}(value=trunc_res))`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseNegate(node: UnaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean): Implicits[] => {
    if (wide) return ['range_check_ptr'];
    else return ['bitwise_ptr'];
  };
  const fromType = generalizeType(getNodeType(node.vSubExpression, ast.compilerVersion))[0];
  IntFunction(
    node,
    node.vSubExpression,
    fromType instanceof IntType && fromType.signed ? 'negate' : 'unegate',
    'negate',
    implicitsFn,
    ast,
  );
}
