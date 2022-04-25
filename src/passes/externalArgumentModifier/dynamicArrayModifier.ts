import assert = require('assert');
import {
  ArrayTypeName,
  DataLocation,
  ElementaryTypeName,
  FunctionDefinition,
  Mutability,
  StateVariableVisibility,
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
  This pass will generate the functions that are needed to load dynamic memory arrays into our WARP memory system.

  This pass splits the single dArray VariableDeclaration into two seperate VariableDeclarations the first being a
  felt that holds the length of the dArray and the second being the pointer that points to the array containing the objects.

  Once these VariableDeclarations are created a CairoUtilFuncGen function is called that generates a function that takes in
  the 2 new VariableDeclarations and loop over the values loading them into our memory system. This function will return the
  location of the the beginning of the array.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    const nodeToReplacements = new Map<VariableDeclaration, VariableDeclaration[]>();
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
          const [arrayLen, arrayPointer] = this.splitArguments(node, varDecl, ast);
          const replaceArgs = [arrayLen, arrayPointer];
          nodeToReplacements.set(varDecl, replaceArgs);

          const memoryArray = cloneASTNode(varDecl, ast);
          memoryArray.name = memoryArray.name + '_mem';

          const varDeclStatement = this.createVariableDeclarationStatement(
            node,
            varDecl,
            memoryArray,
            arrayLen,
            arrayPointer,
            ast,
          );

          node.vBody?.insertAtBeginning(varDeclStatement);

          ids.forEach((identifier) =>
            ast.replaceNode(identifier, createIdentifier(memoryArray, ast, DataLocation.Memory)),
          );
        });

      [...nodeToReplacements.keys()].forEach((varDecl) => {
        const replacements = nodeToReplacements.get(varDecl);
        assert(replacements !== undefined);

        ast.setContextRecursive(replacements[0]);
        ast.setContextRecursive(replacements[1]);

        node.vParameters.insertAfter(replacements[0], varDecl);
        node.vParameters.insertAfter(replacements[1], replacements[0]);
        node.vParameters.removeChild(varDecl);
      });

      ast.setContextRecursive(node);

      this.commonVisit(node, ast);
    }
  }
  private splitArguments(
    node: FunctionDefinition,
    varDecl: VariableDeclaration,
    ast: AST,
  ): [arrayLen: VariableDeclaration, arrayPointer: VariableDeclaration] {
    assert(varDecl.vType !== undefined);
    const typeStringArrayLen = varDecl.typeString.replace('[]', '');
    const lenVarDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true,
      false,
      varDecl.name + '_len',
      node.id,
      false,
      DataLocation.Default,
      StateVariableVisibility.Internal,
      Mutability.Immutable,
      'uint8',
      undefined,
      new ElementaryTypeName(ast.reserveId(), '', 'uint8', 'uint8'),
      undefined,
    );
    const pointerTypeString = cloneASTNode(varDecl.vType, ast);
    pointerTypeString.typeString = pointerTypeString.typeString + ' calldata';
    const pointerVarDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true,
      false,
      varDecl.name,
      node.id,
      false,
      DataLocation.CallData,
      StateVariableVisibility.Internal,
      Mutability.Immutable,
      varDecl.typeString + ' calldata',
      undefined,
      pointerTypeString,
    );
    return [lenVarDecl, pointerVarDecl];
  }

  private createVariableDeclarationStatement(
    node: FunctionDefinition,
    originalVarDecl: VariableDeclaration,
    memoryArray: VariableDeclaration,
    arrayLen: VariableDeclaration,
    arrayPointer: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const functionCall = ast
      .getUtilFuncGen(node)
      .externalFunctions.inputs.dynArrayAllocator.gen(
        node,
        originalVarDecl,
        arrayLen,
        arrayPointer,
      );
    ast.getUtilFuncGen(node).externalFunctions.inputs.dynArrayLoader.gen(arrayPointer);
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
