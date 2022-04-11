import {
  DataLocation,
  ElementaryTypeName,
  Identifier,
  Literal,
  LiteralKind,
  ParameterList,
  TupleExpression,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { toHexString } from './utils';

export function createAddressNonPayableTypeName(ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', 'address', 'address', 'nonpayable');
  ast.setContextRecursive(node);
  return node;
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
  const typeString =
    dataLocation !== undefined ? `${variable.typeString} ${dataLocation}` : variable.typeString;
  const node = new Identifier(ast.reserveId(), '', typeString, variable.name, variable.id);
  ast.setContextRecursive(node);
  return node;
}

export function createUint256Literal(value: bigint, ast: AST): Literal {
  const node = new Literal(
    ast.reserveId(),
    '',
    'uint256',
    LiteralKind.Number,
    toHexString(value.toString()),
    value.toString(),
  );
  ast.setContextRecursive(node);
  return node;
}

export function createUint256TypeName(ast: AST): ElementaryTypeName {
  const typeName = new ElementaryTypeName(ast.reserveId(), '', 'uint256', 'uint256');
  ast.setContextRecursive(typeName);
  return typeName;
}

export function createParameterList(
  params: Iterable<VariableDeclaration>,
  ast: AST,
): ParameterList {
  const paramList = new ParameterList(ast.reserveId(), '', params);
  ast.setContextRecursive(paramList);
  return paramList;
}
