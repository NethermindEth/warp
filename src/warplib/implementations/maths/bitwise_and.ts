import { BinaryOperation } from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { Implicits } from '../../../utils/implicits';
import { IntxIntFunction } from '../../utils';

export function functionaliseBitwiseAnd(node: BinaryOperation, ast: AST): void {
  IntxIntFunction(node, 'bitwise_and', 'only256', false, false, ast);
}
