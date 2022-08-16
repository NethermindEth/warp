import { Identifier, Literal, MemberAccess, Mutability, VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { insertConversionIfNecessary } from './implicitConversionToExplicit';

export class ConstantHandler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

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
    const typeTo = safeGetNodeType(node, ast.compilerVersion);

    ast.replaceNode(node, constant);
    insertConversionIfNecessary(constant, typeTo, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    this.inlineConstant(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.inlineConstant(node, ast);
  }
}
