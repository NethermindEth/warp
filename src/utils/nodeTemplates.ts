import {
  ElementaryTypeName,
  Identifier,
  Literal,
  LiteralKind,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { toHexString } from './utils';

export function createAddressNonPayableTypeName(ast: AST): ElementaryTypeName {
  return new ElementaryTypeName(
    ast.reserveId(),
    '',
    'ElementaryTypeName',
    'address',
    'address',
    'nonpayable',
  );
}

export function createIdentifier(variable: VariableDeclaration, ast: AST): Identifier {
  return new Identifier(
    ast.reserveId(),
    '',
    'Identifier',
    variable.typeString,
    variable.name,
    variable.id,
  );
}

export function createBoolLiteral(value: boolean, ast: AST): Literal {
  const valueString = value ? 'true' : 'false';
  return new Literal(
    ast.reserveId(),
    '',
    'Literal',
    'bool',
    LiteralKind.Bool,
    toHexString(valueString),
    valueString,
  );
}
