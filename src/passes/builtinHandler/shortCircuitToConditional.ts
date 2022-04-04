import { BinaryOperation, Conditional } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createBoolLiteral } from '../../utils/nodeTemplates';

export class ShortCircuitToConditional extends ASTMapper {
  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.operator == '&&') {
      const replacementExpression = new Conditional(
        ast.reserveId(),
        node.src,
        'bool',
        node.vLeftExpression,
        node.vRightExpression,
        createBoolLiteral(false, ast),
      );

      ast.replaceNode(node, replacementExpression);
    }

    if (node.operator == '||') {
      const replacementExpression = new Conditional(
        ast.reserveId(),
        node.src,
        'bool',
        node.vLeftExpression,
        createBoolLiteral(true, ast),
        node.vRightExpression,
      );

      ast.replaceNode(node, replacementExpression);
    }
  }
}
