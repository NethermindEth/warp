import {
  ContractDefinition,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  Identifier,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { union } from '../utils/utils';

/* 
  Library calls in solidity are delegate calls
  i.e  libraries can be seen as implicit base contracts of the contracts that use them
  The ReferencedLibraries pass converts external call to the library to internal call 
  to it. 
  This pass is called before the ReferncedLibraries pass to inline free functions 
  into the contract if the free functions make library calls or if they call other free
  function which do that.
*/

export class FreeFunctionInliner extends ASTMapper {
  funcCounter = 0;

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Stores old FunctionDefinition and cloned FunctionDefinition
    const remappings = new Map<FunctionDefinition, FunctionDefinition>();

    // Visit all FunctionCalls in a Contract and check if they call
    // free functions that call Library Functions
    node
      .getChildrenByType(FunctionCall)
      .map((fCall) => fCall.vReferencedDeclaration)
      .filter(
        (definition): definition is FunctionDefinition =>
          definition instanceof FunctionDefinition && definition.kind === FunctionKind.Free,
      )
      .map((freeFunc) => getFunctionsToInline(freeFunc))
      .reduce(union, new Set<FunctionDefinition>())
      .forEach((funcToInline) => {
        const clonedFunction = cloneASTNode(funcToInline, ast);
        clonedFunction.name = `f${this.funcCounter++}_${clonedFunction.name}`;
        clonedFunction.visibility = FunctionVisibility.Internal;
        clonedFunction.scope = node.id;
        clonedFunction.kind = FunctionKind.Function;
        node.appendChild(clonedFunction);
        remappings.set(funcToInline, clonedFunction);
      });

    updateReferencedDeclarations(node, remappings);
  }
}

// Checks the given free function for library calls, and recurses through any free functions it calls
// to see if any of them call libraries. All functions reachable from func that call library functions
// directly or indirectly are returned to be inlined
function getFunctionsToInline(
  func: FunctionDefinition,
  visited: Set<FunctionDefinition> = new Set(),
): Set<FunctionDefinition> {
  const funcsToInline = func
    .getChildrenByType(FunctionCall)
    .map((fCall) => fCall.vReferencedDeclaration)
    .filter(
      (def): def is FunctionDefinition =>
        def instanceof FunctionDefinition && def.kind === FunctionKind.Free && !visited.has(def),
    )
    .map((freeFunc) =>
      getFunctionsToInline(freeFunc, new Set<FunctionDefinition>([func, ...visited])),
    )
    .reduce(union, new Set<FunctionDefinition>());

  funcsToInline.add(func);
  return funcsToInline;
}

function updateReferencedDeclarations(
  node: ContractDefinition,
  remappingIds: Map<FunctionDefinition, FunctionDefinition>,
) {
  node.walkChildren((node) => {
    if (node instanceof Identifier) {
      if (node.vReferencedDeclaration instanceof FunctionDefinition) {
        const remapping = remappingIds.get(node.vReferencedDeclaration);

        if (remapping !== undefined) {
          node.referencedDeclaration = remapping.id;
          node.name = remapping.name;
        }
      }
    }
  });
}
