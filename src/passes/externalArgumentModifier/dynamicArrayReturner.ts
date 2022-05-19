import assert = require('assert');

import {
  ArrayType,
  ArrayTypeName,
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  getNodeType,
  Mutability,
  PointerType,
  Return,
  StateVariableVisibility,
  TupleExpression,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';

import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { dereferenceType, isExternallyVisible, typeNameFromTypeNode } from '../../utils/utils';
export class DynArrayReturner extends ASTMapper {
  /*
  This pass looks for dynamic arrays and returns them. There are two steps that need to be done. The first is we need to create a variable 
  declaration statement that assigns the memory/storage dynamic array to a calldata array.

  The second is that we need a function that is able to read them out. This will have to be done for storage and memory.
  First pass is to do this for memory and then storage. These functions do not have to be called in this pass since they will be auto generated
  in the references pass.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    const expressionMap = new Map<Expression, TypeNode>();
    let varCounter = 0;
    if (isExternallyVisible(node) && body !== undefined && body.lastChild instanceof Return) {
      const returnStatement = body.lastChild;
      //
      const retExpression = returnStatement.children[0];
      collectDynArrayExpressions(retExpression, expressionMap, ast);
      //
      //const expressionMap = collectDynArrayExpressions(node, dynArrayMap, ast);
      [...expressionMap.keys()].forEach((expre) => {
        const typeNode = expressionMap.get(expre);
        assert(typeNode !== undefined && typeNode instanceof ArrayType);
        const genTypeNode = generalizeType(typeNode);
        const varDecl = new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          `dynStruct${varCounter}`,
          node.id,
          false,
          DataLocation.CallData,
          StateVariableVisibility.Private,
          Mutability.Immutable,
          //typeNode.pp(),
          genTypeNode[0].pp(),
          undefined,
          typeNameFromTypeNode(typeNode, ast),
        );
        varCounter++;
        const dArrayStruct = cloneASTNode(varDecl, ast);
        dArrayStruct.name = dArrayStruct.name + '_ret_struct';
        dArrayStruct.storageLocation = DataLocation.CallData;

        this.genStructConstructor(dArrayStruct, node, ast);

        const intialValue = cloneASTNode(expre, ast);
        const structArrayStatement = this.createVariableDeclarationStatemet(
          dArrayStruct,
          intialValue,
          ast,
        );
        const replaceIdentifier = createIdentifier(dArrayStruct, ast);
        body.insertBefore(structArrayStatement, returnStatement);
        ast.replaceNode(expre, replaceIdentifier);
      });

      node.vReturnParameters.vParameters.forEach((varDecl) => {
        if (
          varDecl.storageLocation === DataLocation.Memory &&
          varDecl.vType instanceof ArrayTypeName &&
          varDecl.vType.vLength === undefined
        ) {
          varDecl.storageLocation = DataLocation.CallData;
        }
      });
    }
    ast.setContextRecursive(node);
    this.commonVisit(node, ast);
  }

  private createVariableDeclarationStatemet(
    varDecl: VariableDeclaration,
    intitalValue: Expression,
    ast: AST,
  ): VariableDeclarationStatement {
    return new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [varDecl.id],
      [varDecl],
      intitalValue,
    );
  }

  private genStructConstructor(
    dArrayVarDecl: VariableDeclaration,
    node: FunctionDefinition,
    ast: AST,
  ): FunctionCall {
    const structConstructor = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayStructConstructor.gen(dArrayVarDecl, node);
    return structConstructor;
  }
}

export function collectDynArrayExpressions(
  node: ASTNode | Expression,
  retMap: Map<Expression, TypeNode>,
  ast: AST,
): Map<Expression, TypeNode> {
  assert(node instanceof Expression);
  // Going to filter the return statement for all expressions that will return
  // TypeNode DynamicArray
  const type = getNodeType(node, ast.compilerVersion);
  const memoryType = dereferenceType(type);

  if (node instanceof TupleExpression) {
    node.vOriginalComponents.forEach((exp) => {
      if (exp !== null) {
        collectDynArrayExpressions(exp, retMap, ast);
      }
    });
  } else if (
    type instanceof PointerType &&
    memoryType instanceof ArrayType &&
    memoryType.size === undefined &&
    !(dereferenceType(memoryType.elementT) instanceof ArrayType)
  ) {
    retMap.set(node, memoryType);
  }
  // returnStatement
  //   .getChildren(true)
  //   .filter((n) => n instanceof Expression)
  //   .filter((n): n is Expression => {
  //     assert(n instanceof Expression);
  //     // Put not supported error here if n is variableDeclaration
  //     const typeNode = getNodeType(n, ast.compilerVersion);
  //     const derefTypeNode = dereferenceType(typeNode);
  //     return (
  //       n instanceof Expression &&
  //       // We want a PointerType because it is pointing to the DynamicArray in memory.
  //       typeNode instanceof PointerType &&
  //       typeNode.location === DataLocation.Memory &&
  //       derefTypeNode instanceof ArrayType &&
  //       derefTypeNode.size === undefined &&
  //       // Add error here that we dont support DynamicArrays of DynamicArrays/Arrays
  //       !(dereferenceType(derefTypeNode.elementT) instanceof ArrayType)
  //     );
  //   })
  //   .forEach((n) => {
  //     retMap.set(n, dereferenceType(getNodeType(n, ast.compilerVersion)));
  //   });

  return retMap;
}
