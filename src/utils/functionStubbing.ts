import {
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Identifier,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { Implicits } from './implicits';
import { getFunctionTypeString, getReturnTypeString } from './utils';

export function createCairoFunctionStub(
  name: string,
  inputs: [string, TypeName][],
  returns: [string, TypeName][],
  implicits: Implicits[],
  ast: AST,
  nodeInSourceUnit: ASTNode,
): CairoFunctionDefinition {
  const sourceUnit = ast.getContainingRoot(nodeInSourceUnit);
  const funcDefId = ast.reserveId();
  const createParameters = (inputs: [string, TypeName][]) =>
    inputs.map(
      ([name, type]) =>
        new VariableDeclaration(
          ast.reserveId(),
          '',
          'VariableDeclaration',
          false,
          false,
          name,
          funcDefId,
          false,
          DataLocation.Storage,
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
    'CairoFunctionDefinition',
    sourceUnit.id,
    FunctionKind.Function,
    name,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    new ParameterList(ast.reserveId(), '', 'ParameterList', createParameters(inputs)),
    new ParameterList(ast.reserveId(), '', 'ParameterList', createParameters(returns)),
    [],
    new Set(implicits),
    true,
  );

  ast.setContextRecursive(funcDef);
  sourceUnit.insertAtBeginning(funcDef);

  return funcDef;
}

export function createCallToStub(
  stub: CairoFunctionDefinition,
  args: Expression[],
  ast: AST,
): FunctionCall {
  return new FunctionCall(
    ast.reserveId(),
    '',
    'FunctionCall',
    getReturnTypeString(stub),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      'Identifier',
      getFunctionTypeString(stub, ast.compilerVersion),
      stub.name,
      stub.id,
    ),
    args,
  );
}
