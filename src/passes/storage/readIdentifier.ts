import assert = require('assert');
import {
  ArrayType,
  Assignment,
  ASTNode,
  BinaryOperation,
  Expression,
  FunctionCall,
  getNodeType,
  IndexAccess,
  MappingType,
  PointerType,
  Return,
  UnaryOperation,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class ReadIdentifier extends ASTMapper {
  constructor(public reads: Set<ASTNode>) {
    super();
  }

  visitAssignment(node: Assignment, ast: AST): void {
    this.reads.add(node.vRightHandSide);
    this.visitExpression(node, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.reads.add(node.vLeftExpression);
    this.reads.add(node.vRightExpression);
    this.visitExpression(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    node.vArguments.forEach((arg) => {
      if (isValueType(arg, ast)) this.reads.add(arg);
    });
    this.visitExpression(node, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    if (
      baseType instanceof PointerType &&
      (baseType.to instanceof MappingType ||
        (baseType.to instanceof ArrayType && baseType.to.size === undefined))
    ) {
      this.reads.add(node.vBaseExpression);
    }
    assert(node.vIndexExpression !== undefined);
    this.reads.add(node.vIndexExpression);
    this.visitExpression(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    if (node.vExpression && node.vFunctionReturnParameters.vParameters.length > 0) {
      this.reads.add(node.vExpression);
    }
    this.visitStatement(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.operator !== 'delete') {
      this.reads.add(node.vSubExpression);
    }
    this.visitExpression(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vValue) {
      this.reads.add(node.vValue);
    }
    this.commonVisit(node, ast);
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    if (node.vInitialValue) {
      const type = getNodeType(node.vInitialValue, ast.compilerVersion);
      if (!(type instanceof PointerType)) {
        this.reads.add(node.vInitialValue);
      }
    }
    this.visitStatement(node, ast);
  }
}

function isValueType(node: Expression, ast: AST): boolean {
  const type = getNodeType(node, ast.compilerVersion);
  if (type instanceof PointerType) return false;
  return true;
}
