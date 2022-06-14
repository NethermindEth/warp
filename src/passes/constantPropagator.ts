import { Identifier, Literal, Mutability, VariableDeclaration } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import {cloneASTNode} from '../utils/cloning';

export class ConstantPropagator extends ASTMapper {
  isConstant(node: VariableDeclaration): boolean {
    return node.mutability === Mutability.Constant && node.vValue instanceof Literal;
  }

  visitIdentifier(node: Identifier, ast: AST): void {
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

    const literalConstant = cloneASTNode(referencedDeclaration.vValue, ast);

    ast.replaceNode(node, literalConstant);
  }
}
