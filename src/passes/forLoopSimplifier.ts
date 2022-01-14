import { Block, ForStatement, VariableDeclarationStatement } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

// TODO rewrite this to replace all loops with whiles and functionalise whiles
export class ForLoopSimplifier extends ASTMapper {
  visitForStatement(node: ForStatement, ast: AST): void {
    const innerLoopStatements = node.vLoopExpression
      ? [node.vBody, node.vLoopExpression]
      : [node.vBody];
    const replacementFor = new ForStatement(
      ast.reserveId(),
      node.src,
      node.type,
      new Block(ast.reserveId(), node.src, 'Block', innerLoopStatements),
      undefined,
      node.vCondition,
    );

    const replacementId = ast.replaceNode(
      node,
      new Block(ast.reserveId(), node.src, 'Block', [replacementFor], node.documentation, node.raw),
    );

    if (node.vInitializationExpression !== undefined) {
      if (node.vInitializationExpression instanceof VariableDeclarationStatement) {
        node.vInitializationExpression.vDeclarations.forEach(
          (decl) => (decl.scope = replacementId),
        );
      }
      ast.insertStatementBefore(replacementFor, node.vInitializationExpression);
    }
  }
}
