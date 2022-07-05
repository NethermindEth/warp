import { generalizeType, getNodeType, IntType, UnaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { forAllWidths, generateFile, IntFunction, mask } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function bitwise_not(): void {
  generateFile(
    'bitwise_not',
    [
      'from starkware.cairo.common.bitwise import bitwise_xor',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_not',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_bitwise_not256{range_check_ptr}(op : Uint256) -> (res : Uint256):',
          '    let (res) = uint256_not(op)',
          '    return (res)',
          'end',
        ];
      } else {
        return [
          `func warp_bitwise_not${width}{bitwise_ptr : BitwiseBuiltin*}(op : Uint${width}) -> (res : Uint${width}):`,
          `    let (res) = bitwise_xor(op.value, ${mask(width)})`,
          `    return (Uint${width}(value=res))`,
          'end',
        ];
      }
    }),
  );
}

export function bitwise_not_signed(): void {
  generateFile(
    'bitwise_not_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_xor',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_not',
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_bitwise_not_signed256{range_check_ptr}(op : Int256) -> (res : Int256):',
          '    let (res) = uint256_not(op.value)',
          '    return (Int256(value=res))',
          'end',
        ];
      } else {
        return [
          `func warp_bitwise_not_signed${width}{bitwise_ptr : BitwiseBuiltin*}(op : Int${width}) -> (res : Int${width}):`,
          `    let (res) = bitwise_xor(op.value, ${mask(width)})`,
          `    return (Int${width}(value=res))`,
          'end',
        ];
      }
    }),
  );
}

export function functionaliseBitwiseNot(node: UnaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean): Implicits[] => {
    if (wide) return ['range_check_ptr'];
    else return ['bitwise_ptr'];
  };
  const fromType = generalizeType(getNodeType(node.vSubExpression, ast.compilerVersion))[0];
  const file_n_fn_name = `bitwise_not${
    fromType instanceof IntType && fromType.signed ? '_signed' : ''
  }`;
  IntFunction(node, node.vSubExpression, file_n_fn_name, file_n_fn_name, implicitsFn, ast);
}
