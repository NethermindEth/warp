import {
  DataLocation,
  ElementaryTypeName,
  Identifier,
  Literal,
  LiteralKind,
  ParameterList,
  TupleExpression,
  VariableDeclaration,
  Statement,
  Block,
  Return,
  Expression,
  StructuredDocumentation,
  ContractDefinition,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  FunctionStateMutability,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
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
  const location = dataLocation ?? variable.storageLocation;
  const typeString =
    location !== undefined
      ? `${variable.typeString} ${location === DataLocation.Default ? '' : location}`
      : variable.typeString;
  const node = new Identifier(ast.reserveId(), '', typeString, variable.name, variable.id);
  ast.setContextRecursive(node);
  return node;
}

export function createNumberLiteral(value: bigint, typeString: string, ast: AST): Literal {
  const node = new Literal(
    ast.reserveId(),
    '',
    typeString,
    LiteralKind.Number,
    toHexString(value.toString()),
    value.toString(),
  );
  ast.setContextRecursive(node);
  return node;
}

export function createParameterList(
  params: Iterable<VariableDeclaration>,
  ast: AST,
): ParameterList {
  const paramList = new ParameterList(ast.reserveId(), '', params);
  ast.setContextRecursive(paramList);
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
