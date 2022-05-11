import assert = require('assert');

import {
  ArrayTypeName,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  Return,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
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
    const val = node.vReturnParameters.vParameters.some(
      (varDecl) =>
        varDecl.storageLocation === DataLocation.Memory &&
        varDecl.vType instanceof ArrayTypeName &&
        varDecl.vType.vLength === undefined,
    );
    if (isExternallyVisible(node) && body !== undefined && val) {
      // If there is a dynarray in the return parameter list. We go straight to the return expression.
      // We loop through and see which ones are dyn arrays and then perform the opperations on them.
      const returnStatement = body.lastChild;
      // This needs to be changed Identifier
      assert(returnStatement instanceof Return);
      // Note this is not the case if there is a tuple expression or some other expression.
      // e.g FunctionCall or Tuple Expression.
      const retIdentifier = returnStatement.vExpression;
      assert(retIdentifier instanceof Identifier);
      assert(retIdentifier.vReferencedDeclaration instanceof VariableDeclaration);
      const dArrayStruct = cloneASTNode(retIdentifier.vReferencedDeclaration, ast);
      dArrayStruct.name = dArrayStruct.name + '_ret_struct';
      dArrayStruct.storageLocation = DataLocation.CallData;
      //////
      this.genStructConstructor(dArrayStruct, node, ast);
      //////
      const intialValue = cloneASTNode(retIdentifier, ast);
      const structArrayStatement = this.createVariableDeclarationStatemet(
        dArrayStruct,
        intialValue,
        ast,
      );
      const replaceIdentifier = createIdentifier(dArrayStruct, ast);
      body.insertBefore(structArrayStatement, returnStatement);
      ast.replaceNode(retIdentifier, replaceIdentifier);
      ast.setContextRecursive(node);
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
