import {
  ASTNode,
  DataLocation,
  Expression,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  PointerType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class StorageRefIdentifier extends ASTMapper {
  constructor(public storageRefs: Set<ASTNode>) {
    super();
  }

  visitExpression(node: Expression, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);
    if (type instanceof PointerType && type.location === DataLocation.Storage) {
      this.storageRefs.add(node);
    }

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vReferencedDeclaration.stateVariable
    ) {
      this.storageRefs.add(node);
    }

    this.visitExpression(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (this.storageRefs.has(node.vExpression)) {
      this.storageRefs.add(node);
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitExpression(node, ast);

    if (this.storageRefs.has(node.vBaseExpression)) {
      this.storageRefs.add(node);
    }
  }
}
