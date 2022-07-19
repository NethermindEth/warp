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
import { mapRange, typeNameFromTypeNode } from '../../../utils/utils';
import {
  generateFile,
  forAllWidths,
  bound,
  msb,
  mask,
  getIntOrFixedByteBitWidth,
} from '../../utils';

export function shr(): void {
  generateFile(
    'shr',
    [
      'from starkware.cairo.common.bitwise import bitwise_and, bitwise_not',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le, is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_and',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      'from warplib.maths.pow2 import pow2',
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shr256_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (`,
                `        result : Uint256):`,
                `    if rhs.high != 0:`,
                `        return (Uint256(0, 0))`,
                `    end`,
                `    let (le_127) = is_le(rhs.low, 127)`,
                `    if le_127 == 1:`,
                `        # (h', l') := (h, l) >> rhs`,
                `        # p := 2^rhs`,
                `        # l' = ((h & (p-1)) << (128 - rhs)) + ((l&~(p-1)) >> rhs)`,
                `        #    = ((h & (p-1)) << 128 >> rhs) + ((l&~(p-1)) >> rhs)`,
                `        #    = (h & (p-1)) * 2^128 / p + (l&~(p-1)) / p`,
                `        #    = (h & (p-1) * 2^128 + l&~(p-1)) / p`,
                `        # h' = h >> rhs = (h - h&(p-1)) / p`,
                `        let (p) = pow2(rhs.low)`,
                `        let (low_mask) = bitwise_not(p - 1)`,
                `        let (low_part) = bitwise_and(lhs.low, low_mask)`,
                `        let (high_part) = bitwise_and(lhs.high, p - 1)`,
                `        return (`,
                `            Uint256(low=(low_part + ${bound(
                  128,
                )} * high_part) / p, high=(lhs.high - high_part) / p))`,
                `    end`,
                `    let (le_255) = is_le(rhs.low, 255)`,
                `    if le_255 == 1:`,
                `        let (p) = pow2(rhs.low - 128)`,
                `        let (mask) = bitwise_not(p - 1)`,
                `        let (res) = bitwise_and(lhs.high, mask)`,
                `        return (Uint256(res / p, 0))`,
                `    end`,
                `    return (Uint256(0, 0))`,
                `end`,
              ];
            } else {
              return [
                `func warp_shr256_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint${rhsWidth}) -> (`,
                `        result : Uint256):`,
                `    let (le_127) = is_le(rhs.value, 127)`,
                `    if le_127 == 1:`,
                `        # (h', l') := (h, l) >> rhs`,
                `        # p := 2^rhs`,
                `        # l' = ((h & (p-1)) << (128 - rhs)) + ((l&~(p-1)) >> rhs)`,
                `        #    = ((h & (p-1)) << 128 >> rhs) + ((l&~(p-1)) >> rhs)`,
                `        #    = (h & (p-1)) * 2^128 / p + (l&~(p-1)) / p`,
                `        #    = (h & (p-1) * 2^128 + l&~(p-1)) / p`,
                `        # h' = h >> rhs = (h - h&(p-1)) / p`,
                `        let (p) = pow2(rhs.value)`,
                `        let (low_mask) = bitwise_not(p - 1)`,
                `        let (low_part) = bitwise_and(lhs.low, low_mask)`,
                `        let (high_part) = bitwise_and(lhs.high, p - 1)`,
                `        return (`,
                `            Uint256(low=(low_part + ${bound(
                  128,
                )} * high_part) / p, high=(lhs.high - high_part) / p))`,
                `    end`,
                `    let (le_255) = is_le(rhs.value, 255)`,
                `    if le_255 == 1:`,
                `        let (p) = pow2(rhs.value - 128)`,
                `        let (mask) = bitwise_not(p - 1)`,
                `        let (res) = bitwise_and(lhs.high, mask)`,
                `        return (Uint256(res / p, 0))`,
                `    end`,
                `    return (Uint256(0, 0))`,
                `end`,
              ];
            }
          }),
        ];
      } else {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shr${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Uint${width}, rhs : Uint256) -> (res : Uint${width}):`,
                `    if rhs.high == 0:`,
                `        let (res) = warp_shr${width}_${width}(lhs, Uint${width}(rhs.low))`,
                `        return (res)`,
                `    else:`,
                `        return (Uint${width}(0))`,
                `    end`,
                `end`,
              ];
            } else {
              return [
                `func warp_shr${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Uint${width}, rhs : Uint${rhsWidth}) -> (res : Uint${width}):`,
                `    let (large_shift) = is_le_felt(${width}, rhs.value)`,
                `    if large_shift == 1:`,
                `        return (Uint${width}(0))`,
                `    else:`,
                `        let preserved_width = ${width} - rhs.value`,
                `        let (preserved_bound) = pow2(preserved_width)`,
                `        let mask = preserved_bound - 1`,
                `        let (divisor) = pow2(rhs.value)`,
                `        let shifted_mask = mask * divisor`,
                `        let (lhs_truncated) = bitwise_and(lhs.value, shifted_mask)`,
                `        let res = lhs_truncated / divisor`,
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

export function shr_signed(): void {
  generateFile(
    'shr_signed',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math_cmp import is_le, is_le_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_and',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
      'from warplib.maths.pow2 import pow2',
      // `from warplib.maths.shr import ${mapRange(
      //   32,
      //   (n) => `warp_shr${8 * n + 8}_${8 * n + 8}`,
      // ).join(', ')}`,
      `from warplib.maths.shr import ${mapRange(32, (n) =>
        mapRange(32, (m) => `warp_shr${8 * n + 8}_${8 * m + 8}`).join(', '),
      ).join(', ')}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shr_signed256_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Int256, rhs : Uint256) -> (res : Int256):`,
                `    if rhs.high == 0:`,
                `        let (res) = warp_shr_signed256_128(lhs, Uint128(rhs.low))`,
                `        return (res)`,
                `    else:`,
                `        let (res) = warp_shr_signed256_128(lhs, Uint128(256))`,
                `        return (res)`,
                `    end`,
                `end`,
              ];
            } else {
              return [
                `func warp_shr_signed256_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Int256, rhs : Uint${rhsWidth}) -> (res : Int256):`,
                `    alloc_locals`,
                `    let (local lhs_msb) = bitwise_and(lhs.value.high, ${msb(128)})`,
                `    let (logical_shift) = warp_shr256_${rhsWidth}(lhs.value, rhs)`,
                `    if lhs_msb == 0:`,
                `        return (Int256(logical_shift))`,
                `    else:`,
                `        let (large_shift) = is_le(${width}, rhs.value)`,
                `        if large_shift == 1:`,
                `            return (Int256(Uint256(${mask(128)}, ${mask(128)})))`,
                `        else:`,
                `            let (crosses_boundary) = is_le(128, rhs.value)`,
                `            if crosses_boundary == 1:`,
                `                let (bound) = pow2(rhs.value-128)`,
                `                let ones = bound - 1`,
                `                let (shift) = pow2(256-rhs.value)`,
                `                return (Int256(Uint256(logical_shift.low+ones*shift, ${mask(
                  128,
                )})))`,
                `            else:`,
                `                let (bound) = pow2(rhs.value)`,
                `                let ones = bound - 1`,
                `                let (shift) = pow2(128-rhs.value)`,
                `                return (Int256(Uint256(logical_shift.low, logical_shift.high+ones*shift)))`,
                `            end`,
                `        end`,
                `    end`,
                `end`,
              ];
            }
          }),
        ];
      } else {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func warp_shr_signed${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Int${width}, rhs : Uint256) -> (res : Int${width}):`,
                `    if rhs.high == 0:`,
                `        let (res) = warp_shr${width}_256(Uint${width}(lhs.value), rhs)`,
                `        return (Int${width}(value=res.value))`,
                `    else:`,
                `        let (res) = warp_shr${width}_${width}(Uint${width}(lhs.value), Uint${width}(${width}))`,
                `        return (Int${width}(value=res.value))`,
                `    end`,
                `end`,
              ];
            } else {
              return [
                `func warp_shr_signed${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(`,
                `        lhs : Int${width}, rhs : Uint${rhsWidth}) -> (res : Int${width}):`,
                `    alloc_locals`,
                `    let (local lhs_msb) = bitwise_and(lhs.value, ${msb(width)})`,
                `    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr`,
                `    if lhs_msb == 0:`,
                `        let (res) = warp_shr${width}_${rhsWidth}(Uint${width}(lhs.value), rhs)`,
                `        return (Int${width}(value=res.value))`,
                `    else:`,
                `        let (large_shift) = is_le_felt(${width}, rhs.value)`,
                `        if large_shift == 1:`,
                `            return (Int${width}(value=${mask(width)}))`,
                `        else:`,
                `            let (shifted) = warp_shr${width}_${rhsWidth}(Uint${width}(lhs.value), rhs)`,
                `            let (sign_extend_bound) = pow2(rhs.value)`,
                `            let sign_extend_value = sign_extend_bound - 1`,
                `            let (sign_extend_multiplier) = pow2(${width} - rhs.value)`,
                `            let res_felt = shifted.value + sign_extend_value * sign_extend_multiplier`,
                `            return (Int${width}(value=res_felt))`,
                `        end`,
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

export function functionaliseShr(node: BinaryOperation, ast: AST): void {
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const rhsType = getNodeType(node.vRightExpression, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);

  assert(
    lhsType instanceof IntType || lhsType instanceof FixedBytesType,
    `lhs of >> ${printNode(node)} non-int type ${printTypeNode(lhsType)}`,
  );
  assert(
    rhsType instanceof IntType,
    `rhs of >> ${printNode(node)} non-int type ${printTypeNode(rhsType)}`,
  );

  const lhsWidth = getIntOrFixedByteBitWidth(lhsType);
  const signed = lhsType instanceof IntType && lhsType.signed;

  const fullName = `warp_shr${signed ? '_signed' : ''}${lhsWidth}_${rhsType.nBits}`;

  const importName = `warplib.maths.shr${signed ? '_signed' : ''}`;

  const stub = createCairoFunctionStub(
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
    ['range_check_ptr', 'bitwise_ptr'],
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
