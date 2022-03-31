import { ContractDefinition, ContractKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

const libraries: number[] = [];
export class ReferencedLibraries extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.kind === ContractKind.Library) {
      libraries.push(node.id);
    } else {
      if (libraries.length > 0) {
        libraries.forEach((lib) => {
          if (!node.linearizedBaseContracts.includes(lib)) {
            node.linearizedBaseContracts.push(lib);
          }
        });
      }
    }
    console.log(node.vLinearizedBaseContracts);
    this.commonVisit(node, ast);
  }
}
