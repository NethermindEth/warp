import assert = require('assert');
import {
  ArrayTypeName,
  ContractDefinition,
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
    `struct ${contract?.name}.dynarray_struct_${key} memory`,
    FunctionCallKind.StructConstructorCall,
    new Identifier(
      ast.reserveId(),
      '',
      `type(struct ${contract?.name}.dynarray_struct_${key} storage pointer)`,
      structDef.name,
      structDef.id,
    ),
    [createIdentifier(varDecl, ast)],
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

  const structDef = new CairoStructDefinitionStub(
    structDefId,
    '',
    `dynarray_struct_${key}`,
    sourceUnit.id,
    FunctionVisibility.Internal,
    [cloneASTNode(dArrayVarDecl, ast)],
    false,
  );

  ast.setContextRecursive(structDef);
  sourceUnit.insertAtBeginning(structDef);

  return structDef;
}
