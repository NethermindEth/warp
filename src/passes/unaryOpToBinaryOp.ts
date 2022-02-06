import { BinaryOperation, Literal, LiteralKind, UnaryOperation } from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneExpression } from '../utils/cloning';

function makeBinaryOpFromUnary(
  operation: string,
  oldNode: UnaryOperation,
  ast: AST,
): BinaryOperation {
  return new BinaryOperation(
    ast.reserveId(),
    oldNode.src,
    'BinaryOperation',
    'uint256',
    operation,
    cloneExpression(oldNode.vSubExpression, ast),
    new Literal(
      ast.reserveId(),
      oldNode.src,
      'Literal',
      'int_const 1',
      LiteralKind.Number,
      '0x1',
      '1',
    ),
  );
}

export class UnaryOpToBinaryOp extends ASTMapper {
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.prefix && (node.operator === '--' || node.operator === '++')) {
      throw new Error('Prefix Unary operations are not supported');
    }

    let operation: string;
    if (node.operator == '++') operation = '+';
    else if (node.operator == '--') operation = '-';
    else operation = '';

    if (operation) ast.replaceNode(node, makeBinaryOpFromUnary(operation, node, ast));
  }
}
