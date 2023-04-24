import {
  Assignment,
  ASTNode,
  DataLocation,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EventDefinition,
  Expression,
  ExpressionStatement,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Identifier,
  Mutability,
  StateVariableVisibility,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoImportFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { CairoGeneratedFunctionDefinition } from '../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { getFunctionTypeString, getReturnTypeString } from './getTypeString';
import { Implicits } from './utils';
import { createIdentifier, createParameterList } from './nodeTemplates';
import { isDynamicArray, safeGetNodeTypeInCtx } from './nodeTypeProcessing';
import { toSingleExpression } from './utils';

export function createCallToFunction(
  functionDef: FunctionDefinition,
  argList: Expression[],
  ast: AST,
  nodeInSourceUnit?: ASTNode,
): FunctionCall {
  return new FunctionCall(
    ast.reserveId(),
    '',
    getReturnTypeString(functionDef, ast, nodeInSourceUnit),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      getFunctionTypeString(functionDef, ast.inference, nodeInSourceUnit),
      functionDef.name,
      functionDef.id,
    ),
    argList,
  );
}

export function createCallToEvent(
  eventDef: EventDefinition,
  identifierTypeString: string,
  argList: Expression[],
  ast: AST,
) {
  return new FunctionCall(
    ast.reserveId(),
    '',
    'tuple()',
    FunctionCallKind.FunctionCall,
    new Identifier(ast.reserveId(), '', identifierTypeString, eventDef.name, eventDef.id),
    argList,
  );
}

interface CairoFunctionStubOptions {
  mutability?: FunctionStateMutability;
  stubKind?: FunctionStubKind;
  acceptsRawDArray?: boolean;
  acceptsUnpackedStructArray?: boolean;
}

export type ParameterInfo = [string, TypeName] | [string, TypeName, DataLocation];

export function createCairoGeneratedFunction(
  genFuncInfo: { name: string; code: string; functionsCalled: FunctionDefinition[] },
  inputs: ParameterInfo[],
  returns: ParameterInfo[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
  options: CairoFunctionStubOptions = {
    mutability: FunctionStateMutability.NonPayable,
    stubKind: FunctionStubKind.FunctionDefStub,
    acceptsRawDArray: false,
    acceptsUnpackedStructArray: false,
  },
): CairoGeneratedFunctionDefinition {
  const sourceUnit = ast.getContainingRoot(nodeInSourceUnit);
  const funcDefId = ast.reserveId();
  const funcDef = new CairoGeneratedFunctionDefinition(
    funcDefId,
    '',
    sourceUnit.id,
    FunctionKind.Function,
    genFuncInfo.name,
    FunctionVisibility.Private,
    options.mutability ?? FunctionStateMutability.NonPayable,
    createParameterList(createParameters(inputs, funcDefId, ast), ast),
    createParameterList(createParameters(returns, funcDefId, ast), ast),
    options.stubKind ?? FunctionStubKind.FunctionDefStub,
    genFuncInfo.code,
    genFuncInfo.functionsCalled,
    options.acceptsRawDArray,
    options.acceptsUnpackedStructArray,
  );

  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);

  return funcDef;
}

export function createCairoImportFunctionDefinition(
  funcName: string,
  path: string[],
  implicits: Set<Implicits>,
  params: ParameterInfo[],
  retParams: ParameterInfo[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
  options: CairoFunctionStubOptions = {
    acceptsRawDArray: false,
    acceptsUnpackedStructArray: false,
  },
): CairoImportFunctionDefinition {
  const sourceUnit = ast.getContainingRoot(nodeInSourceUnit);

  const id = ast.reserveId();
  const scope = sourceUnit.id;

  const funcDef = new CairoImportFunctionDefinition(
    id,
    '',
    scope,
    funcName,
    path,
    implicits,
    createParameterList(createParameters(params, id, ast), ast),
    createParameterList(createParameters(retParams, id, ast), ast),
    FunctionStubKind.FunctionDefStub,
    options.acceptsRawDArray,
    options.acceptsUnpackedStructArray,
  );
  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);
  return funcDef;
}

