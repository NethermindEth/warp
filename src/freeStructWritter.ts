import {
  ASTNode,
  Identifier,
  SourceUnit,
  StructDefinition,
  UserDefinedTypeName,
} from 'solc-typed-ast';
import { AST } from './ast/ast';
import { makeStructTree, reorderStructs } from './passes/orderNestedStructs';

/* 
  Library calls in solidity are delegate calls
  i.e  libraries can be seen as implicit base contracts of the contracts that use them
  The ReferencedLibraries pass converts external call to the library to internal call 
  to it. 
  This pass is called before the ReferencedLibraries pass to inline free functions 
  into the contract if the free functions make library calls or if they call other free
  function which do that.
*/

export function getStructsAndRemappings(
  node: SourceUnit,
  ast: AST,
): [StructDefinition[], Map<number, string>] {
  // Stores old FunctionDefinition and cloned FunctionDefinition
  const remappings = new Map<number, string>();

  const externalStructs = getDefinitionsToInline(node, node, new Set());

  return [reorderStructs(...makeStructTree(externalStructs, ast)), remappings];
}

// DFS a node for definitions in a free context.
function getDefinitionsToInline(
  scope: SourceUnit,
  node: ASTNode,
  visited: Set<StructDefinition>,
): Set<StructDefinition> {
  [...getStructDefinitionsInChildren(scope, node)].forEach((declaration) => {
    if (visited.has(declaration)) return;
    visited.add(declaration);
    getDefinitionsToInline(scope, declaration, visited);
  });
  return visited;
}

function getStructDefinitionsInChildren(scope: SourceUnit, node: ASTNode): Set<StructDefinition> {
  return new Set([
    ...node
      .getChildrenByType(Identifier)
      .map((id) => id.vReferencedDeclaration)
      .filter((dec): dec is StructDefinition => isExternal(scope, dec)),
    ...node
      .getChildrenByType(UserDefinedTypeName)
      .map((tn) => tn.vReferencedDeclaration)
      .filter((dec): dec is StructDefinition => isExternal(scope, dec)),
  ]);
}

function isExternal(scope: SourceUnit, node: ASTNode | undefined): node is StructDefinition {
  return (
    node !== undefined &&
    node instanceof StructDefinition &&
    node.getClosestParentByType(SourceUnit) !== scope
  );
}
