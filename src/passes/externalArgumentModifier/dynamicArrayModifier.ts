// import assert = require('assert');
import {
  ArrayTypeName,
  DataLocation,
  // ElementaryTypeName,
  FunctionDefinition,
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

export class DynamicArrayModifier extends ASTMapper {
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
  function test(uint[] memory x, uint8[] memory y, uint[] memory z) pure external returns (uint) {
    return x[0] + y[0] + z[0];
  }

  after pass:

  function test(uint[] memory x, uint8[] memory y, uint[] memory z) pure external returns (uint) {
    uint[] memory z_mem = wm_dynarray_alloc_Uint256(z)
    uint8[] memory y_mem = wm_dynarray_alloc_felt(y) 
    uint[] memory x_mem = wm_dynarray_alloc_Uint256(x)
    return x[0] + y[0] + z[0];
  }
  
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
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
          const memoryArray = cloneASTNode(varDecl, ast);
          memoryArray.name = memoryArray.name + '_mem';

          const varDeclStatement = this.createVariableDeclarationStatement(
            node,
            varDecl,
            memoryArray,
            ast,
          );

          node.vBody?.insertAtBeginning(varDeclStatement);

          ids.forEach((identifier) =>
            ast.replaceNode(identifier, createIdentifier(memoryArray, ast, DataLocation.Memory)),
          );
        });

      ast.setContextRecursive(node);

      this.commonVisit(node, ast);
    }
  }

  private createVariableDeclarationStatement(
    node: FunctionDefinition,
    originalVarDecl: VariableDeclaration,
    memoryArray: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const functionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.darrayAllocator.gen(node, originalVarDecl);
    ast.getUtilFuncGen(node).externalFunctions.inputs.darrayWriter.gen(originalVarDecl);
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
