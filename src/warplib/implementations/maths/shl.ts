import assert from 'assert';
import {
  BinaryOperation,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { createCairoFunctionStub } from '../../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../../utils/utils';
import { generateFile, forAllWidths, getIntOrFixedByteBitWidth } from '../../utils';
import { mapRange } from '../../../utils/utils';

// rhs is always unsigned, and signed and unsigned shl are the same
export function shl(): void {
  //Need to provide an implementation with 256bit rhs and <256bit lhs
  generateFile(
    'shl',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_shl',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      'from warplib.maths.pow2 import pow2',
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                'func warp_shl256_256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (result : Uint256):',
                '    let (res) = uint256_shl(lhs, rhs)',
                '    return (res)',
                'end',
              ];
            } else {
              return [
                `func warp_shl256_${rhsWidth}{range_check_ptr}(lhs : Uint256, rhs : Uint${rhsWidth}) -> (result : Uint256):`,
                '    let (high, low) = split_felt(rhs.value)',
                '    let (res) = uint256_shl(lhs, Uint256(low, high))',
                '    return (res)',
                'end',
              ];
            }
          }),
        ];
      } else {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shl${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Uint${width}, rhs : Uint256) -> (res : Uint${width}):`,
                `    if rhs.high == 0:`,
                `        let (res) = warp_shl${width}_${width}(lhs, Uint${width}(rhs.low))`,
                `        return (res)`,
                `    else:`,
                `        return (Uint${width}(value=0))`,
                `    end`,
                `end`,
              ];
            } else {
              return [
                `func warp_shl${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Uint${width}, rhs : Uint${rhsWidth}) -> (res : Uint${width}):`,
                `    # width <= rhs (shift amount) means result will be 0`,
                `    let (large_shift) = is_le_felt(${width}, rhs.value)`,
                `    if large_shift == 1:`,
                `        return (Uint${width}(0))`,
                `    else:`,
                `        let preserved_width = ${width} - rhs.value`,
                `        let (preserved_bound) = pow2(preserved_width)`,
                `        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)`,
                `        let (multiplier) = pow2(rhs.value)`,
                `        let res = lhs_truncated * multiplier`,
                `        return (Uint${width}(value=res))`,
                `    end`,
                `end`,
              ];
            }
          }),
        ];
      }
    }),
  );
}

export function shl_signed(): void {
  //Need to provide an implementation with 256bit rhs and <256bit lhs
  generateFile(
    'shl_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.math_cmp import is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_shl',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      'from warplib.maths.pow2 import pow2',
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                'func warp_shl_signed256_256{range_check_ptr}(lhs : Int256, rhs : Uint256) -> (result : Int256):',
                '    let (res) = uint256_shl(lhs.value, rhs)',
                '    return (Int256(value=res))',
                'end',
              ];
            } else {
              return [
                `func warp_shl_signed256_${rhsWidth}{range_check_ptr}(lhs : Int256, rhs : Uint${rhsWidth}) -> (result : Int256):`,
                '    let (high, low) = split_felt(rhs.value)',
                '    let (res) = uint256_shl(lhs.value, Uint256(low, high))',
                '    return (Int256(value=res))',
                'end',
              ];
            }
          }),
          'func warp_shl_signed256{range_check_ptr}(lhs : Int256, rhs : felt) -> (result : Int256):',
          '    let (high, low) = split_felt(rhs)',
          '    let (res) = uint256_shl(lhs.value, Uint256(low, high))',
          '    return (Int256(value=res))',
          'end',
        ];
      } else {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shl_signed${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Int${width}, rhs : Uint256) -> (res : Int${width}):`,
                `    if rhs.high == 0:`,
                `        let (res) = warp_shl_signed${width}_${width}(lhs, Uint${width}(rhs.low))`,
                `        return (res)`,
                `    else:`,
                `        return (Int${width}(value=0))`,
                `    end`,
                `end`,
              ];
            } else {
              return [
                `func warp_shl_signed${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Int${width}, rhs : Uint${rhsWidth}) -> (res : Int${width}):`,
                `    # width <= rhs (shift amount) means result will be 0`,
                `    let (large_shift) = is_le_felt(${width}, rhs.value)`,
                `    if large_shift == 1:`,
                `        return (Int${width}(0))`,
                `    else:`,
                `        let preserved_width = ${width} - rhs.value`,
                `        let (preserved_bound) = pow2(preserved_width)`,
                `        let (lhs_truncated) = bitwise_and(lhs.value, preserved_bound - 1)`,
                `        let (multiplier) = pow2(rhs.value)`,
                `        let res = lhs_truncated * multiplier`,
                `        return (Int${width}(value=res))`,
                `    end`,
                `end`,
              ];
            }
          }),
        ];
      }
    }),
  );
}

export function functionaliseShl(node: BinaryOperation, ast: AST): void {
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const rhsType = getNodeType(node.vRightExpression, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);

  assert(
    lhsType instanceof IntType || lhsType instanceof FixedBytesType,
    `lhs of << ${printNode(node)} non-int type ${printTypeNode(lhsType)}`,
  );
  assert(
    rhsType instanceof IntType,
    `rhs of << ${printNode(node)} non-int type ${printTypeNode(rhsType)}`,
  );

  const lhsWidth = getIntOrFixedByteBitWidth(lhsType);

  const fullName = `warp_shl${
    lhsType instanceof IntType && lhsType.signed ? '_signed' : ''
  }${lhsWidth}_${rhsType.nBits}`;

  const importName = `warplib.maths.shl${
    lhsType instanceof IntType && lhsType.signed ? '_signed' : ''
  }`;

  const stub = createCairoFunctionStub(
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
    lhsWidth === 256 ? ['range_check_ptr'] : ['range_check_ptr', 'bitwise_ptr'],
    ast,
    node,
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
      stub.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, importName, fullName);
}
