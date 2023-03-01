import { UnaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { forAllWidths, IntFunction, mask, WarplibFunctionInfo } from '../../utils';

export function bitwise_not(): WarplibFunctionInfo {
  return {
    fileName: 'bitwise_not',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_xor',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_not',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_bitwise_not256{range_check_ptr}(op : Uint256) -> (res : Uint256){',
          '    let (res) = uint256_not(op);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        return [
          `func warp_bitwise_not${width}{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){`,
          `    let (res) = bitwise_xor(op, ${mask(width)});`,
          `    return (res,);`,
          '}',
        ].join('\n');
      }
    }),
  };
}

export function functionaliseBitwiseNot(node: UnaryOperation, ast: AST): void {
  IntFunction(node, node.vSubExpression, 'bitwise_not', 'bitwise_not', ast);
}
