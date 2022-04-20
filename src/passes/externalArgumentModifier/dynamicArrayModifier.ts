import assert = require('assert');
import {
  ArrayTypeName,
  DataLocation,
  ElementaryTypeName,
  FunctionDefinition,
  // Identifier,
  Mutability,
  replaceNode,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
  // IndexAccess,
  // Literal,
  // TupleExpression,
  // VariableDeclaration,
  // VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
// import { cloneASTNode } from '../../utils/cloning';
// import { createIdentifier, createUint256Literal } from '../../utils/nodeTemplates';
import { isExternallyVisible } from '../../utils/utils';
import { collectUnboundVariables } from '../loopFunctionaliser/utils';
// import { collectUnboundVariables } from '../loopFunctionaliser/utils';

export class DynamicArrayModifier extends ASTMapper {
  /*
  This pass will work by converting the dynamic arrays the function arguments into the name + suffix '_len' and then the pointer that has the name.
  The challenge is to find out how cairoPointers can be created.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    const nodesToBeReplaced = new Array<VariableDeclaration>();
    const nodesToBeAdded = new Array<Array<VariableDeclaration>>();
    if (isExternallyVisible(node) && body !== undefined) {
      [...collectUnboundVariables(body).entries()]
        .filter(
          ([decl]) =>
            node.vParameters.vParameters.includes(decl) &&
            decl.storageLocation === DataLocation.Memory &&
            decl.vType instanceof ArrayTypeName &&
            decl.vType.vLength === undefined,
        )
        .forEach(([varDecl, ids]) => {
          const [arrayLen, arrayPointer] = this.splitArguments(node, varDecl, ast);
          nodesToBeReplaced.push(varDecl);
          const replaceArgs = [arrayLen, arrayPointer];
          nodesToBeAdded.push(replaceArgs);

          const memoryArray = cloneASTNode(varDecl, ast);
          memoryArray.name = memoryArray.name + '_mem';

          const varDeclStatement = this.createVariableDeclarationStatement(
            node,
            varDecl,
            memoryArray,
            arrayLen,
            arrayPointer,
            ast,
          );

          node.vBody?.insertAtBeginning(varDeclStatement);

          ids.forEach((identifier) =>
            ast.replaceNode(identifier, createIdentifier(memoryArray, ast, DataLocation.Memory)),
          );
        });
      //============
      // node.vParameters.vParameters.forEach((varDecl) => {
      //   if (
      //     varDecl.storageLocation === DataLocation.Memory &&
      //     varDecl.vType instanceof ArrayTypeName &&
      //     varDecl.vType.vLength === undefined
      //   ) {
      //     const [arrayLen, arrayPointer] = this.splitArguments(node, varDecl, ast);
      //     nodesToBeReplaced.push(varDecl);
      //     const replaceArgs = [arrayLen, arrayPointer];
      //     nodesToBeAdded.push(replaceArgs);

      //     const memoryArray = cloneASTNode(varDecl, ast);
      //     memoryArray.name = memoryArray.name + '_mem';

      //     const varDeclStatement = this.createVariableDeclarationStatement(
      //       node,
      //       varDecl,
      //       memoryArray,
      //       arrayLen,
      //       arrayPointer,
      //       ast,
      //     );

      //     node.vBody?.insertAtBeginning(varDeclStatement);
      //   }
      // });
      //============================================
      // This is under dev and can look better.
      if (nodesToBeReplaced.length > 0) {
        nodesToBeReplaced.map((varDecl, i) => {
          //Can just use insert before and after and then remove the node.
          ast.setContextRecursive(nodesToBeAdded[i][0]);
          ast.setContextRecursive(nodesToBeAdded[i][1]);
          //replaceNode(varDecl, nodesToBeAdded[i][0]);
          node.vParameters.insertAfter(nodesToBeAdded[i][0], varDecl);
          node.vParameters.insertAfter(nodesToBeAdded[i][1], nodesToBeAdded[i][0]);
          node.vParameters.removeChild(varDecl);
          //node.vParameters.appendChild(nodesToBeAdded[i][0]);
        });
        // ast.setContextRecursive(node.vParameters);
        ast.setContextRecursive(node);
      }

      this.commonVisit(node, ast);
    }
  }
  private splitArguments(
    node: FunctionDefinition,
    varDecl: VariableDeclaration,
    ast: AST,
  ): [VariableDeclaration, VariableDeclaration] {
    assert(varDecl.vType !== undefined);
    const typeStringArrayLen = varDecl.typeString.replace('[]', '');
    const lenVarDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true,
      false,
      varDecl.name + '_len',
      node.id,
      false,
      DataLocation.Default,
      StateVariableVisibility.Internal,
      Mutability.Immutable,
      typeStringArrayLen,
      undefined,
      new ElementaryTypeName(ast.reserveId(), '', typeStringArrayLen, typeStringArrayLen),
      undefined,
    );

    const pointerVarDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true,
      false,
      varDecl.name,
      node.id,
      false,
      DataLocation.CallData,
      StateVariableVisibility.Internal,
      Mutability.Immutable,
      varDecl.typeString + ' calldata',
      undefined,
      cloneASTNode(varDecl.vType, ast),
    );
    return [lenVarDecl, pointerVarDecl];
  }

  private createVariableDeclarationStatement(
    node: FunctionDefinition,
    originalVarDecl: VariableDeclaration,
    memoryArray: VariableDeclaration,
    arrayLen: VariableDeclaration,
    arrayPointer: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const functionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.dynArray.gen(node, originalVarDecl, arrayLen, arrayPointer);

    const varDeclStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [memoryArray.id],
      [memoryArray],
      functionCall,
    );
    return varDeclStatement;
  }
}
// private createVariableDeclarationStatement(
//   calldataArray: VariableDeclaration,
//   memoryArray: VariableDeclaration,
//   ast: AST,
// ): VariableDeclarationStatement {
//   const structDeclarationStatement = new VariableDeclarationStatement(
//     ast.reserveId(),
//     '',
//     [memoryArray.id],
//     [memoryArray],
//     this.createTupleExpression(calldataArray, memoryArray, ast),
//   );
//   return structDeclarationStatement;
// }

// private createTupleExpression(
//   calldataArray: VariableDeclaration,
//   memoryArray: VariableDeclaration,
//   ast: AST,
// ): TupleExpression {
//   assert(calldataArray.vType instanceof ArrayTypeName);
//   const indexAccessArray = this.createIndexAccessArray(calldataArray, calldataArray.vType, ast);
//   const newTupleExpression = new TupleExpression(
//     ast.reserveId(),
//     '',
//     memoryArray.typeString,
//     true,
//     indexAccessArray,
//   );
//   return newTupleExpression;
// }

// private createIndexAccessArray(
//   calldataArray: VariableDeclaration,
//   arrayDef: ArrayTypeName,
//   ast: AST,
// ): IndexAccess[] {
//   assert(arrayDef.vLength instanceof Literal);
//   // Make sure to check if there are more than 252
//   return mapRange(
//     Number(arrayDef.vLength.value),
//     (i) =>
//       new IndexAccess(
//         ast.reserveId(),
//         '',
//         arrayDef.vBaseType.typeString,
//         createIdentifier(calldataArray, ast, calldataArray.storageLocation),
//         createUint256Literal(BigInt(i), ast),
//       ),
//   );
// }
