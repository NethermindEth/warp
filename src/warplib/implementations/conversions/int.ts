import { bound, forAllWidths, generateFile, mask, msb, uint256 } from '../../utils';

export function signed_int_conversions(): void {
  generateFile(
    'int_conversions',
    [
      'from starkware.cairo.common.bitwise import bitwise_and',
      'from starkware.cairo.common.cairo_builtins import BitwiseBuiltin',
      'from starkware.cairo.common.math import split_felt',
      'from starkware.cairo.common.uint256 import Uint256, uint256_add',
    ],
    forAllWidths((from) => {
      return forAllWidths((to) => {
        if (from < to) {
          if (to === 256) {
            return [
              `func warp_int${from}_to_int${to}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : Uint256):`,
              `    let (msb) = bitwise_and(op, ${msb(from)})`,
              `    let (high, low) = split_felt(op)`,
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
            ];
          } else {
            return [
              `func warp_int${from}_to_int${to}{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(op : felt) -> (res : felt):`,
              `    let (msb) = bitwise_and(op, ${msb(from)})`,
              `    if msb == 0:`,
              `        return (op)`,
              `    else:`,
              `        return (op + 0x${sign_extend_value(from, to).toString(16)})`,
              `    end`,
              'end',
            ];
          }
        } else if (from === to) {
          return [];
        } else {
          if (from === 256) {
            if (to > 128) {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt):`,
                `    let (high) = bitwise_and(op.high,${mask(to - 128)})`,
                `    return (op.low + ${bound(128)} * high)`,
                `end`,
              ];
            } else {
              return [
                `func warp_int${from}_to_int${to}{bitwise_ptr: BitwiseBuiltin*}(op : Uint256) -> (res : felt):`,
                `    return bitwise_and(op.low, ${mask(to)})`,
                `end`,
              ];
            }
          } else {
            return [];
          }
        }
      });
    }),
  );
}

function sign_extend_value(from: number, to: number): bigint {
  return 2n ** BigInt(to) - 2n ** BigInt(from);
}
