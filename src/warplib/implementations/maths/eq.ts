import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { Comparison } from '../../utils';

export function functionaliseEq(node: BinaryOperation, ast: AST): void {
  const implicitsFn = (wide: boolean): Implicits[] => {
    if (wide) return ['range_check_ptr'];
    return [];
  };
  Comparison(node, 'eq', 'only256', false, implicitsFn, ast);
}
