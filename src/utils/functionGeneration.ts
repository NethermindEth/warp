import {
  ASTNode,
  DataLocation,
  Expression,
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
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { Implicits } from './implicits';
import { createParameterList } from './nodeTemplates';
import { getFunctionTypeString, getReturnTypeString } from './utils';

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
    FunctionStateMutability.NonPayable,
    false,
    createParameterList(createParameters(inputs), ast),
    createParameterList(createParameters(returns), ast),
    [],
    new Set(implicits),
    true,
  );

  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);

  return funcDef;
}
