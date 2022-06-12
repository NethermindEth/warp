import { MemberAccess, VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createIdentifier } from '../../utils/nodeTemplates';

export class StateVarRefFlattener extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vReferencedDeclaration.stateVariable
    ) {
      ast.replaceNode(node, createIdentifier(node.vReferencedDeclaration, ast));
      return;
    }

    this.visitExpression(node, ast);
  }
}
