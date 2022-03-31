import { ASTNode, UnaryOperation } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class StorageDelete extends ASTMapper {
  constructor(public storageRefs: Set<ASTNode>) {
    super();
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.visitExpression(node, ast);

    if (node.operator !== 'delete') return;

    if (!this.storageRefs.has(node.vSubExpression)) return;

    const replacement = ast.getUtilFuncGen(node).storage.delete.gen(node.vSubExpression);
    ast.replaceNode(node, replacement);
  }
}
