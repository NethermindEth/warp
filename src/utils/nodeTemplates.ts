import {
  ASTNode,
  Block,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  getNodeTypeInCtx,
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
import { generateExpressionTypeString, generateLiteralTypeString } from './getTypeString';
import { specializeType } from './nodeTypeProcessing';
import { toHexString, toSingleExpression } from './utils';

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

export function createBytesTypeName(ast: AST): ElementaryTypeName {
  const node = new ElementaryTypeName(ast.reserveId(), '', 'bytes', 'bytes');
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
  lookupNode?: ASTNode,
): Identifier {
  const type = specializeType(
    getNodeTypeInCtx(variable, ast.compilerVersion, lookupNode ?? variable),
    dataLocation ?? (variable.stateVariable ? DataLocation.Storage : variable.storageLocation),
  );
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

export function createUint8TypeName(ast: AST): ElementaryTypeName {
  const typeName = new ElementaryTypeName(ast.reserveId(), '', 'uint8', 'uint8');
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
