import assert from 'assert';
import { FunctionCall, generalizeType, getNodeType, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode, printTypeNode } from '../../../utils/astPrinter';
import { Implicits } from '../../../utils/implicits';
import { bound, forAllWidths, generateFile, IntFunction, mask, msb, uint256 } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function int_conversions(): void {
  generateFile(
    'int_conversions',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    [
      ...forAllWidths((from) => {
        return forAllWidths((to) => {
          if (from < to) {
            if (to === 256) {
              return [
                `func warp_int${from}_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : Int${from}) -> (res : Int256):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    let (high, low) = split_felt(op.value)`,
                `    let naiveExtension = Uint256(low, high)`,
                `    if msb == 0:`,
                `        return (Int256(value=naiveExtension))`,
                `    else:`,
                `        let (res, _) = uint256_add(naiveExtension, ${uint256(
                  sign_extend_value(from, to),
                )})`,
                `        return (Int256(value=res))`,
                `    end`,
                'end',
                ``,
                `func warp_uint${from}_to_int256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : Uint${from}) -> (res : Int256):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    let (high, low) = split_felt(op.value)`,
                `    let naiveExtension = Uint256(low, high)`,
                `    if msb == 0:`,
                `        return (Int256(value=naiveExtension))`,
                `    else:`,
                `        let (res, _) = uint256_add(naiveExtension, ${uint256(
                  sign_extend_value(from, to),
                )})`,
                `        return (Int256(value=res))`,
                `    end`,
                'end',
                ``,
                `func warp_int${from}_to_uint256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : Int${from}) -> (res : Uint256):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    let (high, low) = split_felt(op.value)`,
                `    let naiveExtension = Uint256(low, high)`,
                `    if msb == 0:`,
                `        return (naiveExtension)`,
                `    else:`,
                `        let (res, _) = uint256_add(naiveExtension, ${uint256(
                  sign_extend_value(from, to),
                )})`,
                `        return (res)`,
                `    end`,
                'end',
                ``,
                `func warp_uint${from}_to_uint256{range_check_ptr}(op : Uint${from}) -> (res : Uint256):`,
                '    let split = split_felt(op.value)',
                '    return (Uint256(low=split.low, high=split.high))',
                'end',
              ];
            } else {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int${from}) -> (res : Int${to}):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    if msb == 0:`,
                `        return (Int${to}(value=op.value))`,
                `    else:`,
                `        return (Int${to}(value = op.value + 0x${sign_extend_value(
                  from,
                  to,
                ).toString(16)}))`,
                `    end`,
                'end',
                ``,
                `func warp_uint${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint${from}) -> (res : Int${to}):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    if msb == 0:`,
                `        return (Int${to}(value=op.value))`,
                `    else:`,
                `        return (Int${to}(value = op.value + 0x${sign_extend_value(
                  from,
                  to,
                ).toString(16)}))`,
                `    end`,
                'end',
                ``,
                ``,
                `func warp_int${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int${from}) -> (res : Uint${to}):`,
                `    let (msb) = bitwise_and(op.value, ${msb(from)})`,
                `    if msb == 0:`,
                `        return (Uint${to}(value=op.value))`,
                `    else:`,
                `        return (Uint${to}(value = op.value + 0x${sign_extend_value(
                  from,
                  to,
                ).toString(16)}))`,
                `    end`,
                'end',
                ``,
                `func warp_uint${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint${from}) -> (res : Uint${to}):`,
                `    return (Uint${to}(value=op.value))`,
                'end',
              ];
            }
          } else if (from === to) {
            if (from === 256) {
              return [
                `func warp_uint256_to_int256{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : Int256):`,
                `    return (Int256(value=op))`,
                'end',
                ``,
                `func warp_int256_to_uint256{bitwise_ptr: BitwiseBuiltin*}(op : Int256) -> (res : Uint256):`,
                `    return (op.value)`,
                'end',
              ];
            } else {
              return [
                `func warp_uint${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint${from}) -> (res : Int${to}):`,
                `    return (Int${to}(value=op.value))`,
                'end',
                ``,
                `func warp_int${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int${from}) -> (res : Uint${to}):`,
                `    return (Uint${to}(value=op.value))`,
                'end',
              ];
            }
          } else {
            if (from === 256) {
              if (to > 128) {
                return [
                  `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int256) -> (res : Int${to}):`,
                  `    let (high) = bitwise_and(op.value.high,${mask(to - 128)})`,
                  `    return (Int${to}(value = op.value.low + ${bound(128)} * high))`,
                  `end`,
                  ``,
                  `func warp_uint${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : Int${to}):`,
                  `    let (high) = bitwise_and(op.high,${mask(to - 128)})`,
                  `    return (Int${to}(value = op.low + ${bound(128)} * high))`,
                  `end`,
                  ``,
                  `func warp_int${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int256) -> (res : Uint${to}):`,
                  `    let (high) = bitwise_and(op.value.high,${mask(to - 128)})`,
                  `    return (Uint${to}(value = op.value.low + ${bound(128)} * high))`,
                  `end`,
                  ``,
                  `func warp_uint${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : Uint${to}):`,
                  `    let (high) = bitwise_and(op.high,${mask(to - 128)})`,
                  `    return (Uint${to}(value = op.low + ${bound(128)} * high))`,
                  `end`,
                ];
              } else {
                return [
                  `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int256) -> (res : Int${to}):`,
                  `    let  (trunc_res) = bitwise_and(op.value.low, ${mask(to)})`,
                  `    return (Int${to}(value = trunc_res))`,
                  `end`,
                  ``,
                  `func warp_uint${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : Int${to}):`,
                  `    let  (trunc_res) = bitwise_and(op.low, ${mask(to)})`,
                  `    return (Int${to}(value = trunc_res))`,
                  `end`,
                  ``,
                  `func warp_int${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Int256) -> (res : Uint${to}):`,
                  `    let  (trunc_res) = bitwise_and(op.value.low, ${mask(to)})`,
                  `    return (Uint${to}(value = trunc_res))`,
                  `end`,
                  ``,
                  `func warp_uint${from}_to_uint${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : Uint${to}):`,
                  `    let  (trunc_res) = bitwise_and(op.low, ${mask(to)})`,
                  `    return (Uint${to}(value = trunc_res))`,
                  `end`,
                ];
              }
            } else {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr : BitwiseBuiltin*}(op : Int${from}) -> (res : Int${to}):`,
                `    let (trunc_res)  = bitwise_and(op.value, ${mask(to)})`,
                `    return (Int${to}(value = trunc_res))`,
                `end`,
                ``,
                `func warp_uint${from}_to_int${to}{bitwise_ptr : BitwiseBuiltin*}(op : Uint${from}) -> (res : Int${to}):`,
                `    let (trunc_res)  = bitwise_and(op.value, ${mask(to)})`,
                `    return (Int${to}(value = trunc_res))`,
                `end`,
                ``,
                `func warp_int${from}_to_uint${to}{bitwise_ptr : BitwiseBuiltin*}(op : Int${from}) -> (res : Uint${to}):`,
                `    let (trunc_res)  = bitwise_and(op.value, ${mask(to)})`,
                `    return (Uint${to}(value = trunc_res))`,
                `end`,
                ``,
                `func warp_uint${from}_to_uint${to}{bitwise_ptr : BitwiseBuiltin*}(op : Uint${from}) -> (res : Uint${to}):`,
                `    let (trunc_res)  = bitwise_and(op.value, ${mask(to)})`,
                `    return (Uint${to}(value = trunc_res))`,
                `end`,
              ];
            }
          }
        });
      }),
      '',
      'func warp_uint256{range_check_ptr}(op : felt) -> (res : Uint256):',
      '    let split = split_felt(op)',
      '    return (Uint256(low=split.low, high=split.high))',
      'end',
    ],
  );
}

