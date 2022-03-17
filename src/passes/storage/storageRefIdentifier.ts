import {
  ASTNode,
  DataLocation,
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

  visitIdentifier(node: Identifier, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vReferencedDeclaration.stateVariable
    ) {
      this.storageRefs.add(node);
    } else {
      const type = getNodeType(node, ast.compilerVersion);
      if (type instanceof PointerType && type.location === DataLocation.Storage) {
        this.storageRefs.add(node);
      }
    }

    this.visitExpression(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    const type = getNodeType(node, ast.compilerVersion);

    if (
      this.storageRefs.has(node.vExpression) ||
      (type instanceof PointerType && type.location === DataLocation.Storage)
    ) {
      this.storageRefs.add(node);
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitExpression(node, ast);

    const type = getNodeType(node, ast.compilerVersion);

    if (
      this.storageRefs.has(node.vBaseExpression) ||
      (type instanceof PointerType && type.location === DataLocation.Storage)
    ) {
      this.storageRefs.add(node);
    }
  }
}
