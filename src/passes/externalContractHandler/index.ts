import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { ContractDefinition } from 'solc-typed-ast';

import { ExternalContractInterfaceInserter } from './externalContractInterfaceInserter';

/*
  This is a compound pass which internally calls ExternalContractInterfaceInserter pass 
  to insert interfaces for the external contracts that has been refrenced into the AST
  for every SourceUnit.
*/

export class ExternalContractHandler extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const contractInterfaces: Map<number, ContractDefinition> = new Map();
      new ExternalContractInterfaceInserter(contractInterfaces).dispatchVisit(root, ast);
    });
    return ast;
  }
}
