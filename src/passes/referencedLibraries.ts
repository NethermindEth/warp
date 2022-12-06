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
    const passKeys: Set<string> = new Set<string>([
      // FreeFunctionInliner handles free functions that make library calls
      'Ffi',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    // Collect all library nodes and their ids in the map 'librariesById'
    const librariesById: Map<number, ContractDefinition> = new Map();
    ast.context.map.forEach((astNode, id) => {
      if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
        librariesById.set(id, astNode);
      }
    });

    ast.roots.forEach((root) => new LibraryHandler(librariesById).dispatchVisit(root, ast));
    return ast;
  }
}

class LibraryHandler extends ASTMapper {
  librariesById: Map<number, ContractDefinition>;

  constructor(libraries: Map<number, ContractDefinition>) {
    super();
    this.librariesById = libraries;
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.vExpression instanceof MemberAccess) {
      const calledDeclaration = node.vReferencedDeclaration;
      if (calledDeclaration === undefined) return this.commonVisit(node, ast);

      // Free functions calling library functions are not yet supported.
      // The previous pass handles inlining those functions, so they can be ignored here.
      const parent = node.getClosestParentByType(ContractDefinition);
      if (parent === undefined) return;

      // Checks if the calledDeclaration is a referenced Library declaration,
      // if yes add it to the linearizedBaseContract list of parent ContractDefinition node.
      const library = findFunctionInLibrary(calledDeclaration.id, this.librariesById);
      if (library !== undefined) {
        getLibrariesToInherit(library, this.librariesById).forEach((id) => {
          if (!parent.linearizedBaseContracts.includes(id)) {
            parent.linearizedBaseContracts.push(id);
          }
        });
      }
    }
    this.commonVisit(node, ast);
  }
}

function findFunctionInLibrary(
  functionId: number,
  librariesById: Map<number, ContractDefinition>,
): ContractDefinition | undefined {
  for (const library of librariesById.values()) {
    if (library.vFunctions.some((f) => f.id === functionId)) return library;
  }
  return undefined;
}

function getLibrariesToInherit(
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ContractDefinition>,
): number[] {
  const ids: number[] = [];
  getAllLibraries(calledLibrary, librariesById, ids);

  return ids;
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
