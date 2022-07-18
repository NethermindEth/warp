import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { VariableDeclaration, FunctionDefinition } from 'solc-typed-ast';

import { FixFnCallRef } from './fixFnCallRef';
import { GettersGenerator } from './gettersGenerator';

export class PublicStateVarsGetterGenerator extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    const getterFunctions: Map<VariableDeclaration, FunctionDefinition> = new Map();
    // Build up a map of all getter definitions across all files
    ast.roots.forEach((root) => {
      new GettersGenerator(getterFunctions).dispatchVisit(root, ast);
    });
    // Change all getter calls to reference the new functions
    ast.roots.forEach((root) => {
      new FixFnCallRef(getterFunctions).dispatchVisit(root, ast);
    });
    return ast;
  }
}
