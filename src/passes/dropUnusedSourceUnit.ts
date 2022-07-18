import { ContractKind } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropUnusedSourceUnits extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    // Drop all source units which don't contain a deployable contract.
    ast.roots = ast.roots.filter(
      (su) =>
        su.vContracts.length > 0 &&
        su.vContracts.some((cd) => cd.kind == ContractKind.Contract && !cd.abstract),
    );
    return ast;
  }
}
