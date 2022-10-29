import assert from 'assert';
import {
  Expression,
  ExpressionStatement,
  ExternalReferenceType,
  FunctionCall,
  Literal,
  Return,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { WillNotSupportError } from '../../utils/errors';
import { createBoolLiteral } from '../../utils/nodeTemplates';

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

    // Since the cairoAssert is not null, we have a require/revert/assert function call at hand
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
      const requireMessage =
        expression.vArguments[1] instanceof Literal ? expression.vArguments[1].value : null;

      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        new CairoAssert(
          ast.reserveId(),
          expression.src,
          expression.vArguments[0],
          requireMessage,
          expression.raw,
        ),
      );
    } else if (expression.vIdentifier === 'revert') {
      const revertMessage =
        expression.vArguments[0] instanceof Literal ? expression.vArguments[0].value : null;

      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        new CairoAssert(
          ast.reserveId(),
          expression.src,
          createBoolLiteral(false, ast),
          revertMessage,
          expression.raw,
        ),
      );
    }
    return null;
  }
}
