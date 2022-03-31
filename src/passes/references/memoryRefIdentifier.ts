import {
  ASTNode,
  DataLocation,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class MemoryRefIdentifier extends ASTMapper {
  constructor(public memoryRefs: Set<ASTNode>) {
    super();
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);
    if (type instanceof PointerType && type.location === DataLocation.Memory) {
      this.memoryRefs.add(node);
    }

    this.visitExpression(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);

    const type = getNodeType(node, ast.compilerVersion);

    if (
      this.memoryRefs.has(node.vExpression) ||
      (type instanceof PointerType && type.location === DataLocation.Memory)
    ) {
      this.memoryRefs.add(node);
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitExpression(node, ast);

    const type = getNodeType(node, ast.compilerVersion);

    if (
      this.memoryRefs.has(node.vBaseExpression) ||
      (type instanceof PointerType && type.location === DataLocation.Memory)
    ) {
      this.memoryRefs.add(node);
    }
  }
}
