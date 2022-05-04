// import assert = require('assert');

//import { splitDarray } from '../../utils/utils';
import {
  ArrayTypeName,
  // Block,
  // ContractDefinition,
  DataLocation,
  Expression,
  FunctionCall,
  // ElementaryTypeName,
  // FunctionCall,
  // FunctionCallKind,
  FunctionDefinition,
  // Identifier,
  // Mutability,
  // StateVariableVisibility,
  // StructDefinition,
  // typeNameToTypeNode,
  // UserDefinedTypeName,
  // Mutability,
  // StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { isExternallyVisible } from '../../utils/utils';
import { collectUnboundVariables } from '../loopFunctionaliser/utils';
//import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';

export class DynArrayModifier extends ASTMapper {
  /*
  This pass will generate the functions that are needed to load externally passed dynamic memory arrays into our WARP memory system.

  To get the dArray into the memory system a VariableDeclarationStatement is placed at the beginning of the function block.
  In the VariableDeclarationStatment there is a new Variable declared that has the same name of the original dArray with the suffix _mem 
  and on the right of the assignment is a CarioUtil functionCall.
  
  After this VariableDeclarationStatement is inserted all the Identifiers that reference the old dArray are replaced with those that 
  reference the new dArray with _mem suffix.

  The old dArray is not split into the two seperate VariableDeclarations that Cairo expects, instead it is kept as a single node and
  then when the CairoWriter is writing out the Identifier it will be split in two.

  before pass:
  function test(uint[] memory x, uint8[] calldata y, uint[] memory z) pure external returns (uint) {
    return x[0] + y[0] + z[0];
  }

  after pass:

  struct wm_dynarray_Uint256 {
  }

  function test(uint[] memory x, uint8[] memory y, uint[] memory z) pure external returns (uint) {
    uint[] memory z_mem = wm_dynarray_alloc_Uint256(z)
    uint8[] memory y_mem = wm_dynarray_alloc_felt(y) 
    uint[] memory x_mem = wm_dynarray_alloc_Uint256(x)
    return x_mem[0] + y_mem[0] + z_mem[0];
    
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

          if (varDecl.storageLocation === DataLocation.Memory) {
            const allocatorFuctionCall = this.genDarrayAllocatorWriter(node, dArrayStruct, ast);
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
            node.vBody?.insertAtBeginning(memArrayStatement);
          } else {
            ids.forEach((identifier) =>
              ast.replaceNode(
                identifier,
                createIdentifier(dArrayStruct, ast, DataLocation.CallData),
              ),
            );
          }
          node.vBody?.insertAtBeginning(structArrayStatement);
          // The orignal VariableDeclaration needs to changed to having it's DataLocation in CallData
          // otherwise a memory read is inserted in the function body.
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
      .externalFunctions.inputs.darrayStructBuilder.gen(dArrayVarDecl, node);
    return structConstructor;
  }

  private genDarrayAllocatorWriter(
    node: FunctionDefinition,
    darrayStruct: VariableDeclaration,
    ast: AST,
  ): FunctionCall {
    const alloctorFunctionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayAllocator.gen(node, darrayStruct);
    ast.getUtilFuncGen(node).externalFunctions.inputs.darrayWriter.gen(darrayStruct);

    return alloctorFunctionCall;
  }
}
