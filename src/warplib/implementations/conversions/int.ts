import assert from 'assert';
import { FunctionCall, generalizeType, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { Implicits } from '../../../utils/implicits';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import { bound, forAllWidths, generateFile, IntFunction, mask, msb, uint256 } from '../../utils';

export async function int_conversions(): Promise<void> {
  await generateFile(
    'int_conversions',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
    ],
    [
      ...forAllWidths((from) => {
        return forAllWidths((to) => {
          if (from < to) {
            if (to === 256) {
              return [
                `func warp_int${from}_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256){`,
                `    let (msb) = bitwise_and(op, ${msb(from)});`,
                `    let (high, low) = split_felt(op);`,
                `    let naiveExtension = Uint256(low, high);`,
                `    if (msb == 0){`,
                `        return (naiveExtension,);`,
                `    }else{`,
                `        let (res, _) = uint256_add(naiveExtension, ${uint256(
                  sign_extend_value(from, to),
                )});`,
                `        return (res,);`,
                `    }`,
                '}',
              ];
            } else {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt){`,
                `    let (msb) = bitwise_and(op, ${msb(from)});`,
                `    if (msb == 0){`,
                `        return (op,);`,
                `    }else{`,
                `        return (op + 0x${sign_extend_value(from, to).toString(16)},);`,
                `    }`,
                '}',
              ];
            }
          } else if (from === to) {
            return [];
          } else {
            if (from === 256) {
              if (to > 128) {
                return [
                  `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){`,
                  `    let (high) = bitwise_and(op.high,${mask(to - 128)});`,
                  `    return (op.low + ${bound(128)} * high,);`,
                  `}`,
                ];
              } else {
                return [
                  `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt){`,
                  `    let (res) = bitwise_and(op.low, ${mask(to)});`,
                  `    return (res,);`,
                  `}`,
                ];
              }
            } else {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr : BitwiseBuiltin*}(op : felt) -> (res : felt){`,
                `    let (res) = bitwise_and(op, ${mask(to)});`,
                `    return (res,);`,
                `}`,
              ];
            }
          }
        });
      }),
      '',
      'func warp_uint256{range_check_ptr}(op : felt) -> (res : Uint256){',
      '    let split = split_felt(op);',
      '    return (Uint256(low=split.low, high=split.high),);',
      '}',
    ],
  );
}

function sign_extend_value(from: number, to: number): bigint {
  return 2n ** BigInt(to) - 2n ** BigInt(from);
}

export function functionaliseIntConversion(conversion: FunctionCall, ast: AST): void {
  const arg = conversion.vArguments[0];
  const fromType = generalizeType(safeGetNodeType(arg, ast.inference))[0];
  assert(
    fromType instanceof IntType,
    `Argument of int conversion expected to be int type. Got ${printTypeNode(
      fromType,
    )} at ${printNode(conversion)}`,
  );
  const toType = safeGetNodeType(conversion, ast.inference);
  assert(
    toType instanceof IntType,
    `Int conversion expected to be int type. Got ${printTypeNode(toType)} at ${printNode(
      conversion,
    )}`,
  );

  if (fromType.nBits < 256 && toType.nBits === 256 && !fromType.signed && !toType.signed) {
    IntFunction(
      conversion,
      conversion.vArguments[0],
      'uint',
      'int_conversions',
      () => ['range_check_ptr'],
      ast,
    );
    return;
  } else if (
    fromType.nBits === toType.nBits ||
    (fromType.nBits < toType.nBits && !fromType.signed && !toType.signed)
  ) {
    arg.typeString = conversion.typeString;
    ast.replaceNode(conversion, arg);
    return;
  } else {
    const name = `${fromType.pp().startsWith('u') ? fromType.pp().slice(1) : fromType.pp()}_to_int`;
    const implicitsFn = (wide: boolean): Implicits[] => {
      if (wide) return ['range_check_ptr', 'bitwise_ptr'];
      return ['bitwise_ptr'];
    };
    IntFunction(conversion, conversion.vArguments[0], name, 'int_conversions', implicitsFn, ast);
    return;
  }
}
