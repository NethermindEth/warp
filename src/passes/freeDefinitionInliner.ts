import {
  ASTNode,
  ContractDefinition,
  EnumDefinition,
  ErrorDefinition,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  Identifier,
  StructDefinition,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { union } from '../utils/utils';

type FreeDeclaration =
  | StructDefinition
  | FunctionDefinition
  | EnumDefinition
  | ErrorDefinition
  | UserDefinedValueTypeDefinition;

/* 
  Library calls in solidity are delegate calls
  i.e  libraries can be seen as implicit base contracts of the contracts that use them
  The ReferencedLibraries pass converts external call to the library to internal call 
  to it. 
  This pass is called before the ReferncedLibraries pass to inline free functions 
  into the contract if the free functions make library calls or if they call other free
  function which do that.
*/

export class FreeDeclarationInliner extends ASTMapper {
  funcCounter = 0;

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Stores old FunctionDefinition and cloned FunctionDefinition
    const remappings = new Map<FreeDeclaration, FreeDeclaration>();

    // Visit all FunctionCalls in a Contract and check if they call
    // free functions that call Library Functions
    getDeclarationsToInline(node, new Set<FreeDeclaration>()).forEach((declarationToInline) => {
      const clonedDec = cloneASTNode(declarationToInline, ast);
      clonedDec.name = `free_declaration_${this.funcCounter++}_${clonedDec.name}`;
      if (clonedDec instanceof FunctionDefinition) {
        clonedDec.visibility = FunctionVisibility.Internal;
        clonedDec.kind = FunctionKind.Function;
      }
      if ('scope' in clonedDec) {
        clonedDec.scope = node.id;
      }
      node.appendChild(clonedDec);
      remappings.set(declarationToInline, clonedDec);
    });

    updateReferencedDeclarations(node, remappings);
  }
}

// Checks the given free function for library calls, and recurses through any free functions it calls
// to see if any of them call libraries. All functions reachable from func that call library functions
// directly or indirectly are returned to be inlined
function getDeclarationsToInline(
  node: ASTNode,
  visited: Set<FreeDeclaration>,
): Set<FreeDeclaration> {
  return getTopLevelFreeDecs(node)
    .map((declaration) => {
      if (visited.has(declaration)) return new Set<FreeDeclaration>();
      visited.add(declaration);
      return getDeclarationsToInline(declaration, new Set([...visited]));
    })
    .reduce(union, new Set<FunctionDefinition>());
}

function getTopLevelFreeDecs(node: ASTNode): FreeDeclaration[] {
  return [
    ...node
      .getChildrenByType(FunctionCall)
      .map((fc) => fc.vReferencedDeclaration)
      .filter((fd): fd is FunctionDefinition | EventDefinition | ErrorDefinition => isFree(fd)),
    ...node
      .getChildrenByType(Identifier)
      .map((id) => id.vReferencedDeclaration)
      .filter(isFree),
    ...node
      .getChildrenByType(UserDefinedTypeName)
      .map((tn) => tn.vReferencedDeclaration)
      .filter(isFree),
  ];
}

function updateReferencedDeclarations(
  node: ContractDefinition,
  remappingIds: Map<FreeDeclaration, FreeDeclaration>,
) {
  node.walkChildren((node) => {
    if (node instanceof Identifier || node instanceof UserDefinedTypeName) {
      if (isFree(node.vReferencedDeclaration)) {
        const remapping = remappingIds.get(node.vReferencedDeclaration);

        if (remapping !== undefined) {
          node.referencedDeclaration = remapping.id;
          node.name = remapping.name;
        }
      }
    }
  });
}

function isFree(node: ASTNode | undefined): node is FreeDeclaration {
  if (node === undefined) return false;
  return (
    node.getClosestParentByType(ContractDefinition) === undefined &&
    (node instanceof StructDefinition ||
      node instanceof FunctionDefinition ||
      node instanceof EnumDefinition ||
      node instanceof ErrorDefinition ||
      node instanceof UserDefinedValueTypeDefinition)
  );
}
