import { assert } from 'console';
import {
  ArrayTypeName,
  ASTNode,
  Block,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  ExpressionStatement,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Identifier,
  Literal,
  LiteralKind,
  ParameterList,
  Return,
  Statement,
  StructuredDocumentation,
  TupleExpression,
  TypeName,
  UncheckedBlock,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoTempVarStatement } from '../ast/cairoNodes';
import { generateExpressionTypeString, generateLiteralTypeString } from './getTypeString';
import { safeGetNodeTypeInCtx, specializeType } from './nodeTypeProcessing';
import { notNull } from './typeConstructs';
import { toHexString, toSingleExpression } from './utils';

export function createCairoTempVar(name: string, ast: AST) {
  const node = new CairoTempVarStatement(ast.reserveId(), '', name);
  ast.setContextRecursive(node);
  return node;
}

export function createAddressTypeName(payable: boolean, ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(
    ast.reserveId(),
    '',
    payable ? 'address payable' : 'address',
    'address',
    payable ? 'payable' : 'nonpayable',
  );
  ast.setContextRecursive(node);
  return node;
}

export function createStringTypeName(payable: boolean, ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(
    ast.reserveId(),
    '',
    'string',
    'string',
    payable ? 'payable' : 'nonpayable',
  );
  ast.setContextRecursive(node);
  return node;
}

export function createArrayTypeName(baseType: TypeName, ast: AST): ArrayTypeName {
  const node = new ArrayTypeName(ast.reserveId(), '', `${baseType.typeString}[]`, baseType);
  ast.setContextRecursive(node);
  return node;
}

export function createStaticArrayTypeName(
  baseType: TypeName,
  size: number,
  ast: AST,
): ArrayTypeName {
  const node = new ArrayTypeName(
    ast.reserveId(),
    '',
    `${baseType.typeString}[${size}]`,
    baseType,
    createNumberLiteral(size, ast),
  );
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

export function createUncheckedBlock(
  statements: Statement[],
  ast: AST,
  documentation?: StructuredDocumentation | string,
): Block {
  const block = new UncheckedBlock(ast.reserveId(), '', statements, documentation);
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

export function createBytesTypeName(ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', 'bytes', 'bytes');
  ast.setContextRecursive(node);
  return node;
}

// prettier-ignore
type BytesN = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32;

export function createBytesNTypeName(n: BytesN, ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', `bytes${n}`, `bytes${n}`);
  ast.setContextRecursive(node);
  return node;
}

export function createEmptyTuple(ast: AST): TupleExpression {
  return createTuple(ast, []);
}

export function createTuple(ast: AST, nodes: Expression[]): TupleExpression {
  const typeString = `tuple(${nodes.map((node) => node.typeString)})`;
  const node = new TupleExpression(ast.reserveId(), '', typeString, false, nodes);
  ast.setContextRecursive(node);
  return node;
}

export function createExpressionStatement(ast: AST, expression: Expression): ExpressionStatement {
  const node = new ExpressionStatement(ast.reserveId(), '', expression);
  ast.setContextRecursive(node);
  return node;
}

export function createIdentifier(
  variable: VariableDeclaration,
  ast: AST,
  dataLocation?: DataLocation,
  lookupNode?: ASTNode,
): Identifier {
  const type = safeGetNodeTypeInCtx(variable, ast.inference, lookupNode ?? variable);
  const node = new Identifier(
    ast.reserveId(),
    '',
    generateExpressionTypeString(type),
    variable.name,
    variable.id,
  );
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

export function createNumberTypeName(width: number, signed: boolean, ast: AST): ElementaryTypeName {
  const typestring = `${signed ? '' : 'u'}int${width}`;
  const typeName = new ElementaryTypeName(ast.reserveId(), '', typestring, typestring);
  ast.setContextRecursive(typeName);
  return typeName;
}

export function createStringLiteral(value: string, ast: AST): Literal {
  const node = new Literal(
    ast.reserveId(),
    '',
    `literal_string "${value}"`,
    LiteralKind.String,
    toHexString(value),
    value,
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

  [...params].forEach((decl) => {
    if (decl.stateVariable) {
      decl.stateVariable = false;
      decl.storageLocation = DataLocation.Storage;
    }
  });

  return paramList;
}

export function createReturn(
  toReturn: Expression | VariableDeclaration[] | undefined,
  retParamListId: number,
  ast: AST,
  lookupNode?: ASTNode,
): Return {
  const retValue =
    toReturn === undefined || toReturn instanceof Expression
      ? toReturn
      : toSingleExpression(
          toReturn.map((decl) => createIdentifier(decl, ast, undefined, lookupNode)),
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

export function createUint8TypeName(ast: AST): ElementaryTypeName {
  const typeName = new ElementaryTypeName(ast.reserveId(), '', 'uint8', 'uint8');
  ast.setContextRecursive(typeName);
  return typeName;
}

// prettier-ignore
type UintN = 8 | 16 | 24 | 32 | 40 | 48 | 56 | 64 | 72 | 80 | 88 | 96 | 104 | 112 | 120 | 128 | 136 | 144 | 152 | 160 | 168 | 176 | 184 | 192 | 200 | 208 | 216 | 224 | 232 | 240 | 248 | 256;

export function createUintNTypeName(n: UintN, ast: AST): ElementaryTypeName {
  const typeName = new ElementaryTypeName(ast.reserveId(), '', `uint${n}`, `uint${n}`);
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
    false, // virtual
    FunctionVisibility.Public,
    FunctionStateMutability.NonPayable,
    true, // isConstructor
    createParameterList([], ast),
    createParameterList([], ast),
    [],
  );
  ast.setContextRecursive(newFunc);
  return newFunc;
}

export function createVariableDeclarationStatement(
  varDecls: (VariableDeclaration | null)[],
  intitalValue: Expression | undefined,
  ast: AST,
): VariableDeclarationStatement {
  assert(
    varDecls.some(notNull),
    `Attempted to create variable declaration statement with no variables`,
  );
  const node = new VariableDeclarationStatement(
    ast.reserveId(),
    '',
    varDecls.map((v) => (v === null ? null : v.id)),
    varDecls.filter(notNull),
    intitalValue,
  );
  ast.setContextRecursive(node);
  return node;
}
