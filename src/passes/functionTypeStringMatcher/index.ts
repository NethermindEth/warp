import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { VariableDeclaration } from 'solc-typed-ast';

import { FunctionDefinitionMatcher } from './functionDefinitionTypestringMatcher';
import { IdentifierTypeStringMatcher } from './identifierTypeStringMatcher';

export class FunctionTypeStringMatcher extends ASTMapper {
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
