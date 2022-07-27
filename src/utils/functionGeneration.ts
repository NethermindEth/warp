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
  getNodeType,
  Identifier,
  Mutability,
  StateVariableVisibility,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { getFunctionTypeString, getReturnTypeString } from './getTypeString';
import { Implicits } from './implicits';
import { createIdentifier, createParameterList } from './nodeTemplates';
import { isDynamicArray } from './nodeTypeProcessing';
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
      getFunctionTypeString(functionDef, ast.compilerVersion, nodeInSourceUnit),
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

export function createCairoFunctionStub(
  name: string,
  inputs: ([string, TypeName] | [string, TypeName, DataLocation])[],
  returns: ([string, TypeName] | [string, TypeName, DataLocation])[],
  implicits: Implicits[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
  options: CairoFunctionStubOptions = {
    mutability: FunctionStateMutability.NonPayable,
    stubKind: FunctionStubKind.FunctionDefStub,
    acceptsRawDArray: false,
    acceptsUnpackedStructArray: false,
  },
): CairoFunctionDefinition {
  const sourceUnit = ast.getContainingRoot(nodeInSourceUnit);
  const funcDefId = ast.reserveId();
  const createParameters = (inputs: ([string, TypeName] | [string, TypeName, DataLocation])[]) =>
    inputs.map(
      ([name, type, location]) =>
        new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          name,
          funcDefId,
          false,
          location ?? DataLocation.Default,
          StateVariableVisibility.Private,
          Mutability.Mutable,
          type.typeString,
          undefined,
          type,
        ),
    );

  const funcDef = new CairoFunctionDefinition(
    funcDefId,
    '',
    sourceUnit.id,
    FunctionKind.Function,
    name,
    false,
    FunctionVisibility.Private,
    options.mutability ?? FunctionStateMutability.NonPayable,
    false,
    createParameterList(createParameters(inputs), ast),
    createParameterList(createParameters(returns), ast),
    [],
    new Set(implicits),
    options.stubKind ?? FunctionStubKind.FunctionDefStub,
    options.acceptsRawDArray ?? false,
    options.acceptsUnpackedStructArray ?? false,
  );

  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);

  return funcDef;
}

export function createElementaryConversionCall(
  typeTo: ElementaryTypeName,
  expression: Expression,
  ast: AST,
): FunctionCall {
  const isDynArray = isDynamicArray(getNodeType(typeTo, ast.compilerVersion));
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
  const resultIdentifiers = variables.map((k) => createIdentifier(k, ast));
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
