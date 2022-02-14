import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { mapRange } from '../../../utils/utils';
import { forAllWidths, generateFile, IntxIntFunction } from '../../utils';

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
      `from warplib.maths.mul${suffix} import ${mapRange(
        32,
        (n) => `warp_mul${suffix}${8 * n + 8}`,
      ).join(', ')}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func _repeated_multiplication${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : Uint256, count : Uint256) -> (res : Uint256):`,
          `    if count.low == 0:`,
          `        if count.high == 0:`,
          `            return (Uint256(1, 0))`,
          `        end`,
          `    end`,
          `    let (decr) = uint256_sub(count, Uint256(1, 0))`,
          `    let (x) = _repeated_multiplication${width}(op, decr)`,
          `    let (res) = warp_mul${suffix}${width}(op, x)`,
          `    return (res)`,
          `end`,
          `func warp_exp${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : Uint256, rhs : Uint256) -> (res : Uint256):`,
          '    if lhs.high == 0 :',
          `        if lhs.low == 0:`,
          '            return (Uint256(0,0))',
          `        end`,
          `    end`,
          `    if rhs.high == 0:`,
          `        if rhs.low == 0:`,
          `            return (Uint256(1, 0))`,
          `        end`,
          '    end',
          `    return _repeated_multiplication${width}(lhs, rhs)`,
          `end`,
        ];
      } else {
        return [
          `func _repeated_multiplication${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(op : felt, count : felt) -> (res : felt):`,
          `    alloc_locals`,
          `    if count == 0:`,
          `        return (1)`,
          `    else:`,
          `        let (x) = _repeated_multiplication${width}(op, count - 1)`,
          `        local bitwise_ptr : BitwiseBuiltin* = bitwise_ptr`,
          `        let (res) = warp_mul${suffix}${width}(op, x)`,
          `        return (res)`,
          `    end`,
          `end`,
          `func warp_exp${suffix}${width}{range_check_ptr, bitwise_ptr : BitwiseBuiltin*}(lhs : felt, rhs : felt) -> (res : felt):`,
          '    if lhs * (lhs-1) * (rhs-1) == 0:',
          '        return (lhs)',
          `    else:`,
          '        if rhs == 0:',
          '            return (1)',
          '        else:',
          `            return _repeated_multiplication${width}(lhs, rhs)`,
          '        end',
          `    end`,
          'end',
        ];
      }
    }),
  );
}

export function functionaliseExp(node: BinaryOperation, unsafe: boolean, ast: AST) {
  IntxIntFunction(
    node,
    'exp',
    'always',
    true,
    unsafe,
    () => ['range_check_ptr', 'bitwise_ptr'],
    ast,
  );
}
