import {
  Block,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  getNodeType,
  Identifier,
  Literal,
  LiteralKind,
  ParameterList,
  Return,
  Statement,
  StructuredDocumentation,
  TupleExpression,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { generateLiteralTypeString } from './getTypeString';
import { specializeType } from './nodeTypeProcessing';
import { toHexString, toSingleExpression } from './utils';

export function createAddressNonPayableTypeName(ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', 'address', 'address', 'nonpayable');
  ast.setContextRecursive(node);
  return node;
}

export function createBlock(
  statements: Statement[],
  ast: AST,
  documentation?: StructuredDocumentation | string,
): Block {
  const block = new Block(ast.reserveId(), '', statements, documentation);
  ast.setContextRecursive(block);
  return block;
}

export function createBoolLiteral(value: boolean, ast: AST): Literal {
  const valueString = value ? 'true' : 'false';
  const node = new Literal(
    ast.reserveId(),
    '',
    'bool',
    LiteralKind.Bool,
    toHexString(valueString),
    valueString,
  );
  ast.setContextRecursive(node);
  return node;
}

export function createBoolTypeName(ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', 'bool', 'bool');
  ast.setContextRecursive(node);
  return node;
}

export function createEmptyTuple(ast: AST): TupleExpression {
  const node = new TupleExpression(ast.reserveId(), '', 'tuple()', false, []);
  ast.setContextRecursive(node);
  return node;
}

export function createIdentifier(
  variable: VariableDeclaration,
  ast: AST,
  dataLocation?: DataLocation,
): Identifier {
  const type = specializeType(
    getNodeType(variable, ast.compilerVersion),
    dataLocation ?? (variable.stateVariable ? DataLocation.Storage : variable.storageLocation),
  );
  const node = new Identifier(ast.reserveId(), '', type.pp(), variable.name, variable.id);
  ast.setContextRecursive(node);
  return node;
}

export function createNumberLiteral(
  value: number | bigint | string,
  ast: AST,
  typeString?: string,
): Literal {
  const stringValue = typeof value === 'string' ? value : BigInt(value).toString();
  typeString = typeString ?? generateLiteralTypeString(stringValue);
  const node = new Literal(
    ast.reserveId(),
    '',
    typeString,
    LiteralKind.Number,
    toHexString(stringValue),
    stringValue,
  );
  ast.setContextRecursive(node);
  return node;
}

export function createParameterList(
  params: Iterable<VariableDeclaration>,
  ast: AST,
  scope?: number,
): ParameterList {
  const paramList = new ParameterList(ast.reserveId(), '', params);
  ast.setContextRecursive(paramList);
  if (scope !== undefined) {
    [...params].forEach((decl) => (decl.scope = scope));
  }
  return paramList;
}

export function createReturn(
  toReturn: Expression | VariableDeclaration[] | undefined,
  retParamListId: number,
  ast: AST,
): Return {
  const retValue =
    toReturn === undefined || toReturn instanceof Expression
      ? toReturn
      : toSingleExpression(
          toReturn.map((decl) => createIdentifier(decl, ast)),
          ast,
        );
  const node = new Return(ast.reserveId(), '', retParamListId, retValue);
  ast.setContextRecursive(node);
  return node;
}

export function createUint256TypeName(ast: AST): ElementaryTypeName {
  const typeName = new ElementaryTypeName(ast.reserveId(), '', 'uint256', 'uint256');
  ast.setContextRecursive(typeName);
  return typeName;
}

export function createDefaultConstructor(node: ContractDefinition, ast: AST): FunctionDefinition {
  const newFunc = new FunctionDefinition(
    ast.reserveId(),
    '',
    node.id,
    FunctionKind.Constructor,
    '',
    false,
    FunctionVisibility.Public,
    FunctionStateMutability.NonPayable,
    true,
    createParameterList([], ast),
    createParameterList([], ast),
    [],
  );
  return newFunc;
}
