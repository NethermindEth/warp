import {
  ElementaryTypeNameExpression,
  ExpressionStatement,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  TypeNameType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import assert from 'assert';
import { TupleExpression } from 'solc-typed-ast';
import { notNull } from '../utils/typeConstructs';

export class TypeNameRemover extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPrerequisite(): void {
    const passKeys: string[] = ['Tf'];
    passKeys.forEach((key) => this.addPrerequisite(key));
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    if (
      (node.vExpression instanceof IndexAccess ||
        node.vExpression instanceof MemberAccess ||
        node.vExpression instanceof Identifier ||
        node.vExpression instanceof ElementaryTypeNameExpression) &&
      getNodeType(node.vExpression, ast.compilerVersion) instanceof TypeNameType
    ) {
      ast.removeStatement(node);
    } else if (node.vExpression instanceof TupleExpression) {
      this.visitTupleExpression(node.vExpression, ast);
    }
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    node.vOriginalComponents.forEach((n) => {
      if (n instanceof TupleExpression) {
        this.visitTupleExpression(n, ast);
      }
    });

    node.vOriginalComponents = node.vOriginalComponents.filter(
      (n, index) => !this.isTypeNameType(node, index, ast),
    );
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
      .map((_value, index) => (this.isTypeNameType(rhs, index, ast) ? index : null))
      .filter(notNull);

    node.assignments = lhs.filter(
      (_value, index) => !emptySlots.includes(index) || !typeNameTypeSlots.includes(index),
    );
    rhs.vOriginalComponents = rhs.vOriginalComponents.filter(
      (_value, index) => !emptySlots.includes(index) || !typeNameTypeSlots.includes(index),
    );

    updateTypeString(rhs);
  }

  isTypeNameType(rhs: TupleExpression | null, index: number, ast: AST): boolean {
    if (!(rhs instanceof TupleExpression)) return false;
    const elem = rhs.vOriginalComponents[index];
    return elem !== null ? getNodeType(elem, ast.compilerVersion) instanceof TypeNameType : false;
  }
}

function updateTypeString(node: TupleExpression): void {
  node.typeString = `tuple(${node.vComponents.map((value) => value.typeString)})`;
}
