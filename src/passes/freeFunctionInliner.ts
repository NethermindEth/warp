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

export class FreeFunctionInliner extends ASTMapper {
  funcCounter = 0;

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Stores old FunctionDefinition and cloned FunctionDefinition
    const remappings = new Map<FunctionDefinition, FunctionDefinition>();

    // Visit all FunctionCalls in a Contract to inline any free functions that are used
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

// Handles transitivity, recursively finding all free functions that this one depends on
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
