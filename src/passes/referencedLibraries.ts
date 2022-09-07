import assert from 'assert';
import {
  ASTNode,
  CallableDefinition,
  ContractDefinition,
  ContractKind,
  ErrorDefinition,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  MemberAccess,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';

// Library calls in solidity are delegate calls
// i.e  libraries can be seen as implicit base contracts of the contracts that use them
// The pass converts external call to a library to an internal call to it
// by adding the referenced Libraries in the `FunctionCall` to the
// linearizedBaselist of a contract/Library.

export class ReferencedLibraries extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      // Free Function inliner handles free functions that make library calls
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
      const result = findDeclarationInLibrary(calledDeclaration.id, this.librariesById);
      if (result !== undefined) {
        const [decl, library] = result;
        getLibrariesToInherit(decl, library, this.librariesById).forEach((id) => {
          if (!parent.linearizedBaseContracts.includes(id)) {
            parent.linearizedBaseContracts.push(id);
          }
        });
      }
    }
    this.commonVisit(node, ast);
  }
}

function findDeclarationInLibrary(
  calledDeclarationId: number,
  librariesById: Map<number, ContractDefinition>,
): [CallableDefinition, ContractDefinition] | undefined {
  for (const library of librariesById.values()) {
    for (const node of library.getChildren()) {
      if (node.id == calledDeclarationId) {
        assert(
          isCallableDefinition(node),
          `Node ${printNode(node)} should be a Callable Definition`,
        );
        return [node, library];
      }
    }
  }
  return undefined;
}

function getLibrariesToInherit(
  declaration: CallableDefinition,
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ContractDefinition>,
): Set<number> {
  const visitedNodes: Set<number> = new Set();
  const ids: Set<number> = new Set();
  getAllLibraries(declaration, calledLibrary, librariesById, ids, visitedNodes);

  return ids;
}

function getAllLibraries(
  declaration: CallableDefinition,
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ContractDefinition>,
  ids: Set<number>,
  visitedNodes: Set<number>,
): void {
  visitedNodes.add(declaration.id);
  if (!ids.has(calledLibrary.id)) ids.add(calledLibrary.id);

  declaration
    .getChildren()
    .filter(
      (child): child is FunctionCall =>
        child instanceof FunctionCall && child.vExpression instanceof MemberAccess,
    )
    .forEach((functionCallInCalledLibrary) => {
      assert(functionCallInCalledLibrary.vExpression instanceof MemberAccess);
      const calledDeclarationId = functionCallInCalledLibrary.vExpression.referencedDeclaration;
      if (!visitedNodes.has(calledDeclarationId)) {
        const result = findDeclarationInLibrary(calledDeclarationId, librariesById);
        if (result !== undefined) {
          const [newDecl, library] = result;
          getAllLibraries(newDecl, library, librariesById, ids, visitedNodes);
        }
      }
    });
}

function isCallableDefinition(node: ASTNode): node is CallableDefinition {
  return (
    node instanceof FunctionDefinition ||
    node instanceof EventDefinition ||
    node instanceof ErrorDefinition ||
    node instanceof VariableDeclaration
  );
}
