import { DataLocation, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { collectUnboundVariables } from '../../utils/functionGeneration';
import { CALLDATA_TO_MEMORY_FUNCTION_PARAMETER_PREFIX } from '../../utils/nameModifiers';
import { createIdentifier, createVariableDeclarationStatement } from '../../utils/nodeTemplates';
import { isDynamicArray, isReferenceType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../../utils/utils';

export class RefTypeModifier extends ASTMapper {
  /*
  This pass filters the inputParameters of FunctionDefintions for reference types sitting in 
  memory that are not DynArrays. 
  
  The original dataLocation of each of the filtered VariableDeclarations is then set to CallData.
  
  A VariableDeclarationStatement is then inserted into the beginning of the fuction body with a 
  cloned VariableDeclaration with the DataLocation set to Memory and the initialValue being an 
  Identifier referencing the original VariableDeclaration in the Parameter list, 
  with the DataLocation as CallData. 

  This will trigger the dataAccessFunctionalizer to insert the necccessary write UtilGens from 
  CallDataToMemory.

  Before pass:

  struct structDef {
    uint8 member1;
    uint8 member2;
  }

  function testReturnMember(structDef memory structA) pure external returns (uint8) {
    return structA.member1;
  }
  
  After pass:

  function testReturnMember(structDef calldata structA) external pure returns (uint8) {
      structDef memory __warp_usrid2_structA_mem = structA;
      return __warp_usirid1_structA.__warp_usrid0_member1;
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
            isReferenceType(safeGetNodeType(decl, ast.compilerVersion)) &&
            !isDynamicArray(safeGetNodeType(decl, ast.compilerVersion)),
        )
        .forEach(([decl, ids]) => {
          const wmDecl = cloneASTNode(decl, ast);
          wmDecl.name = wmDecl.name + CALLDATA_TO_MEMORY_FUNCTION_PARAMETER_PREFIX;
          decl.storageLocation = DataLocation.CallData;
          const varDeclStatement = createVariableDeclarationStatement(
            [wmDecl],
            createIdentifier(decl, ast),
            ast,
          );
          body.insertAtBeginning(varDeclStatement);
          ids.forEach((id) => ast.replaceNode(id, createIdentifier(wmDecl, ast)));
        });
      ast.setContextRecursive(node);
    }
    this.commonVisit(node, ast);
  }
  // Change the other instance of this function to isDynamicMemoryArrayRef
}
