import { BinaryOperation, FixedBytesType, getNodeType, IntType } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { Comparison, generateFile, forAllWidths } from '../../utils';
import { mapRange } from '../../../utils/utils';

export function neq() {
  generateFile(
    'neq',
    [
      `from starkware.cairo.common.uint256 import Uint256, uint256_eq`,
      `from warplib.types.uints import ${mapRange(31, (n) => `Uint${8 * n + 8}`)}`,
    ],
    [
      ...forAllWidths((width) => {
        if (width === 256) {
          return [
            `func warp_neq256{range_check_ptr}(lhs : Uint256, rhs : Uint256) -> (res : felt):`,
            `    let (res) = uint256_eq(lhs, rhs)`,
            `    return (1-res)`,
            `end`,
          ];
        } else {
          return [
            `func warp_neq${width}(lhs : Uint${width}, rhs : Uint${width}) -> (result : felt):`,
            `    if lhs.value == rhs.value:`,
            `        return (0)`,
            `    else:`,
            `        return (1)`,
            `    end`,
            `end`,
          ];
        }
      }),
      `func warp_neq(lhs : felt, rhs : felt) -> (result : felt):`,
      `    if lhs == rhs:`,
      `        return (0)`,
      `    else:`,
      `        return (1)`,
      `    end`,
      `end`,
    ],
  );
}

export function neq_signed() {
  generateFile(
    'neq_signed',
    [
      `from starkware.cairo.common.uint256 import Uint256, uint256_eq`,
      `from warplib.types.ints import ${mapRange(32, (n) => `Int${8 * n + 8}`)}`,
    ],
    forAllWidths((width) => {
      if (width === 256) {
        return [
          `func warp_neq_signed256{range_check_ptr}(lhs : Int256, rhs : Int256) -> (res : felt):`,
          `    let (res) = uint256_eq(lhs.value, rhs.value)`,
          `    return (1-res)`,
          `end`,
        ];
      } else {
        return [
          `func warp_neq_signed${width}(lhs : Int${width}, rhs : Int${width}) -> (result : felt):`,
          `    if lhs.value == rhs.value:`,
          `        return (0)`,
          `    else:`,
          `        return (1)`,
          `    end`,
          `end`,
        ];
      }
    }),
  );
}

export function functionaliseNeq(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean): Implicits[] => {
    if (wide) return ['range_check_ptr'];
    return [];
  };
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const appendWidth =
    lhsType instanceof IntType || lhsType instanceof FixedBytesType ? 'always' : 'only256';
  Comparison(node, 'neq', appendWidth, true, implicitsFn, ast);
}
