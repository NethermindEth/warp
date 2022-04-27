import {
  Continue,
  ForStatement,
  Literal,
  LiteralKind,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createBlock } from '../../utils/nodeTemplates';
import { toHexString } from '../../utils/utils';

export class ForLoopToWhile extends ASTMapper {
  visitForStatement(node: ForStatement, ast: AST): void {
    this.commonVisit(node, ast);

    const innerLoopStatements = node.vLoopExpression
      ? [node.vBody, node.vLoopExpression]
      : [node.vBody];

    // Handle the case where the loop condition is undefined in for statement
    // e.g. for (uint k = 0; ; k++)
    const loopCondition = node.vCondition
      ? node.vCondition
      : new Literal(
          ast.reserveId(),
          '',
          'bool',
          LiteralKind.Bool,
          toHexString('true'),
          'true',
          undefined,
          node.raw,
        );

    const replacementWhile = new WhileStatement(
      ast.reserveId(),
      node.src,
      loopCondition,
      createBlock(innerLoopStatements, ast),
    );

    const replacementId = ast.replaceNode(
      node,
      createBlock([replacementWhile], ast, node.documentation),
    );

    if (node.vInitializationExpression !== undefined) {
      if (node.vInitializationExpression instanceof VariableDeclarationStatement) {
        node.vInitializationExpression.vDeclarations.forEach(
          (decl) => (decl.scope = replacementId),
        );
      }
      ast.insertStatementBefore(replacementWhile, node.vInitializationExpression);
    }
  }

  visitContinue(node: Continue, ast: AST): void {
    // TODO change this once DoWhile is implemented
    const currentLoop = node.getClosestParentBySelector(
      (n) => n instanceof ForStatement || n instanceof WhileStatement,
    );
    if (currentLoop instanceof ForStatement && currentLoop.vLoopExpression) {
      ast.insertStatementBefore(node, cloneASTNode(currentLoop.vLoopExpression, ast));
    }
  }
}
