import assert from 'assert';
import { ContractDefinition, ContractKind, FunctionCall, MemberAccess } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

// Library calls in solidity are delegate calls
// i.e  libraries can be seen as implicit base contracts of the contracts that use them
// The pass converts external call to a library to an internal call to it
// by adding the referenced Libraries in the `FunctionCall` to the
// linearizedBaselist of a contract/Library.

export class ReferencedLibraries extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const librariesById = new Map<number, ContractDefinition>();
    if (node.vExpression instanceof MemberAccess) {
      // Collect all library nodes and their ids in the map 'librariesById'
      ast.context.map.forEach((astNode, id) => {
        if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
          librariesById.set(id, astNode);
        }
      });

      const calledDeclaration = node.vReferencedDeclaration;
      if (calledDeclaration === undefined) {
        return this.visitExpression(node, ast);
      }

      // Free functions calling library functions are not yet supported
      const parent = node.getClosestParentByType(ContractDefinition);
      if (parent === undefined) return;

      // Checks if the Function is a referenced Library function,
      // if yes add it to the linearizedBaseContract list of parent ContractDefinition node.
      const library = findFunctionInLibrary(calledDeclaration.id, librariesById);
      if (library !== undefined) {
        getLibrariesToInherit(library, librariesById).forEach((id) => {
          if (!parent.linearizedBaseContracts.includes(id)) {
            parent.linearizedBaseContracts.push(id);
          }
        });
      }
    }
    this.commonVisit(node, ast);
  }
}

function getLibrariesToInherit(
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ContractDefinition>,
): number[] {
  const ids: number[] = [];
  getAllLibraries(calledLibrary, librariesById, ids);

  return ids;
}

function findFunctionInLibrary(
  functionId: number,
  librariesById: Map<number, ContractDefinition>,
): ContractDefinition | undefined {
  for (const library of librariesById.values()) {
    if (library.vFunctions.some((f) => f.id == functionId)) return library;
  }
  return undefined;
}

function getAllLibraries(
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ContractDefinition>,
  ids: number[],
): void {
  ids.push(calledLibrary.id);

  calledLibrary
    .getChildren()
    .filter(
      (child): child is FunctionCall =>
        child instanceof FunctionCall && child.vExpression instanceof MemberAccess,
    )
    .forEach((functionCallInCalledLibrary) => {
      assert(functionCallInCalledLibrary.vExpression instanceof MemberAccess);
      const calledFuncId = functionCallInCalledLibrary.vExpression.referencedDeclaration;

      const library = findFunctionInLibrary(calledFuncId, librariesById);
      if (library !== undefined && !ids.includes(library.id))
        getAllLibraries(library, librariesById, ids);
    });
}
