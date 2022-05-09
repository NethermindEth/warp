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
