import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { IntxIntFunction } from '../../utils';

export function functionaliseBitwiseOr(node: BinaryOperation, ast: AST): void {
  IntxIntFunction(node, 'bitwise_or', 'only256', false, false, ast);
}
