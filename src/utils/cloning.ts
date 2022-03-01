import {
  ArrayTypeName,
  Assignment,
  ASTNode,
  BinaryOperation,
  ElementaryTypeName,
  ExpressionStatement,
  FunctionCall,
  Identifier,
  ImportDirective,
  IndexAccess,
  Literal,
  Mapping,
  UnaryOperation,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode } from './astPrinter';
import { NotSupportedYetError } from './errors';
import { notNull } from './typeConstructs';

export function cloneASTNode<T extends ASTNode>(node: T, ast: AST): T {
  let newNode: ASTNode | null = null;

  // Expressions
  if (node instanceof Assignment) {
    newNode = new Assignment(
      ast.reserveId(),
      node.src,
      'Assignment',
      node.typeString,
      node.operator,
      cloneASTNode(node.vLeftHandSide, ast),
      cloneASTNode(node.vRightHandSide, ast),
      node.raw,
    );
  } else if (node instanceof BinaryOperation) {
    newNode = new BinaryOperation(
      ast.reserveId(),
      node.src,
      'BinaryOperation',
      node.typeString,
      node.operator,
      cloneASTNode(node.vLeftExpression, ast),
      cloneASTNode(node.vRightExpression, ast),
      node.raw,
    );
  } else if (node instanceof IndexAccess) {
    newNode = new IndexAccess(
      ast.reserveId(),
      node.src,
      'IndexAccess',
      node.typeString,
      cloneASTNode(node.vBaseExpression, ast),
      node.vIndexExpression && cloneASTNode(node.vIndexExpression, ast),
      node.raw,
    );
  } else if (node instanceof Identifier) {
    newNode = new Identifier(
      ast.reserveId(),
      node.src,
      'Identifier',
      node.typeString,
      node.name,
      node.referencedDeclaration,
      node.raw,
    );
  } else if (node instanceof FunctionCall) {
    newNode = new FunctionCall(
      ast.reserveId(),
      node.src,
      'FunctionCall',
      node.typeString,
      node.kind,
      cloneASTNode(node.vExpression, ast),
      node.vArguments.map((arg) => cloneASTNode(arg, ast)),
      node.fieldNames,
      node.raw,
    );
  } else if (node instanceof Literal) {
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
  } else if (node instanceof UnaryOperation) {
    newNode = new UnaryOperation(
      ast.reserveId(),
      node.src,
      'UnaryOperation',
      node.typeString,
      node.prefix,
      node.operator,
      cloneASTNode(node.vSubExpression, ast),
      node.raw,
    );
    // TypeNames
  } else if (node instanceof ElementaryTypeName) {
    newNode = new ElementaryTypeName(
      ast.reserveId(),
      node.src,
      'ElementaryTypeName',
      node.typeString,
      node.name,
      node.stateMutability,
      node.raw,
    );
  } else if (node instanceof Mapping) {
    newNode = new Mapping(
      ast.reserveId(),
      node.src,
      'Mapping',
      node.typeString,
      cloneASTNode(node.vKeyType, ast),
      cloneASTNode(node.vValueType, ast),
      node.raw,
    );
  } else if (node instanceof ArrayTypeName) {
    newNode = new ArrayTypeName(
      ast.reserveId(),
      node.src,
      'ArrayTypeName',
      node.typeString,
      cloneASTNode(node.vBaseType, ast),
      node.vLength,
      node.raw,
    );
    // Statements
  } else if (node instanceof ExpressionStatement) {
    newNode = new ExpressionStatement(
      ast.reserveId(),
      node.src,
      'ExpressionStatement',
      cloneASTNode(node.vExpression, ast),
      node.documentation,
      node.raw,
    );
    // Resolvable
  } else if (node instanceof VariableDeclaration) {
    if (node.vOverrideSpecifier !== undefined) {
      throw new NotSupportedYetError('Override Specifiers not implemented yet');
    }

    newNode = new VariableDeclaration(
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
      node.vType === undefined ? undefined : cloneASTNode(node.vType, ast),
      undefined,
      node.vValue === undefined ? undefined : cloneASTNode(node.vValue, ast),
      node.nameLocation,
    );
  } else if (node instanceof ImportDirective) {
    newNode = new ImportDirective(
      ast.reserveId(),
      node.src,
      node.type,
      node.file,
      node.absolutePath,
      node.unitAlias,
      node.symbolAliases,
      node.scope,
      node.sourceUnit,
      node.raw,
    );
  }

  if (notNull(newNode) && sameType(newNode, node)) {
    ast.setContextRecursive(newNode);
    ast.copyRegisteredImports(node, newNode);
    return newNode;
  } else {
    throw new NotSupportedYetError(`Unable to clone ${printNode(node)}`);
  }
}

function sameType<T extends ASTNode>(newNode: ASTNode, ref: T): newNode is T {
  return newNode instanceof ref.constructor && ref instanceof newNode.constructor;
}
