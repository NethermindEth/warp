import { ASTMapper } from '../../ast/mapper';
import { DeclarationNameMangler } from './declarationNameMangler';
import { AST } from '../../ast/ast';
import { ExpressionNameMangler } from './expressionNameMangler';
export class IdentifierMangler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPrerequisite(): void {
    const passKeys: string[] = [
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
    ];
    passKeys.forEach((key) => this.addPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = DeclarationNameMangler.map(ast);
    ast = ExpressionNameMangler.map(ast);
    return ast;
  }
}
