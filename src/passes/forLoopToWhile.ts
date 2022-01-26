import {
  Block,
  ForStatement,
  Literal,
  LiteralKind,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { toHexString } from '../utils/utils';

// TODO rewrite this to replace all loops with whiles and functionalise whiles
export class ForLoopToWhile extends ASTMapper {
  visitForStatement(node: ForStatement, ast: AST): void {
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
          'Literal',
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
      'WhileStatement',
      loopCondition,
      new Block(ast.reserveId(), node.src, 'Block', innerLoopStatements),
    );

    const replacementId = ast.replaceNode(
      node,
      new Block(
        ast.reserveId(),
        node.src,
        'Block',
        [replacementWhile],
        node.documentation,
        node.raw,
      ),
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
}
