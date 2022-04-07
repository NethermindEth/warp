import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import { ContractDefinition } from 'solc-typed-ast';

import { ExternalContractInterfaceInserter } from './externalContractInterfaceInserter';

/*
  This is a compound pass which internally calls ExternalContractInterfaceInserter pass 
  to insert interfaces for the external contracts that has been refrenced into the AST
  for every SourceUnit.
  
  Simple importing contracts (namespaces in cairo) would not work because the constructors
  will conflict with the ones in the imported contracts.

  In order to call this contract from another contract, there is need to define an interface by
  copying the declarations of the external functions:
  for more info see: https://www.cairo-lang.org/docs/hello_starknet/calling_contracts.html
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
