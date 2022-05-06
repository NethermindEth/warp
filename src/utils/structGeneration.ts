import assert = require('assert');
import {
  ArrayTypeName,
  ContractDefinition,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionVisibility,
  Identifier,
  StructDefinition,
  typeNameToTypeNode,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoStructDefinitionStub } from '../ast/cairoNodes';
import { CairoType, TypeConversionContext } from './cairoTypeSystem';
import { cloneASTNode } from './cloning';
import { createIdentifier } from './nodeTemplates';

export function createCallToStructConstuctor(
  structDef: StructDefinition,
  varDecl: VariableDeclaration,
  ast: AST,
  node: FunctionDefinition,
): FunctionCall {
  assert(varDecl.vType instanceof ArrayTypeName);

  const elementCairoType = CairoType.fromSol(
    typeNameToTypeNode(varDecl.vType.vBaseType),
    ast,
    TypeConversionContext.MemoryAllocation,
  );
  const key = elementCairoType.toString();
  const contract = node.getClosestParentByType(ContractDefinition);
  return new FunctionCall(
    ast.reserveId(),
    '',
    // This struct is then written into calldata (This is technically not correct)
    `struct ${contract?.name}.dynarray_struct_${key} calldata`,
    FunctionCallKind.StructConstructorCall,
    new Identifier(
      ast.reserveId(),
      '',
      `type(struct ${contract?.name}.dynarray_struct_${key} storage pointer)`,
      structDef.name,
      structDef.id,
    ),
    // This is Calldata since that the end of the pass that calls this function all dynamic arrays.
    // should be in calldata.
    [createIdentifier(varDecl, ast, DataLocation.CallData)],
  );
}

export function createCairoStructConstructorStub(
  dArrayVarDecl: VariableDeclaration,
  ast: AST,
): CairoStructDefinitionStub {
  const sourceUnit = ast.getContainingRoot(dArrayVarDecl);
  const structDefId = ast.reserveId();
  assert(dArrayVarDecl.vType instanceof ArrayTypeName);

  const elementCairoType = CairoType.fromSol(
    typeNameToTypeNode(dArrayVarDecl.vType.vBaseType),
    ast,
    TypeConversionContext.MemoryAllocation,
  );
  const key = elementCairoType.toString();
  // Even though this is impossible it should still work.
  const member = cloneASTNode(dArrayVarDecl, ast);
  member.storageLocation = DataLocation.CallData;
  const structDef = new CairoStructDefinitionStub(
    structDefId,
    '',
    `dynarray_struct_${key}`,
    sourceUnit.id,
    FunctionVisibility.Internal,
    [member],
    false,
  );

  ast.setContextRecursive(structDef);
  sourceUnit.insertAtBeginning(structDef);

  return structDef;
}
