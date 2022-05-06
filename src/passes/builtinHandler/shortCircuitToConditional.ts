import {
  Assignment,
  BinaryOperation,
  Conditional,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionStateMutability,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createBoolLiteral } from '../../utils/nodeTemplates';

export class ShortCircuitToConditional extends ASTMapper {
  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.operator == '&&' && this.expressionHasSideEffects(node.vRightExpression)) {
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

    if (node.operator == '||' && this.expressionHasSideEffects(node.vRightExpression)) {
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

  private expressionHasSideEffects(node: Expression): boolean {
    // No need to check if FunctionCall is a Struct constructor since it must evaluate to bool
    return (
      (node instanceof FunctionCall && this.functionAffectsState(node)) ||
      node instanceof Assignment ||
      node.children.some(
        (child) => child instanceof Expression && this.expressionHasSideEffects(child),
      )
    );
  }

  private functionAffectsState(node: FunctionCall): boolean {
    const funcDef = node.vReferencedDeclaration;
    if (funcDef instanceof FunctionDefinition) {
      return (
        funcDef.stateMutability !== FunctionStateMutability.Pure &&
        funcDef.stateMutability !== FunctionStateMutability.View
      );
    }
    return true;
  }
}
