import assert from 'assert';
import {
  BinaryOperation,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { WARPLIB_MATHS } from '../../../utils/importPaths';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import { mapRange, typeNameFromTypeNode } from '../../../utils/utils';
import { forAllWidths, getIntOrFixedByteBitWidth, mask, WarplibFunctionInfo } from '../../utils';

export function exp() {
  return createExp(false, false);
}

export function exp_signed() {
  return createExp(true, false);
}

export function exp_unsafe() {
  return createExp(false, true);
}

export function exp_signed_unsafe() {
  return createExp(true, true);
}

function createExp(signed: boolean, unsafe: boolean): WarplibFunctionInfo {
  const suffix = `${signed ? '_signed' : ''}${unsafe ? '_unsafe' : ''}`;
  return {
    fileName: `exp${suffix}`,
    imports: [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.uint256 import Uint256, uint256_sub',
      `from warplib.maths.mul${suffix} import ${mapRange(
        32,
        (n) => `warp_mul${suffix}${8 * n + 8}`,
      ).join(', ')}`,
    ],
    functions: forAllWidths((width) => {
      if (width === 256) {
        return [
          `func _repeated_multiplication${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : Uint256, count : felt) -> (res : Uint256){`,
          `    if (count == 0){`,
          `        return (Uint256(1, 0),);`,
          `    }`,
          `    let (x) = _repeated_multiplication${width}(op, count - 1);`,
          `    let (res) = warp_mul${suffix}${width}(op, x);`,
          `    return (res,);`,
          `}`,
          `func warp_exp${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : felt) -> (res : Uint256){`,
          `    if (rhs == 0){`,
          `        return (Uint256(1, 0),);`,
          '    }',
          '    if (lhs.high == 0){',
          `        if (lhs.low * (lhs.low - 1) == 0){`,
          '            return (lhs,);',
          `        }`,
          `    }`,
          ...getNegativeOneShortcutCode(signed, width, false),
          `    let (res) = _repeated_multiplication${width}(lhs, rhs);`,
          `    return (res,);`,
          `}`,
          `func _repeated_multiplication_256_${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : Uint256, count : Uint256) -> (res : Uint256){`,
          `    if (count.low == 0 and count.high == 0){`,
          `        return (Uint256(1, 0),);`,
          `    }`,
          `    let (decr) = uint256_sub(count, Uint256(1, 0));`,
          `    let (x) = _repeated_multiplication_256_${width}(op, decr);`,
          `    let (res) = warp_mul${suffix}${width}(op, x);`,
          `    return (res,);`,
          `}`,
          `func warp_exp_wide${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256){`,
          `    if (rhs.high == 0 and rhs.low == 0){`,
          `        return (Uint256(1, 0),);`,
          '    }',
          '    if (lhs.high == 0 and lhs.low * (lhs.low - 1) == 0){',
          '        return (lhs,);',
          `    }`,
          ...getNegativeOneShortcutCode(signed, width, true),
          `    let (res) = _repeated_multiplication_256_${width}(lhs, rhs);`,
          `    return (res,);`,
          `}`,
        ].join('\n');
      } else {
        return [
          `func _repeated_multiplication${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt){`,
          `    alloc_locals;`,
          `    if (count == 0){`,
          `        return (1,);`,
          `    }else{`,
          `        let (x) = _repeated_multiplication${width}(op, count - 1);`,
          `        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;`,
          `        let (res) = warp_mul${suffix}${width}(op, x);`,
          `        return (res,);`,
          `    }`,
          `}`,
          `func warp_exp${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt){`,
          '    if (rhs == 0){',
          '        return (1,);',
          `    }`,
          '    if (lhs * (lhs-1) * (rhs-1) == 0){',
          '        return (lhs,);',
          '    }',
          ...getNegativeOneShortcutCode(signed, width, false),
          `    let (res) = _repeated_multiplication${width}(lhs, rhs);`,
          `    return (res,);`,
          '}',
          `func _repeated_multiplication_256_${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : Uint256) -> (res : felt){`,
          `    alloc_locals;`,
          `    if (count.low == 0 and count.high == 0){`,
          `        return (1,);`,
          `    }`,
          `    let (decr) = uint256_sub(count, Uint256(1, 0));`,
          `    let (x) = _repeated_multiplication_256_${width}(op, decr);`,
          `    local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr;`,
          `    let (res) = warp_mul${suffix}${width}(op, x);`,
          `    return (res,);`,
          `}`,
          `func warp_exp_wide${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : Uint256) -> (res : felt){`,
          '    if (rhs.low == 0){',
          '        if (rhs.high == 0){',
          '            return (1,);',
          '        }',
          `    }`,
          '    if (lhs * (lhs-1) == 0){',
          '        return (lhs,);',
          '    }',
          '    if (rhs.low == 1 and rhs.high == 0){',
          '        return (lhs,);',
          '    }',
          ...getNegativeOneShortcutCode(signed, width, true),
          `    let (res) = _repeated_multiplication_256_${width}(lhs, rhs);`,
          `    return (res,);`,
          '}',
        ].join('\n');
      }
    }),
  };
}

function getNegativeOneShortcutCode(signed: boolean, lhsWidth: number, rhsWide: boolean): string[] {
  if (!signed) return [];

  if (lhsWidth < 256) {
    return [
      `if ((lhs - ${mask(lhsWidth)}) == 0){`,
      `    let (is_odd) = bitwise_and(${rhsWide ? 'rhs.low' : 'rhs'}, 1);`,
      `    return (1 + is_odd * 0x${'f'.repeat(lhsWidth / 8 - 1)}e,);`,
      `}`,
    ];
  } else {
    return [
      `if ((lhs.low - ${mask(128)}) == 0 and (lhs.high - ${mask(128)}) == 0){`,
      `    let (is_odd) = bitwise_and(${rhsWide ? 'rhs.low' : 'rhs'}, 1);`,
      `    return (Uint256(1 + is_odd * 0x${'f'.repeat(31)}e, is_odd * ${mask(128)}),);`,
      `}`,
    ];
  }
}

export function functionaliseExp(node: BinaryOperation, unsafe: boolean, ast: AST) {
  const lhsType = safeGetNodeType(node.vLeftExpression, ast.inference);
  const rhsType = safeGetNodeType(node.vRightExpression, ast.inference);
  const retType = safeGetNodeType(node, ast.inference);
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
    rhsType.nBits === 256 ? '_wide' : '',
    retType.signed ? '_signed' : '',
    unsafe ? '_unsafe' : '',
    `${getIntOrFixedByteBitWidth(retType)}`,
  ].join('');

  const importName = [
    ...WARPLIB_MATHS,
    `exp${retType.signed ? '_signed' : ''}${unsafe ? '_unsafe' : ''}`,
  ];

  const importedFunc = ast.registerImport(
    node,
    importName,
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
      `function (${node.typeString}, ${node.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
}
