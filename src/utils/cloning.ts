import {
  ArrayTypeName,
  Assignment,
  BinaryOperation,
  ElementaryTypeName,
  Expression,
  ExpressionStatement,
  FunctionCall,
  Identifier,
  IndexAccess,
  Literal,
  Mapping,
  Statement,
  TypeName,
  UnaryOperation,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { NotSupportedYetError } from './errors';
import { exactInstanceOf } from './utils';

export function cloneExpression(node: Expression, ast: AST): Expression {
  let newNode: Expression;
  if (exactInstanceOf(node, Assignment)) {
    newNode = new Assignment(
      ast.reserveId(),
      node.src,
      'Assignment',
      node.typeString,
      node.operator,
      cloneExpression(node.vLeftHandSide, ast),
      cloneExpression(node.vRightHandSide, ast),
      node.raw,
    );
  } else if (exactInstanceOf(node, BinaryOperation)) {
    newNode = new BinaryOperation(
      ast.reserveId(),
      node.src,
      'BinaryOperation',
      node.typeString,
      node.operator,
      cloneExpression(node.vLeftExpression, ast),
      cloneExpression(node.vRightExpression, ast),
      node.raw,
    );
  } else if (exactInstanceOf(node, IndexAccess)) {
    newNode = new IndexAccess(
      ast.reserveId(),
      node.src,
      'IndexAccess',
      node.typeString,
      cloneExpression(node.vBaseExpression, ast),
      node.vIndexExpression && cloneExpression(node.vIndexExpression, ast),
      node.raw,
    );
  } else if (exactInstanceOf(node, Identifier)) {
    newNode = new Identifier(
      ast.reserveId(),
      node.src,
      'Identifier',
      node.typeString,
      node.name,
      node.referencedDeclaration,
      node.raw,
    );
  } else if (exactInstanceOf(node, FunctionCall)) {
    newNode = new FunctionCall(
      ast.reserveId(),
      node.src,
      'FunctionCall',
      node.typeString,
      node.kind,
      cloneExpression(node.vExpression, ast),
      node.vArguments.map((arg) => cloneExpression(arg, ast)),
      node.fieldNames,
      node.raw,
    );
  } else if (exactInstanceOf(node, Literal)) {
    newNode = new Literal(
      ast.reserveId(),
      node.src,
      'Literal',
      node.typeString,
      node.kind,
      node.hexValue,
      node.value,
      node.subdenomination,
      node.raw,
    );
  } else if (exactInstanceOf(node, UnaryOperation)) {
    newNode = new UnaryOperation(
      ast.reserveId(),
      node.src,
      'UnaryOperation',
      node.typeString,
      node.prefix,
      node.operator,
      cloneExpression(node.vSubExpression, ast),
      node.raw,
    );
  } else {
    throw new NotSupportedYetError(`Cloning ${node.type} expressions not implemented yet`);
  }

  ast.setContextRecursive(newNode);
  return newNode;
}

export function cloneTypeName(node: TypeName, ast: AST): TypeName {
  let newNode: TypeName;
  if (exactInstanceOf(node, ElementaryTypeName)) {
    newNode = new ElementaryTypeName(
      ast.reserveId(),
      node.src,
      'ElementaryTypeName',
      node.typeString,
      node.name,
      node.stateMutability,
      node.raw,
    );
  } else if (exactInstanceOf(node, Mapping)) {
    newNode = new Mapping(
      ast.reserveId(),
      node.src,
      'Mapping',
      node.typeString,
      cloneTypeName(node.vKeyType, ast),
      cloneTypeName(node.vValueType, ast),
      node.raw,
    );
  } else if (exactInstanceOf(node, ArrayTypeName)) {
    newNode = new ArrayTypeName(
      ast.reserveId(),
      node.src,
      'ArrayTypeName',
      node.typeString,
      cloneTypeName(node.vBaseType, ast),
      node.vLength,
      node.raw,
    );
  } else {
    throw new NotSupportedYetError(`Cloning ${node.type} typenames not implemented yet`);
  }

  ast.setContextRecursive(newNode);
  return newNode;
}

export function cloneVariableDeclaration(node: VariableDeclaration, ast: AST): VariableDeclaration {
  if (node.vOverrideSpecifier !== undefined) {
    throw new NotSupportedYetError('Override Specifiers not implemented yet');
  }

  return new VariableDeclaration(
    ast.reserveId(),
    node.src,
    node.type,
    node.constant,
    node.indexed,
    node.name,
    node.scope,
    node.stateVariable,
    node.storageLocation,
    node.visibility,
    node.mutability,
    node.typeString,
    node.documentation,
    node.vType === undefined ? undefined : cloneTypeName(node.vType, ast),
    undefined,
    node.vValue === undefined ? undefined : cloneExpression(node.vValue, ast),
    node.nameLocation,
  );
}

export function cloneStatement(node: Statement, ast: AST): Statement {
  let newNode: Statement;

  if (exactInstanceOf(node, ExpressionStatement)) {
    newNode = new ExpressionStatement(
      ast.reserveId(),
      node.src,
      'ExpressionStatement',
      cloneExpression(node.vExpression, ast),
      node.documentation,
      node.raw,
    );
  } else {
    throw new NotSupportedYetError(`Cloning ${node.type} statement not implemented yet`);
  }

  ast.setContextRecursive(newNode);
  return newNode;
}
