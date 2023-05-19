import assert from 'assert';
import {
  Expression,
  ExpressionStatement,
  ExternalReferenceType,
  FunctionCall,
  Return,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createBoolLiteral } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../export';

export class Require extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    const expressionNode = node.vExpression;

    const cairoAssert = this.requireToCairoAssert(expressionNode, ast);
    if (cairoAssert === null) {
      this.commonVisit(node, ast);
      return;
    }

    assert(expressionNode instanceof FunctionCall);

    ast.replaceNode(node, cairoAssert);
  }

  visitReturn(node: Return, ast: AST): void {
    const expressionNode = node.vExpression;
    const cairoAssert = this.requireToCairoAssert(expressionNode, ast);
    if (cairoAssert === null) return;

    ast.insertStatementBefore(node, cairoAssert);
    node.vExpression = undefined;
  }

  requireToCairoAssert(expression: Expression | undefined, ast: AST): ExpressionStatement | null {
    if (!(expression instanceof FunctionCall)) return null;
    if (expression.vFunctionCallType !== ExternalReferenceType.Builtin) {
      return null;
    }

    if (expression.vIdentifier === 'require' || expression.vIdentifier === 'assert') {
      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        cloneASTNode(expression, ast),
      );
    } else if (expression.vIdentifier === 'revert') {
      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        new FunctionCall(
          ast.reserveId(),
          expression.src,
          expression.typeString,
          expression.kind,
          expression.vExpression,
          [createBoolLiteral(false, ast), ...expression.vArguments],
        ),
      );
    }
    return null;
  }
}
