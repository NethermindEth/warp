import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { VariableDeclaration } from 'solc-typed-ast';

import { FunctionDefinitionMatcher } from './functionDefinitionTypestringMatcher';
import { IdentifierTypeStringMatcher } from './identifierTypeStringMatcher';

export class FunctionTypeStringMatcher extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPrerequisite(): void {
    const passKeys: string[] = ['Tf', 'Tnr', 'Ru', 'Fm', 'Ss', 'Ct', 'Ae', 'Idi', 'L', 'Na', 'Ufr'];
    passKeys.forEach((key) => this.addPrerequisite(key));
  }

  static map(ast: AST): AST {
    const declarations: Map<VariableDeclaration, boolean> = new Map();

    ast.roots.forEach((root) => {
      new FunctionDefinitionMatcher(declarations).dispatchVisit(root, ast);
    });

    ast.roots.forEach((root) => {
      new IdentifierTypeStringMatcher(declarations).dispatchVisit(root, ast);
    });
    return ast;
  }
}
