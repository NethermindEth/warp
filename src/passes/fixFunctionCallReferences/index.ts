import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { FunctionDefinition } from 'solc-typed-ast';

import { GetGetters } from './getGetters';
import { FixFnCallRef } from './fixFnCallRef';

export class FixFunctionCallReferences extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const getterFunctions: Map<number, FunctionDefinition> = new Map();
      new GetGetters(getterFunctions).dispatchVisit(root, ast);
      new FixFnCallRef(getterFunctions).dispatchVisit(root, ast);
    });
    return ast;
  }
}
