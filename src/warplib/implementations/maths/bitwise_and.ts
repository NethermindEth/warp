import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { IntxIntFunction, forAllWidths, generateFile } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function bitwise_and(): void {
  generateFile(
    'bitwise_and',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_and',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_bitwise_and256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `    lhs : Uint256, rhs : Uint256`,
          `) -> (res : Uint256):`,
          `    return uint256_and(lhs, rhs)`,
          `end`,
        ];
      } else {
        return [
          `func warp_bitwise_and${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Uint${width}, rhs : Uint${width}) -> (res : Uint${width}):`,
          `    let (res) = bitwise_and(lhs.value, rhs.value)`,
          `    return (Uint${width}(value=res))`,
          `end`,
        ];
      }
    }),
  );
}

export function bitwise_and_signed(): void {
  generateFile(
    'bitwise_and_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_and',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_bitwise_and_signed256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `    lhs : Int256, rhs : Int256`,
          `) -> (res : Int256):`,
          `    let (res:Uint256) = uint256_and(lhs.value, rhs.value)`,
          `    return (Int256(value=res))`,
          `end`,
        ];
      } else {
        return [
          `func warp_bitwise_and_signed${width}{bitwise_ptr : BitwiseBuiltin*}(lhs : Int${width}, rhs : Int${width}) -> (res : Int${width}):`,
          `    let (res) = bitwise_and(lhs.value, rhs.value)`,
          `    return (Int${width}(value=res))`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseBitwiseAnd(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (width: number): Implicits[] => {
    if (width === 256) return ['range_check_ptr', 'bitwise_ptr'];
    else return ['bitwise_ptr'];
  };
  IntxIntFunction(node, 'bitwise_and', 'always', true, false, implicitsFn, ast);
}
