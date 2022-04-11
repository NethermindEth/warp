import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  Identifier,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';

/* 
  Library calls in solidity are delegate calls
  i.e  libraries can be seen as implicit base contracts of the contracts that use them
  The ReferencedLibraries pass converts external call to the library to internal call 
  to it. 
  This pass is called before the ReferncedLibraries pass to inline free functions 
  into the contract if the free functions make library calls or if they call other free
  function which do that.
*/

export class FreeLibraryCallInliner extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Stores old FunctionDefinition and cloned FunctionDefinition
    const remappingIds = new Map<FunctionDefinition, FunctionDefinition>();

    // Visit all FunctionCalls in a Contract and check if they call
    // free functions that call Library Functions
    const functionCalls = node.getChildrenByType(FunctionCall);
    if (functionCalls.length > 0) {
      functionCalls.forEach((fcall) => {
        fcall.getChildren().forEach((identifier) => {
          if (identifier instanceof Identifier) {
            if (identifier.vReferencedDeclaration instanceof FunctionDefinition) {
              if (identifier.vReferencedDeclaration.kind === FunctionKind.Free) {
                const freeFunc = identifier.vReferencedDeclaration;
                let addNodes = new Map<number, FunctionDefinition>();
                addNodes.set(freeFunc.id, freeFunc);
                addNodes = getallFuncNodes(freeFunc, addNodes);

                addNodes.forEach((func, id) => {
                  const clonedFunction = cloneASTNode(func, ast);
                  clonedFunction.name = `${clonedFunction.name}_s${id + 1}`;
                  clonedFunction.visibility = func.visibility;
                  clonedFunction.scope = node.id;
                  node.appendChild(clonedFunction);
                  remappingIds.set(func, clonedFunction);
                });
              }
            }
          }
        });
      });
    }
    updateReferencedDeclarations(node, remappingIds);
  }
}

// Recursive function to collect all free FunctionDefinition nodes
// if they call a Library or call another free Function which make
// Library calls
function getallFuncNodes(
  func: FunctionDefinition,
  funcNodes: Map<number, FunctionDefinition>,
): Map<number, FunctionDefinition> {
  func.getChildrenByType(FunctionCall).forEach((fCall) => {
    // If function call is a Library function
    if (fCall.vExpression instanceof MemberAccess) {
      const identifier = fCall.vExpression.getChildrenByType(Identifier);
      identifier.forEach((node) => {
        if (node.vReferencedDeclaration instanceof ContractDefinition) {
          if (node.vReferencedDeclaration.kind === ContractKind.Library) {
            funcNodes.set(func.id, func);
          }
        }
      });
    } else if (fCall.vExpression instanceof Identifier) {
      if (fCall.vExpression.vReferencedDeclaration instanceof FunctionDefinition) {
        if (fCall.vExpression.vReferencedDeclaration.kind === FunctionKind.Free) {
          const fNode = fCall.vExpression.vReferencedDeclaration;
          funcNodes = getallFuncNodes(fNode, funcNodes);
        }
      }
    }
  });
  return funcNodes;
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
