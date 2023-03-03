import assert from 'assert';
import {
  BinaryOperation,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../../utils/utils';
import { forAllWidths, getIntOrFixedByteBitWidth, WarplibFunctionInfo } from '../../utils';

// rhs is always unsigned, and signed and unsigned shl are the same
export function shl(): WarplibFunctionInfo {
  //Need to provide an implementation with 256bit rhs and <256bit lhs
  return {
    fileName: 'shl',
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_shl',
      'from warplib.maths.pow2 import pow2',
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          'func warp_shl256{range_check_ptr}(lhs : Uint256, rhs : felt) -> (result : Uint256){',
          '    let (high, low) = split_felt(rhs);',
          '    let (res) = uint256_shl(lhs, Uint256(low, high));',
          '    return (res,);',
          '}',
          'func warp_shl256_256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (result : Uint256){',
          '    let (res) = uint256_shl(lhs, rhs);',
          '    return (res,);',
          '}',
        ].join('\n');
      } else {
        return [
          `func warp_shl${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt, rhs : felt) -> (res : felt){`,
          `    // width <= rhs (shift amount) means result will be 0`,
          `    let large_shift = is_le_felt(${width}, rhs);`,
          `    if (large_shift == 1){`,
          `        return (0,);`,
          `    }else{`,
          `        let preserved_width = ${width} - rhs;`,
          `        let (preserved_bound) = pow2(preserved_width);`,
          `        let (lhs_truncated) = bitwise_and(lhs, preserved_bound - 1);`,
          `        let (multiplier) = pow2(rhs);`,
          `        return (lhs_truncated * multiplier,);`,
          `    }`,
          `}`,
          `func warp_shl${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
          `        lhs : felt, rhs : Uint256) -> (res : felt){`,
          `    if (rhs.high == 0){`,
          `        let (res) = warp_shl${width}(lhs, rhs.low);`,
          `        return (res,);`,
          `    }else{`,
          `        return (0,);`,
          `    }`,
          `}`,
        ].join('\n');
      }
    }),
  };
}

export function functionaliseShl(node: BinaryOperation, ast: AST): void {
  const lhsType = safeGetNodeType(node.vLeftExpression, ast.inference);
  const rhsType = safeGetNodeType(node.vRightExpression, ast.inference);
  const retType = safeGetNodeType(node, ast.inference);

  assert(
    lhsType instanceof IntType || lhsType instanceof FixedBytesType,
    `lhs of << ${printNode(node)} non-int type ${printTypeNode(lhsType)}`,
  );
  assert(
    rhsType instanceof IntType,
    `rhs of << ${printNode(node)} non-int type ${printTypeNode(rhsType)}`,
  );

  const lhsWidth = getIntOrFixedByteBitWidth(lhsType);

  const fullName = `warp_shl${lhsWidth}${rhsType.nBits === 256 ? '_256' : ''}`;

  const importedFunc = ast.registerImport(
    node,
    ['warplib', 'maths', 'shl'],
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
  );
  const call = new FunctionCall(
    ast.reserveId(),
    node.src,
    node.typeString,
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      `function (${node.vLeftExpression.typeString}, ${node.vRightExpression.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
}
