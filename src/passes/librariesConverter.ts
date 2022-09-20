import {
  ASTNode,
  ASTNodeWithChildren,
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionVisibility,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { LIBRARY_CONTRACT_INFIX } from '../utils/nameModifiers';

// Clones a Library definition, converts it to regular Contract
// and inserts it as a new child node of the library's parent.
// This is made for transpiling the library as a contract.
export class LibrariesConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.kind === ContractKind.Library) {
      const contractNode = cloneASTNode(node, ast);
      contractNode.name = `${LIBRARY_CONTRACT_INFIX}${node.name}`;
      contractNode.kind = ContractKind.Contract;
      this.externalizeFunctions(contractNode);
      (node.parent as ASTNodeWithChildren<ASTNode>).appendChild(contractNode);
    }
  }

  externalizeFunctions(node: ContractDefinition): void {
    node.children.forEach((ch) => {
      if (ch instanceof FunctionDefinition) {
        (ch as FunctionDefinition).visibility = FunctionVisibility.External;
      }
    });
  }
}
