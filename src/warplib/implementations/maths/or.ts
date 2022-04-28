import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { BoolxBoolFunction } from '../../utils';

export function functionaliseOr(node: BinaryOperation, ast: AST): void {
  BoolxBoolFunction(node, 'or', ast);
}
