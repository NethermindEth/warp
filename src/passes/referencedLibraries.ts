import { ContractDefinition, ContractKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

const libraries: number[] = [];
export class ReferencedLibraries extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.kind === ContractKind.Library) {
      libraries.push(node.id);
    } else {
      libraries.forEach((lib) => {
        if (node.linearizedBaseContracts.includes(lib) === false) {
          node.linearizedBaseContracts.push(lib);
        }
      });
    }
    this.commonVisit(node, ast);
  }
}
