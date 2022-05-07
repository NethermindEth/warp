import assert = require('assert');

import {
  ArrayTypeName,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { isExternallyVisible } from '../../utils/utils';
import { collectUnboundVariables } from '../loopFunctionaliser/utils';

export class DynArrayModifier extends ASTMapper {
  /*
  This pass will generate the functions that are needed to load externally passed dynamic memory arrays into our WARP memory system.

  Externally passed dynArrays in Cairo are 2 arguments while in Solidity they are 1. This means a work around is needed for handelling them.
  The dynArray is converted into a struct that holds its two members (len and ptr). The Identifiers that reference the original dynArray are
  now replaced with ones that reference the struct. ie dArray[1] -> dArray_struct.ptr[1]. This struct has storageLocation CallData.

  The above happens irrespective of whether the a dynArray is declared to be in Memory or CallData. If the original dynArray is in Memory the 
  struct created above will be passed into the wm_dynarray_alloc function which use the structs members to write the array to memory. Once 
  again all the Identifiers that refer to the orignal dynArray are replaced with the identifiers that reference the Variable created
  by the wm_dyarray_alloc function.
  
  Notes on the CallData Struct Constuction:
  The dynArray is passed to a StructConstructor FunctionCall that has 1 argument. The FunctionDefinition it references is
  as Stub that takes 1 argument and is never written. What is written is a StructDefintition with two members. 
  
  Only once the cairoWriter is reached is the single argument in the ParameterListWriter and FunctionCallWriter split into two. 
  All of this is to pass the sanity check that is run post transforming the AST.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    if (isExternallyVisible(node) && body !== undefined) {
      [...collectUnboundVariables(body).entries()]
        .filter(
          ([decl]) =>
            node.vParameters.vParameters.includes(decl) &&
            (decl.storageLocation === DataLocation.Memory ||
              decl.storageLocation == DataLocation.CallData) &&
            decl.vType instanceof ArrayTypeName &&
            decl.vType.vLength === undefined,
        )
        .forEach(([varDecl, ids]) => {
          // Irrespective of the whether the storage location is Memory or Calldata a struct is created to store the len & ptr
          // Note the location of this struct is in CallData.
          const dArrayStruct = cloneASTNode(varDecl, ast);
          dArrayStruct.name = dArrayStruct.name + '_dstruct';
          dArrayStruct.storageLocation = DataLocation.CallData;
          const structConstructorCall = this.genStructConstructor(varDecl, node, ast);
          const structArrayStatement = this.createVariableDeclarationStatemet(
            dArrayStruct,
            structConstructorCall,
            ast,
          );
          body.insertAtBeginning(structArrayStatement);
          ast.setContextRecursive(structArrayStatement);
          assert(structConstructorCall.vReferencedDeclaration instanceof CairoFunctionDefinition);
          if (varDecl.storageLocation === DataLocation.Memory) {
            const allocatorFuctionCall = this.genDarrayAllocatorWriter(
              node,
              dArrayStruct,
              structConstructorCall.vReferencedDeclaration,
              ast,
            );
            const memoryArray = cloneASTNode(varDecl, ast);
            memoryArray.name = memoryArray.name + '_mem';
            const memArrayStatement = this.createVariableDeclarationStatemet(
              memoryArray,
              allocatorFuctionCall,
              ast,
            );
            ids.forEach((identifier) =>
              ast.replaceNode(identifier, createIdentifier(memoryArray, ast, DataLocation.Memory)),
            );
            body.insertAfter(memArrayStatement, structArrayStatement);
          } else {
            ids.forEach((identifier) =>
              ast.replaceNode(
                identifier,
                createIdentifier(dArrayStruct, ast, DataLocation.CallData),
              ),
            );
          }
          // The orignal dynArray argument is changed to having it's DataLocation in CallData.
          // Now both the dynArray and the struct representing it are in CallData.
          ast.setContextRecursive(node);
          varDecl.storageLocation = DataLocation.CallData;
        });

      ast.setContextRecursive(node);

      this.commonVisit(node, ast);
    }
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

  private genDarrayAllocatorWriter(
    node: FunctionDefinition,
    darrayStruct: VariableDeclaration,
    structDef: CairoFunctionDefinition,
    ast: AST,
  ): FunctionCall {
    const alloctorFunctionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayAllocator.gen(node, darrayStruct, structDef);
    ast.getUtilFuncGen(node).externalFunctions.inputs.darrayWriter.gen(darrayStruct);

    return alloctorFunctionCall;
  }
}