export function createCairoImportStructDefinition(
  structName: string,
  path: string[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
): CairoImportFunctionDefinition {
  const sourceUnit = ast.getContainingRoot(nodeInSourceUnit);

  const id = ast.reserveId();
  const scope = sourceUnit.id;

  const implicits = new Set<Implicits>();
  const params = createParameterList([], ast);
  const retParams = createParameterList([], ast);
  const funcDef = new CairoImportFunctionDefinition(
    id,
    '',
    scope,
    structName,
    path,
    implicits,
    params,
    retParams,
    FunctionStubKind.StructDefStub,
  );
  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);
  return funcDef;
}

function createParameters(
  inputs: ([string, TypeName] | [string, TypeName, DataLocation])[],
  funcDefId: number,
  ast: AST,
) {
  return inputs.map(
    ([name, type, location]) =>
      new VariableDeclaration(
        ast.reserveId(),
        '',
        false, // constant
        false, // indexed
        name,
        funcDefId,
        false, // stateVariable
        location ?? DataLocation.Default,
        StateVariableVisibility.Private,
        Mutability.Mutable,
        type.typeString,
        undefined,
        type,
      ),
  );
}

export function createElementaryConversionCall(
  typeTo: ElementaryTypeName,
  expression: Expression,
  context: ASTNode,
  ast: AST,
): FunctionCall {
  const isDynArray = isDynamicArray(safeGetNodeTypeInCtx(typeTo, ast.inference, context));
  const innerTypeString = isDynArray
    ? `type(${typeTo.typeString} storage pointer)`
    : `type(${typeTo.typeString})`;
  const outerTypeString = isDynArray ? `${typeTo.typeString} memory` : typeTo.typeString;

  const node = new FunctionCall(
    ast.reserveId(),
    '',
    outerTypeString,
    FunctionCallKind.TypeConversion,
    new ElementaryTypeNameExpression(ast.reserveId(), '', innerTypeString, typeTo),
    [expression],
  );
  ast.setContextRecursive(node);
  return node;
}

export function fixParameterScopes(node: FunctionDefinition): void {
  [...node.vParameters.vParameters, ...node.vReturnParameters.vParameters].forEach(
    (decl) => (decl.scope = node.id),
  );
}

export function createOuterCall(
  node: ASTNode,
  variables: VariableDeclaration[],
  functionToCall: FunctionCall,
  ast: AST,
): ExpressionStatement {
  const resultIdentifiers = variables.map((k) => createIdentifier(k, ast, undefined, node));
  const assignmentValue = toSingleExpression(resultIdentifiers, ast);

  return new ExpressionStatement(
    ast.reserveId(),
    node.src,
    resultIdentifiers.length === 0
      ? functionToCall
      : new Assignment(
          ast.reserveId(),
          '',
          assignmentValue.typeString,
          '=',
          assignmentValue,
          functionToCall,
        ),
    undefined,
    node.raw,
  );
}

export function collectUnboundVariables(node: ASTNode): Map<VariableDeclaration, Identifier[]> {
  const internalDeclarations = node
    .getChildren(true)
    .filter((n) => n instanceof VariableDeclaration);

  const unboundVariables = node
    .getChildren(true)
    .filter((n): n is Identifier => n instanceof Identifier)
    .map((id): [Identifier, ASTNode | undefined] => [id, id.vReferencedDeclaration])
    .filter(
      (pair: [Identifier, ASTNode | undefined]): pair is [Identifier, VariableDeclaration] =>
        pair[1] !== undefined &&
        pair[1] instanceof VariableDeclaration &&
        !internalDeclarations.includes(pair[1]),
    );

  const retMap: Map<VariableDeclaration, Identifier[]> = new Map();

  unboundVariables.forEach(([id, decl]) => {
    const existingEntry = retMap.get(decl);
    if (existingEntry === undefined) {
      retMap.set(decl, [id]);
    } else {
      retMap.set(decl, [id, ...existingEntry]);
    }
  });

  return retMap;
}
