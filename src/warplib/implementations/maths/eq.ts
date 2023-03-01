import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Comparison } from '../../utils';

export function functionaliseEq(node: BinaryOperation, ast: AST): void {
  Comparison(node, 'eq', 'only256', false, ast);
}
