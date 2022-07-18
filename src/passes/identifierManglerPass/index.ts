import { ASTMapper } from '../../ast/mapper';
import { DeclarationNameMangler } from './declarationNameMangler';
import { AST } from '../../ast/ast';
import { ExpressionNameMangler } from './expressionNameMangler';
export class IdentifierMangler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = DeclarationNameMangler.map(ast);
    ast = ExpressionNameMangler.map(ast);
    return ast;
  }
}
