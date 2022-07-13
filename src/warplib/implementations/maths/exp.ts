import assert from 'assert';
import {
  BinaryOperation,
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
import { forAllWidths, generateFile, getIntOrFixedByteBitWidth, mask } from '../../utils';

export function exp() {
  createExp(false, false);
}

export function exp_signed() {
  createExp(true, false);
}

export function exp_unsafe() {
  createExp(false, true);
}

export function exp_signed_unsafe() {
  createExp(true, true);
}

function createExp(signed: boolean, unsafe: boolean) {
  const suffix = `${signed ? '_signed' : ''}${unsafe ? '_unsafe' : ''}`;
  generateFile(
    `exp${suffix}`,
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_sub',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      signed ? `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}` : '',
      `from warplib.maths.mul${suffix} import ${mapRange(
        32,
        (n) => `warp_mul${suffix}${8 * n + 8}`,
      ).join(', ')}`,
    ],
    forAllWidths((width) => {
      const lhsType = signed ? `Int${width}` : `Uint${width}`;
      if (width === 256) {
        return [
          ...forAllWidths((rhsWidth) => {
            if (rhsWidth === 256) {
              return [
                `func _repeated_multiplication_256_${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : ${lhsType}, count : Uint256) -> (res : ${lhsType}):`,
                `    if count.low == 0:`,
                `        if count.high == 0:`,
                `            return ${signed ? `(Int256(Uint256(1, 0)))` : `(Uint256(1, 0))`}`,
                `        end`,
                `    end`,
                `    let (decr) = uint256_sub(count, Uint256(1, 0))`,
                `    let (x) = _repeated_multiplication_256_${width}(op, decr)`,
                `    let (res) = warp_mul${suffix}${width}(op, x)`,
                `    return (res)`,
                `end`,

                `func warp_exp${suffix}${width}_256{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : ${lhsType}, rhs : Uint256) -> (res : ${lhsType}):`,
                `    if rhs.high == 0:`,
                `        if rhs.low == 0:`,
                `            return ${signed ? `(Int256(Uint256(1, 0)))` : `(Uint256(1, 0))`}`,
                `        end`,
                '    end',
                `    if lhs.${signed ? 'value.' : ''}high == 0 :`,
                `        if lhs.${signed ? 'value.' : ''}low * (lhs.${
                  signed ? 'value.' : ''
                }low - 1) == 0:`,
                '            return (lhs)',
                `        end`,
                `    end`,
                ...getNegativeOneShortcutCode(signed, width, true),
                `    let (res) = _repeated_multiplication_256_${width}(lhs, rhs)`,
                `    return (res)`,
                `end`,
              ];
            } else {
              return [
                `func _repeated_multiplication${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : ${lhsType}, count : Uint${rhsWidth}) -> (res : ${lhsType}):`,
                `    if count.value == 0:`,
                `        return ${signed ? `(Int256(Uint256(1, 0)))` : `(Uint256(1, 0))`}`,
                `    end`,
                `    let (x) = _repeated_multiplication${width}_${rhsWidth}(op, Uint${rhsWidth}(count.value - 1))`,
                `    let (res) = warp_mul${suffix}${width}(op, x)`,
                `    return (res)`,
                `end`,

                `func warp_exp${suffix}256_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : ${lhsType}, rhs : Uint${rhsWidth}) -> (res : ${lhsType}):`,
                `    if rhs.value == 0:`,
                `        return ${signed ? `(Int256(Uint256(1, 0)))` : `(Uint256(1, 0))`}`,
                '    end',
                `    if lhs.${signed ? 'value.' : ''}high == 0 :`,
                `        if lhs.${signed ? 'value.' : ''}low * (lhs.${
                  signed ? 'value.' : ''
                }low - 1) == 0:`,
                '            return (lhs)',
                `        end`,
                `    end`,
                ...getNegativeOneShortcutCode(signed, width, false),
                `    let (res) = _repeated_multiplication${width}_${rhsWidth}(lhs, rhs)`,
                `    return (res)`,
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
                `func _repeated_multiplication_256_${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : ${lhsType}, count : Uint256) -> (res : ${lhsType}):`,
                `    alloc_locals`,
                `    if count.low == 0:`,
                `        if count.high == 0:`,
                `            return (${lhsType}(1))`,
                `        end`,
                `    end`,
                `    let (decr) = uint256_sub(count, Uint256(1, 0))`,
                `    let (x) = _repeated_multiplication_256_${width}(op, decr)`,
                `    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr`,
                `    let (res) = warp_mul${suffix}${width}(op, x)`,
                `    return (res)`,
                `end`,

                `func warp_exp_${suffix}${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : ${lhsType}, rhs : Uint256) -> (res : ${lhsType}):`,
                '    if rhs.low == 0:',
                '        if rhs.high == 0:',
                `            return (${lhsType}(1))`,
                '        end',
                `    end`,
                '    if lhs.value * (lhs.value-1) == 0:',
                '        return (lhs)',
                '    end',
                '    if rhs.low == 1:',
                '        if rhs.high == 0:',
                '            return (lhs)',
                '        end',
                '    end',
                ...getNegativeOneShortcutCode(signed, width, true),
                `    let (res) = _repeated_multiplication_256_${width}(lhs, rhs)`,
                `    return (res)`,
                'end',
              ];
            } else {
              const rhsType = `Uint${rhsWidth}`;
              return [
                `func _repeated_multiplication${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : ${lhsType}, count : ${rhsType}) -> (res : ${lhsType}):`,
                `    alloc_locals`,
                `    if count.value == 0:`,
                `        return (${lhsType}(1))`,
                `    else:`,
                `        let (x) = _repeated_multiplication${width}_${rhsWidth}(op, ${rhsType}(count.value - 1))`,
                `        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr`,
                `        let (res) = warp_mul${suffix}${width}(op, x)`,
                `        return (res)`,
                `    end`,
                `end`,
                `func warp_exp${suffix}${width}_${rhsWidth}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : ${lhsType}, rhs : ${rhsType}) -> (res : ${lhsType}):`,
                '    if rhs.value == 0:',
                `        return (${lhsType}(1))`,
                `    end`,
                '    if lhs.value * (lhs.value-1) * (rhs.value-1) == 0:',
                '        return (lhs)',
                '    end',
                ...getNegativeOneShortcutCode(signed, width, false),
                `    let (res) = _repeated_multiplication${width}_${rhsWidth}(lhs, rhs)`,
                `    return (res)`,
                'end',
              ];
            }
          }),
        ];
      }
    }),
  );
}

