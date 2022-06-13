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
import { Expression, TupleExpression } from 'solc-typed-ast';
import { notNull } from '../utils/typeConstructs';
import { expressionHasSideEffects } from '../utils/utils';

export class TypeNameRemover extends ASTMapper {
  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    if (
      (node.vExpression instanceof IndexAccess ||
        node.vExpression instanceof ElementaryTypeNameExpression) &&
      getNodeType(node.vExpression, ast.compilerVersion) instanceof TypeNameType
    ) {
      ast.removeStatement(node);
    }
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    if (!(node.vInitialValue instanceof TupleExpression) || node.assignments.every(notNull)) {
      return this.commonVisit(node, ast);
    }

    // We are now looking at a tuple with empty slots on the left hand side of the VariableDeclaration.
    // We want to investigate whether there is a TypeNameType expressions looking to fill that empty slot.
    // If there is we need to remove that expression since they are not supported.
    const rhs = node.vInitialValue;
    assert(rhs instanceof TupleExpression);
    const lhs = node.assignments;

    const emptySlots = node.assignments
      .map((value, index) => (value === null ? index : null))
      .filter(notNull);
    const typeNameTypeSlots = rhs.vOriginalComponents
      .map((value, index) => (this.isTypeNameType(value, index, ast) ? index : null))
      .filter(notNull);

    node.assignments = lhs.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );
    rhs.vOriginalComponents = rhs.vOriginalComponents.filter(
      (_value, index) => !emptySlots.includes(index) && !typeNameTypeSlots.includes(index),
    );

    updateTypeString(rhs);
  }

  isTypeNameType(rhs: Expression | null, index: number, ast: AST): boolean {
    if (!(rhs instanceof TupleExpression)) return false;
    const elem = rhs.vOriginalComponents[index];
    return elem !== null
      ? getNodeType(elem, ast.compilerVersion) instanceof TypeNameType &&
          !expressionHasSideEffects(elem)
      : false;
  }
}

function updateTypeString(node: TupleExpression): void {
  node.typeString = `tuple(${node.vComponents.map((value) => value.typeString)})`;
}
