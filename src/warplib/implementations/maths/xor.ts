import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { IntxIntFunction } from '../../utils';

export function functionaliseXor(node: BinaryOperation, ast: AST): void {
  IntxIntFunction(node, 'xor', 'only256', false, false, ast);
}