function getNegativeOneShortcutCode(signed: boolean, lhsWidth: number, rhsWide: boolean): string[] {
  if (!signed) return [];

  if (lhsWidth < 256) {
    return [
      `if (lhs.value - ${mask(lhsWidth)}) == 0:`,
      `    let (is_odd) = bitwise_and(${rhsWide ? 'rhs.low' : 'rhs.value'}, 1)`,
      `    return (Int${lhsWidth}(1 + is_odd * 0x${'f'.repeat(lhsWidth / 8 - 1)}e))`,
      `end`,
    ];
  } else {
    return [
      `if (lhs.value.low - ${mask(128)}) == 0:`,
      `    if (lhs.value.high - ${mask(128)}) == 0:`,
      `        let (is_odd) = bitwise_and(${rhsWide ? 'rhs.low' : 'rhs.value'}, 1)`,
      `        return (Int256(Uint256(1 + is_odd * 0x${'f'.repeat(31)}e, is_odd * ${mask(128)})))`,
      `    end`,
      `end`,
    ];
  }
}

export function functionaliseExp(node: BinaryOperation, unsafe: boolean, ast: AST) {
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const rhsType = getNodeType(node.vRightExpression, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);
  assert(
    retType instanceof IntType,
    `${printNode(node)} has type ${printTypeNode(retType)}, which is not compatible with **`,
  );
  assert(
    rhsType instanceof IntType,
    `${printNode(node)} has rhs-type ${rhsType.pp()}, which is not compatible with **`,
  );
  const fullName = [
    'warp_',
    'exp',
    retType.signed ? '_signed' : '',
    unsafe ? '_unsafe' : '',
    `${getIntOrFixedByteBitWidth(retType)}`,
    `_${rhsType.nBits}`,
  ].join('');

  const importName = [
    'warplib.maths.',
    'exp',
    retType.signed ? '_signed' : '',
    unsafe ? '_unsafe' : '',
  ].join('');

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
      `function (${node.typeString}, ${node.typeString}) returns (${node.typeString})`,
      fullName,
      stub.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, importName, fullName);
}