function sign_extend_value(from: number, to: number): bigint {
  return 2n ** BigInt(to) - 2n ** BigInt(from);
}

export function functionaliseIntConversion(conversion: FunctionCall, ast: AST): void {
  const arg = conversion.vArguments[0];
  const fromType = generalizeType(getNodeType(arg, ast.compilerVersion))[0];
  assert(
    fromType instanceof IntType,
    `Argument of int conversion expected to be int type. Got ${printTypeNode(
      fromType,
    )} at ${printNode(conversion)}`,
  );
  const toType = getNodeType(conversion, ast.compilerVersion);
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
      `${fromType.pp()}_to_uint`,
      'int_conversions',
      () => ['range_check_ptr'],
      ast,
    );
    return;
  } else if (fromType.nBits === toType.nBits && fromType.signed === toType.signed) {
    ast.replaceNode(conversion, arg);
    return;
  } else {
    const name = `${fromType.pp()}_to_${toType.signed ? '' : 'u'}int`;
    const implicitsFn = (wide: boolean): Implicits[] => {
      if (wide) return ['range_check_ptr', 'bitwise_ptr'];
      return ['bitwise_ptr'];
    };
    IntFunction(conversion, conversion.vArguments[0], name, 'int_conversions', implicitsFn, ast);
    return;
  }
}
