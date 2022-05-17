import assert = require('assert');

import {
  // ArrayType,
  ArrayTypeName,
  ASTNode,
  // Block,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  // getNodeType,
  Identifier,
  Return,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
// import { fileURLToPath } from 'url';
// import { isDataView } from 'util/types';
import { AST } from '../../ast/ast';
// import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { isExternallyVisible } from '../../utils/utils';

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
    if (isExternallyVisible(node) && body !== undefined && body.lastChild instanceof Return) {
      const returnStatement = body.lastChild;
      [...collectDynArrayVariables(node).entries()]
        .filter(([decl]) => decl.storageLocation === DataLocation.Memory)
        .forEach(([varDecl, ids]) => {
          const dArrayStruct = cloneASTNode(varDecl, ast);
          dArrayStruct.name = dArrayStruct.name + '_ret_struct';
          dArrayStruct.storageLocation = DataLocation.CallData;

          this.genStructConstructor(dArrayStruct, node, ast);

          ids.forEach((id) => {
            const intialValue = cloneASTNode(id, ast);
            const structArrayStatement = this.createVariableDeclarationStatemet(
              dArrayStruct,
              intialValue,
              ast,
            );
            const replaceIdentifier = createIdentifier(dArrayStruct, ast);
            body.insertBefore(structArrayStatement, returnStatement);
            ast.replaceNode(id, replaceIdentifier);
          });
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
      ast.setContextRecursive(node);
    }
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

export function collectDynArrayVariables(
  node: FunctionDefinition,
): Map<VariableDeclaration, Identifier[]> {
  const variableDeclarations = node
    .getChildren(true)
    .filter((n) => n instanceof VariableDeclaration);

  const body = node.vBody;
  assert(body !== undefined);
  const returnStatement = body.lastChild;
  assert(returnStatement !== undefined);

  const returnIdentifiers = returnStatement
    .getChildren(true)
    .filter((n): n is Identifier => n instanceof Identifier)
    .map((id): [Identifier, ASTNode | undefined] => [id, id.vReferencedDeclaration])
    .filter(
      (pair: [Identifier, ASTNode | undefined]): pair is [Identifier, VariableDeclaration] =>
        pair[1] !== undefined &&
        pair[1] instanceof VariableDeclaration &&
        variableDeclarations.includes(pair[1]) &&
        pair[1].vType instanceof ArrayTypeName &&
        pair[1].vType.vLength === undefined,
    );

  const retMap: Map<VariableDeclaration, Identifier[]> = new Map();

  returnIdentifiers.forEach(([id, decl]) => {
    const existingEntry = retMap.get(decl);
    if (existingEntry === undefined) {
      retMap.set(decl, [id]);
    } else {
      retMap.set(decl, [id, ...existingEntry]);
    }
  });

  return retMap;
}
