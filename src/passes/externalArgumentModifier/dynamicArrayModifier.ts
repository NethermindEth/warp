// import assert = require('assert');

//import { splitDarray } from '../../utils/utils';
import {
  ArrayTypeName,
  // Block,
  // ContractDefinition,
  DataLocation,
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
          const wasMemory = varDecl.storageLocation === DataLocation.Memory;
          varDecl.storageLocation = DataLocation.CallData;
          const newStructDecl = cloneASTNode(varDecl, ast);
          newStructDecl.name = newStructDecl.name + '_dstruct';
          newStructDecl.storageLocation = DataLocation.Default;
          const structVarDeclStatemet = this.createStructVarDeclStatement(
            varDecl,
            newStructDecl,
            node,
            ast,
          );
          if (wasMemory) {
            const memoryArray = cloneASTNode(varDecl, ast);
            memoryArray.name = memoryArray.name + '_mem';
            memoryArray.storageLocation = DataLocation.Memory;
            const varDeclStatement = this.createDarrayAllocatorStatement(
              node,
              newStructDecl,
              memoryArray,
              ast,
            );
            ids.forEach((identifier) =>
              ast.replaceNode(identifier, createIdentifier(memoryArray, ast, DataLocation.Memory)),
            );
            node.vBody?.insertAtBeginning(varDeclStatement);
          } else {
            ids.forEach((identifier) =>
              ast.replaceNode(
                identifier,
                createIdentifier(newStructDecl, ast, DataLocation.CallData),
              ),
            );
          }
          node.vBody?.insertAtBeginning(structVarDeclStatemet);
        });

      ast.setContextRecursive(node);

      this.commonVisit(node, ast);
    }
  }

  private createStructVarDeclStatement(
    dArrayVarDecl: VariableDeclaration,
    newStructDecl: VariableDeclaration,
    node: FunctionDefinition,
    ast: AST,
  ): VariableDeclarationStatement {
    const structConstructor = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayStructBuilder.gen(dArrayVarDecl, node);
    const varDeclStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [newStructDecl.id],
      [newStructDecl],
      structConstructor,
    );
    return varDeclStatement;
  }

  private createDarrayAllocatorStatement(
    node: FunctionDefinition,
    darrayStruct: VariableDeclaration,
    memoryArray: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const functionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayAllocator.gen(node, darrayStruct);
    ast.getUtilFuncGen(node).externalFunctions.inputs.darrayWriter.gen(darrayStruct);
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
