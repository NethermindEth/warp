import assert from 'assert';
import {
  Assignment,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  IndexAccess,
  MappingType,
  MemberAccess,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { isComplexMemoryType, isDynamicStorageArray } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { ReferenceSubPass } from './referenceSubPass';

export class StoredPointerDereference extends ReferenceSubPass {
  visitPotentialStoredPointer(node: Expression, ast: AST): void {
    // First, collect data before any processing
    const originalNode = node;
    const [actualLoc, expectedLoc] = this.getLocations(node);
    if (expectedLoc === undefined) {
      return this.visitExpression(node, ast);
    }

    const utilFuncGen = ast.getUtilFuncGen(node);
    const parent = node.parent;
    const nodeType = getNodeType(node, ast.compilerVersion);

    // Next, if the node is a type that requires an extra read, insert this first
    if (isDynamicStorageArray(nodeType) || isComplexMemoryType(nodeType) || isMapping(nodeType)) {
      let readFunc: FunctionCall;
      if (actualLoc === DataLocation.Storage) {
        readFunc = utilFuncGen.storage.read.gen(node, typeNameFromTypeNode(nodeType, ast), parent);
      } else if (actualLoc === DataLocation.Memory) {
        readFunc = utilFuncGen.memory.read.gen(node, typeNameFromTypeNode(nodeType, ast), parent);
      } else {
        assert(false);
      }
      this.replace(node, readFunc, parent, actualLoc, expectedLoc, ast);
      if (actualLoc === undefined) {
        this.expectedDataLocations.delete(node);
      } else {
        this.expectedDataLocations.set(node, actualLoc);
      }
    }

    // Now that node has been inserted into the appropriate functions, read its children
    this.visitExpression(originalNode, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitPotentialStoredPointer(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitPotentialStoredPointer(node, ast);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    const lhsType = getNodeType(node.vLeftHandSide, ast.compilerVersion);

    if (isComplexMemoryType(lhsType)) {
      this.visitExpression(node.vLeftHandSide, ast);
      this.dispatchVisit(node.vRightHandSide, ast);
    } else {
      this.visitExpression(node, ast);
    }
  }
}

function isMapping(type: TypeNode): boolean {
  const [base] = generalizeType(type);
  return base instanceof MappingType;
}
