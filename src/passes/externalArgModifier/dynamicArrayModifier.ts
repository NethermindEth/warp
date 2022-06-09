import assert = require('assert');

import {
  DataLocation,
  FunctionCall,
  FunctionDefinition,
  getNodeType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { collectUnboundVariables } from '../../utils/functionGeneration';
import { createIdentifier, createVariableDeclarationStatement } from '../../utils/nodeTemplates';
import { isDynamicArray } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../../utils/utils';

export class DynArrayModifier extends ASTMapper {
  /*
  This pass will generate the solidity nodes that are needed pass dynamic memory
  arrays into external functions.

  Externally passed dynArrays in Cairo are 2 arguments while in Solidity they are 
  1. This means a work around is needed for handelling them. The dynArray is 
  converted into a struct that holds its two members (len and ptr). The Identifiers 
  that reference the original dynArray are now replaced with ones that reference 
  the struct. ie dArray[1] -> dArray_struct.ptr[1]. This struct has storageLocation 
  CallData.

  The above happens irrespective of whether the a dynArray is declared to be in 
  Memory or CallData. If the original dynArray is in Memory an additional 
  VariableDeclarationStatement is inserted at the beginning of the function body 
  with the VariableDeclaration dataLocation in memory and the intialValue being 
  an indentifer that references the dynArray_struct. This will trigger the write 
  in the dataAccessFunctionalizer and will use the appropriate functions to write 
  the calldata struct containing the dynArray to Memory. Once again all the 
  Identifiers that refer to the orignal dynArray are replaced with the identifiers 
  that reference the VariableDeclaration.
  
  Notes on the CallData Struct Constuction:
  The dynArray is passed to a StructConstructor FunctionCall that has 1 argument. 
  The FunctionDefinition it references is as Stub that takes 1 argument and is 
  never written. What is written is a StructDefintition with two members. 
  
  Only once the cairoWriter is reached is the single argument in the 
  ParameterListWriter and FunctionCallWriter split into two. 
  All of this is to pass the sanity check that is run post transforming the AST.

  Before Pass:

  function dArrayMemory(uint8[] memory x) pure public returns (uint8[] memory) {
    return x;
  }
  
  function dArrayCalldata(uint8[] calldata x) pure public returns (uint8 calldata) {
    return x;
    } 

  After Pass:

  function dArrayMemory(uint8[] calldata x) pure public returns (uint8[] memory) {
    uint8[] calldata x_dstruct = cd_dynarray_felt(x);
    uint8[] memory x_mem = x_dstruct;
    return x_mem;
  }

  function dArrayCalldata(uint8[] calldata x) external pure returns (uint8[] calldata) {
    uint8[] calldata x_dstruct = cd_dynarray_felt(x);
    return x_dstruct;
  }
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
            isDynamicArray(getNodeType(decl, ast.compilerVersion)),
        )
        .forEach(([varDecl, ids]) => {
          // Irrespective of the whether the storage location is Memory or Calldata a struct is created to store the len & ptr
          // Note the location of this struct is in CallData.
          const dArrayStruct = cloneASTNode(varDecl, ast);
          dArrayStruct.name = dArrayStruct.name + '_dstruct';
          dArrayStruct.storageLocation = DataLocation.CallData;
          const structConstructorCall = this.genStructConstructor(varDecl, node, ast);
          const structArrayStatement = createVariableDeclarationStatement(
            [dArrayStruct],
            structConstructorCall,
            ast,
          );
          body.insertAtBeginning(structArrayStatement);
          ast.setContextRecursive(structArrayStatement);
          assert(structConstructorCall.vReferencedDeclaration instanceof CairoFunctionDefinition);
          if (varDecl.storageLocation === DataLocation.Memory) {
            const memoryArray = cloneASTNode(varDecl, ast);
            memoryArray.name = memoryArray.name + '_mem';
            const memArrayStatement = createVariableDeclarationStatement(
              [memoryArray],
              createIdentifier(dArrayStruct, ast),
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

  private genStructConstructor(
    dArrayVarDecl: VariableDeclaration,
    node: FunctionDefinition,
    ast: AST,
  ): FunctionCall {
    const structConstructor = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayStructConstructor.gen(dArrayVarDecl, node);
    assert(structConstructor !== undefined);
    return structConstructor;
  }
}
