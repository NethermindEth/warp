import assert = require('assert');
import {
  ArrayTypeName,
  DataLocation,
  FunctionDefinition,
  IndexAccess,
  Literal,
  TupleExpression,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier, createUint256Literal } from '../../utils/nodeTemplates';
import { isExternallyVisible, mapRange } from '../../utils/utils';
import { collectUnboundVariables } from '../loopFunctionaliser/utils';

export class StaticArrayModifier extends ASTMapper {
  /*

  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    if (isExternallyVisible(node) && body !== undefined) {
      [...collectUnboundVariables(body).entries()]
        .filter(
          ([decl]) =>
            node.vParameters.vParameters.includes(decl) &&
            decl.storageLocation === DataLocation.Memory &&
            decl.vType instanceof ArrayTypeName,
        )
        .forEach(([varDecl, ids]) => {
          const memoryArray = cloneASTNode(varDecl, ast);
          memoryArray.name = memoryArray.name + '_mem';
          varDecl.storageLocation = DataLocation.CallData;
          const varDeclStatement = this.createVariableDeclarationStatement(
            varDecl,
            memoryArray,
            ast,
          );
          body.insertAtBeginning(varDeclStatement);
          ids.forEach((identifier) =>
            ast.replaceNode(
              identifier,
              createIdentifier(memoryArray, ast, memoryArray.storageLocation),
            ),
          );
        });
      ast.setContextRecursive(node);
    }
    this.commonVisit(node, ast);
  }

  private createVariableDeclarationStatement(
    calldataArray: VariableDeclaration,
    memoryArray: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const structDeclarationStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [memoryArray.id],
      [memoryArray],
      this.createTupleExpression(calldataArray, memoryArray, ast),
    );
    return structDeclarationStatement;
  }

  private createTupleExpression(
    calldataArray: VariableDeclaration,
    memoryArray: VariableDeclaration,
    ast: AST,
  ): TupleExpression {
    assert(calldataArray.vType instanceof ArrayTypeName);
    const indexAccessArray = this.createIndexAccessArray(calldataArray, calldataArray.vType, ast);
    const newTupleExpression = new TupleExpression(
      ast.reserveId(),
      '',
      memoryArray.typeString,
      true,
      indexAccessArray,
    );
    return newTupleExpression;
  }

  private createIndexAccessArray(
    calldataArray: VariableDeclaration,
    arrayDef: ArrayTypeName,
    ast: AST,
  ): IndexAccess[] {
    assert(arrayDef.vLength instanceof Literal);
    // Make sure to check if there are more than 252
    return mapRange(
      Number(arrayDef.vLength.value),
      (i) =>
        new IndexAccess(
          ast.reserveId(),
          '',
          arrayDef.vBaseType.typeString,
          createIdentifier(calldataArray, ast, calldataArray.storageLocation),
          createUint256Literal(BigInt(i), ast),
        ),
    );
  }
}
