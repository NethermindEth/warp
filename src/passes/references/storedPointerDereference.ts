import {
  Assignment,
  DataLocation,
  Expression,
  FunctionCall,
  IndexAccess,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import {
  isComplexMemoryType,
  isDynamicArray,
  isMapping,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
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
    const nodeType = safeGetNodeType(node, ast.inference);

    // Next, if the node is a type that requires an extra read, insert this first
    let readFunc: FunctionCall | null = null;
    if (actualLoc === DataLocation.Storage && (isDynamicArray(nodeType) || isMapping(nodeType))) {
      readFunc = utilFuncGen.storage.read.gen(node);
    } else if (actualLoc === DataLocation.Memory && isReferenceType(nodeType)) {
      readFunc = utilFuncGen.memory.read.gen(node);
    }
    if (readFunc !== null) {
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
    const lhsType = safeGetNodeType(node.vLeftHandSide, ast.inference);

    if (isComplexMemoryType(lhsType)) {
      this.visitExpression(node.vLeftHandSide, ast);
      this.dispatchVisit(node.vRightHandSide, ast);
    } else {
      this.visitExpression(node, ast);
    }
  }
}
