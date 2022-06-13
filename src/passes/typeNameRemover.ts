import {
  ElementaryTypeNameExpression,
  ExpressionStatement,
  getNodeType,
  IndexAccess,
  TypeNameType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import assert from 'assert';
import {
  Assignment,
  Expression,
  FunctionDefinition,
  ModifierDefinition,
  TupleExpression,
} from 'solc-typed-ast';
import { printNode } from '../utils/astPrinter';
import { notNull } from '../utils/typeConstructs';
import { expressionHasSideEffects } from '../utils/utils';

export class TypeNameRemover extends ASTMapper {
  // Add indexAccess to this.
  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    if (
      (node.vExpression instanceof IndexAccess ||
        node.vExpression instanceof ElementaryTypeNameExpression) &&
      getNodeType(node.vExpression, ast.compilerVersion) instanceof TypeNameType
    ) {
      ast.removeStatement(node);
    }
  }

  // This must come before the tuple filler
  visitAssignment(node: Assignment, ast: AST): void {
    if (
      !(
        node.vLeftHandSide instanceof TupleExpression &&
        node.vRightHandSide instanceof TupleExpression
      ) ||
      node.vLeftHandSide.vOriginalComponents.every(notNull)
    ) {
      return this.visitExpression(node, ast);
    }

    const scope = node.getClosestParentBySelector(
      (p) => p instanceof FunctionDefinition || p instanceof ModifierDefinition,
    )?.id;
    assert(scope !== undefined, `Unable to find scope for tuple assignment. ${printNode(node)}`);

    // We are now looking at a tuple with empty slots on the left hand side of the assignment
    // We want to investigate whether there is a TypeNameType expressions looking to fill that empty slot.
    // If there is we need to remove that expression since they are not supported.
    const lhs: TupleExpression = node.vLeftHandSide;
    const rhs: TupleExpression = node.vRightHandSide;

    const emptySlots = lhs.vOriginalComponents
      .map((value, index) => (value === null ? index : null))
      .filter(notNull);
    const typeNameTypeSlots = rhs.vOriginalComponents
      .map((value, index) => (this.typeNameType(value, index, ast) ? index : null))
      .filter(notNull);

    lhs.vOriginalComponents = lhs.vOriginalComponents.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );
    node.vRightHandSide.vOriginalComponents = node.vRightHandSide.vOriginalComponents.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );

    updateTypeString(node.vRightHandSide);
    updateTypeString(node.vLeftHandSide);
  }

  typeNameType(rhs: Expression | null, index: number, ast: AST): boolean {
    if (!(rhs instanceof TupleExpression)) return false;
    const elem = rhs.vOriginalComponents[index];
    return elem !== null
      ? getNodeType(elem, ast.compilerVersion) instanceof TypeNameType &&
          !expressionHasSideEffects(elem)
      : false;
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    if (!(node.vInitialValue instanceof TupleExpression) || node.assignments.every(notNull)) {
      return this.commonVisit(node, ast);
    }

    const scope = node.getClosestParentBySelector(
      (p) => p instanceof FunctionDefinition || p instanceof ModifierDefinition,
    )?.id;
    assert(scope !== undefined, `Unable to find scope for tuple assignment. ${printNode(node)}`);

    // We are now looking at a tuple with empty slots on the left hand side of the assignment
    // We want to investigate whether there is a TypeNameType expressions looking to fill that empty slot.
    // If there is we need to remove that expression since they are not supported.
    const rhs = node.vInitialValue;
    assert(rhs instanceof TupleExpression);
    const lhs = node.assignments;

    const emptySlots = node.assignments
      .map((value, index) => (value === null ? index : null))
      .filter(notNull);
    const typeNameTypeSlots = rhs.vOriginalComponents
      .map((value, index) => (this.typeNameType(value, index, ast) ? index : null))
      .filter(notNull);

    node.assignments = lhs.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );
    rhs.vOriginalComponents = rhs.vOriginalComponents.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );

    updateTypeString(rhs);
  }
}

function updateTypeString(node: TupleExpression): void {
  node.typeString = `tuple(${node.vComponents.map((value) => value.typeString)})`;
}
