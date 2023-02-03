import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Comparison } from '../../utils';

export function functionaliseNeq(node: BinaryOperation, ast: AST): void {
  Comparison(node, 'neq', 'only256', false, ast);
}
