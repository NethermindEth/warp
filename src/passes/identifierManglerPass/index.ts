import { ASTMapper } from '../../ast/mapper';
import { DeclarationNameMangler } from './declarationNameMangler';
import { AST } from '../../ast/ast';
import { ExpressionNameMangler } from './expressionNameMangler';
export class IdentifierMangler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      // RejectPrefix makes sure there are no names starting with the pattern
      // used for name generation in identifiers
      'Rp',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = DeclarationNameMangler.map(ast);
    ast = ExpressionNameMangler.map(ast);
    return ast;
  }
}
