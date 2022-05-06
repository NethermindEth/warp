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
  This pass will generate the functions that are needed to load externally dynamic memory arrays into our WARP memory system.

  Irrespective of whether a dynArray is declared to be in Memory or CallData the first step is the same. The dynArray is passed to a StructConstructor
  that will have 1 member. This structConstructor references a stub which will not be written.
  This is to pass the sanity check, but when it is written in the CairoWriter it will be a struct with 2 members,
  the len and pointer (the same way that cairo handles external DynArrays). When the dynarray identifier is written in the CarioWriter it
  will also be split into its length and pointer members.

  If the dynArray is in memory the struct will then be passed into the wm_dynarray_alloc which will write the dynarray to memory using the
  struct members.

  If the dynArray is CallData used further in the function then the ptr member of the struct will be used as the BaseExpression in any IndexAccess.
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
          // const wasMemory = varDecl.storageLocation === DataLocation.Memory;
          // Irrespective of the whether the storage location is Memory or Calldata a struct is created to store the len & ptr
          const dArrayStruct = cloneASTNode(varDecl, ast);
          dArrayStruct.name = dArrayStruct.name + '_dstruct';
          dArrayStruct.storageLocation = DataLocation.Default;
          const structConstructorCall = this.genStructConstructor(varDecl, node, ast);
          const structArrayStatement = this.createVariableDeclarationStatemet(
            dArrayStruct,
            structConstructorCall,
            ast,
          );
          node.vBody?.insertAtBeginning(structArrayStatement);
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
            node.vBody?.insertAfter(memArrayStatement, structArrayStatement);
          } else {
            ids.forEach((identifier) =>
              ast.replaceNode(
                identifier,
                createIdentifier(dArrayStruct, ast, DataLocation.CallData),
              ),
            );
          }
          // The orignal VariableDeclaration needs to changed to having it's DataLocation in CallData
          // otherwise a memory read is inserted in the function body.
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
