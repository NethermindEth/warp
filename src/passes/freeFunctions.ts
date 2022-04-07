import assert from 'assert';
import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';

/* 
  Pass:
  The pass inlines free functions into the contract if 
  the free functions make library calls.
*/

export class FreeFunctions extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    // Store all free functions
    const freeFunctions = new Map<number, FunctionDefinition>();

    // Stores referenced declaration of the Identifier and Identifier
    const identifierIds = new Map<number, Identifier>();

    // Stores non-updated referenced declaration of Identifier
    // and cloned FunctionDefinition
    const remappingIds = new Map<number, FunctionDefinition>();
    ast.roots.forEach((root) => {
      if (root.vContracts.length === 0) {
        root.getChildrenByType(FunctionDefinition).forEach((funcDef) => {
          freeFunctions.set(funcDef.id, funcDef);
        });
      }
    });

    // Store all Ids of Libraries ContractDefinition Node
    const contractDefLib: number[] = [];
    ast.context.map.forEach((astNode, key) => {
      if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
        contractDefLib.push(key);
      }
    });

    // Visit all FunctionCalls in a Contract and check if they call
    // free functions
    const functionCalls = node.getChildrenByType(FunctionCall);
    if (functionCalls.length > 0) {
      functionCalls.forEach((fcall) => {
        fcall.getChildren().forEach((identifier) => {
          if (identifier instanceof Identifier) {
            identifierIds.set(identifier.referencedDeclaration, identifier);
            const freeFunc = freeFunctions.get(identifier.referencedDeclaration);
            if (freeFunc === undefined) return;
            let addNodes = new Map<number, FunctionDefinition>();
            addNodes.set(freeFunc.id, freeFunc);
            addNodes = getallFuncNodes(
              freeFunc,
              contractDefLib,
              freeFunctions,
              addNodes,
              identifierIds,
            );

            addNodes.forEach((func, id) => {
              const clonedFunction = cloneASTNode(func, ast);
              clonedFunction.name = `${clonedFunction.name}_s${id + 1}`;
              clonedFunction.visibility = func.visibility;
              clonedFunction.scope = node.id;
              node.appendChild(clonedFunction);
              const identifierNode = identifierIds.get(id);
              assert(identifierNode !== undefined);
              remappingIds.set(id, clonedFunction);
            });
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
  ContractDefLibs: number[],
  freeFunc: Map<number, FunctionDefinition>,
  funcNodes: Map<number, FunctionDefinition>,
  identifierIds: Map<number, Identifier>,
): Map<number, FunctionDefinition> {
  if (func.getChildrenByType(FunctionCall).length === 0) return funcNodes;
  func.getChildrenByType(FunctionCall).forEach((fCall) => {
    // If function call is a Library
    if (fCall.vExpression instanceof MemberAccess) {
      // Identifier Node
      const identifier = fCall.vExpression.firstChild;

      assert(identifier instanceof Identifier);

      if (ContractDefLibs.includes(identifier.referencedDeclaration)) {
        funcNodes.set(func.id, func);
      }
    } else if (fCall.vExpression instanceof Identifier) {
      const fNode = freeFunc.get(fCall.vExpression.referencedDeclaration);
      identifierIds.set(fCall.vExpression.referencedDeclaration, fCall.vExpression);

      if (fNode !== undefined) {
        funcNodes = getallFuncNodes(fNode, ContractDefLibs, freeFunc, funcNodes, identifierIds);
      }
    }
  });

  return funcNodes;
}

function updateReferencedDeclarations(
  node: ContractDefinition,
  remappingIds: Map<number, FunctionDefinition>,
) {
  node.walkChildren((node) => {
    if (node instanceof Identifier) {
      const remapping = remappingIds.get(node.referencedDeclaration);

      if (remapping !== undefined) {
        node.referencedDeclaration = remapping.id;
        node.name = remapping.name;
      }
    }
  });
}
