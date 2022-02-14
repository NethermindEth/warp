import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { IntxIntFunction } from '../../utils';

export function functionaliseXor(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (width: number): Implicits[] => {
    if (width === 256) return ['range_check_ptr', 'bitwise_ptr'];
    else return ['bitwise_ptr'];
  };
  IntxIntFunction(node, 'xor', 'only256', false, false, implicitsFn, ast);
}
