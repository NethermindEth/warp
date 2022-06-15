import { Identifier, Literal, MemberAccess, Mutability, VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';

export class ConstantHandler extends ASTMapper {
  isConstant(node: VariableDeclaration): boolean {
    return (
      node.mutability === Mutability.Constant &&
      (node.vValue instanceof Literal || node.vValue instanceof MemberAccess)
    );
  }

  inlineConstant(node: Identifier | MemberAccess, ast: AST): void {
    const referencedDeclaration = node.vReferencedDeclaration;
    if (
      !(
        referencedDeclaration instanceof VariableDeclaration &&
        referencedDeclaration.vValue &&
        this.isConstant(referencedDeclaration)
      )
    ) {
      return;
    }

    const constant = cloneASTNode(referencedDeclaration.vValue, ast);
    // Use the declaration's type string because the vValue's typestring might
    // const literal and creates problem further down the line since you cannot
    // infer its width.
    constant.typeString = referencedDeclaration.typeString;

    ast.replaceNode(node, constant);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    this.inlineConstant(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.inlineConstant(node, ast);
  }
}
