import {
  ArrayTypeName,
  Assignment,
  ASTNode,
  BinaryOperation,
  Block,
  Break,
  Continue,
  ElementaryTypeName,
  ExpressionStatement,
  FunctionCall,
  Identifier,
  ImportDirective,
  IfStatement,
  IndexAccess,
  Literal,
  Mapping,
  Return,
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
  } else if (node instanceof Block) {
    newNode = new Block(
      ast.reserveId(),
      node.src,
      'Block',
      node.vStatements.map((v) => cloneASTNode(v, ast)),
      node.documentation,
      node.raw,
    );
  } else if (node instanceof IfStatement) {
    newNode = new IfStatement(
      ast.reserveId(),
      node.src,
      'IfStatement',
      cloneASTNode(node.vCondition, ast),
      cloneASTNode(node.vTrueBody, ast),
      node.vFalseBody ? cloneASTNode(node.vFalseBody, ast) : undefined,
      node.documentation,
      node.raw,
    );
  } else if (node instanceof Return) {
    newNode = new Return(
      ast.reserveId(),
      node.src,
      'Return',
      node.functionReturnParameters,
      node.vExpression ? cloneASTNode(node.vExpression, ast) : undefined,
      node.documentation,
      node.raw,
    );
  } else if (node instanceof Break) {
    newNode = cloneBreak(node, ast);
  } else if (node instanceof Continue) {
    newNode = cloneContinue(node, ast);
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

// Defining a seperate function instead of inling the code is a workaround to make the typechecker
// happy, since it can't distinguish between a Statement and Break.
function cloneBreak(node: Break, ast: AST): Break {
  return new Break(ast.reserveId(), node.src, 'Break', node.documentation, node.raw);
}

// Defining a seperate function instead of inling the code is a workaround to make the typechecker
// happy, since it can't distinguish between a Statement and Continue.
function cloneContinue(node: Continue, ast: AST): Continue {
  return new Continue(ast.reserveId(), node.src, 'Continue', node.documentation, node.raw);
}
