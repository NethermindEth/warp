import {
  Assignment,
  ASTNode,
  DataLocation,
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
  StructDefinition,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../ast/cairoNodes';
import { getFunctionTypeString, getReturnTypeString, getStructTypeString } from './getTypeString';
import { Implicits } from './implicits';
import { createIdentifier, createParameterList } from './nodeTemplates';
import { toSingleExpression } from './utils';

export function createCallToFunction(
  functionDef: FunctionDefinition,
  argList: Expression[],
  ast: AST,
): FunctionCall {
  return new FunctionCall(
    ast.reserveId(),
    '',
    getReturnTypeString(functionDef),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      getFunctionTypeString(functionDef, ast.compilerVersion),
      functionDef.name,
      functionDef.id,
    ),
    argList,
  );
}

export function createStructConstructorCall(
  structDef: StructDefinition,
  argList: Expression[],
  ast: AST,
) {
  return new FunctionCall(
    ast.reserveId(),
    '',
    getStructTypeString(structDef),
    FunctionCallKind.StructConstructorCall,
    new Identifier(
      ast.reserveId(),
      '',
      getStructTypeString(structDef),
      structDef.name,
      structDef.id,
    ),
    argList,
  );
}

export function createCairoFunctionStub(
  name: string,
  inputs: ([string, TypeName] | [string, TypeName, DataLocation])[],
  returns: ([string, TypeName] | [string, TypeName, DataLocation])[],
  implicits: Implicits[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
  mutability: FunctionStateMutability = FunctionStateMutability.NonPayable,
  functionStubKind: FunctionStubKind = FunctionStubKind.FunctionDefStub,
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
    mutability,
    false,
    createParameterList(createParameters(inputs), ast),
    createParameterList(createParameters(returns), ast),
    [],
    new Set(implicits),
    functionStubKind,
  );

  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);

  return funcDef;
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
