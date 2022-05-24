import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionCall,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  PointerType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { typeNameFromTypeNode } from '../../utils/utils';
import { ReferenceSubPass } from './referenceSubPass';

export class StoredPointerDerference extends ReferenceSubPass {
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
    if (isDynamicStorageArray(nodeType) || isComplexMemoryType(nodeType)) {
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

  visitIdentifier(node: Identifier, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);
    // We're only trying to modify stored pointers, so skip if this isn't one
    if (!isDynamicStorageArray(type) && !isComplexMemoryType(type)) {
      return this.commonVisit(node, ast);
    }

    //Non-state variable identifiers contain dynamic array pointers directly
    if (!referencesStateVariable(node)) {
      return this.commonVisit(node, ast);
    }

    // TODO insert optimisation here
    return this.visitPotentialStoredPointer(node, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitPotentialStoredPointer(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitPotentialStoredPointer(node, ast);
  }
}

function isDynamicStorageArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.Storage &&
    type.to instanceof ArrayType &&
    type.to.size === undefined
  );
}

function isComplexMemoryType(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.Memory &&
    (type.to instanceof ArrayType ||
      (type.to instanceof UserDefinedType && type.to.definition instanceof StructDefinition))
  );
}

function referencesStateVariable(node: Identifier): boolean {
  return (
    node.vReferencedDeclaration instanceof VariableDeclaration &&
    node.vReferencedDeclaration.stateVariable
  );
}
