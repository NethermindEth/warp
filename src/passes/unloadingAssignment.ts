import { Assignment, BinaryOperation } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneExpression } from '../utils/cloning';

export class UnloadingAssignment extends ASTMapper {
  visitAssignment(node: Assignment, ast: AST): void {
    if (node.operator === '=') return;
    const lhsValue = cloneExpression(node.vLeftHandSide, ast);

    // Extract e.g. "+" from "+="
    const operator = node.operator.slice(0, node.operator.length - 1);
    node.operator = '=';
    ast.replaceNode(
      node.vRightHandSide,
      new BinaryOperation(
        ast.reserveId(),
        node.src,
        'BinaryOperation',
        node.typeString,
        operator,
        lhsValue,
        node.vRightHandSide,
      ),
      node,
    );
  }
}
