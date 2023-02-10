import {
  ElementaryTypeNameExpression,
  ExpressionStatement,
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
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

export class TypeNameRemover extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      // ABI Builtin needs to be handled first because some builtin
      // functions like abi.decode uses TypeNames as arguments, otherwise,
      // they will be removed before use
      // Eg:
      //     abi.decode(data, (uint[7][]));
      'Abi',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    if (
      (node.vExpression instanceof IndexAccess ||
        node.vExpression instanceof MemberAccess ||
        node.vExpression instanceof Identifier ||
        node.vExpression instanceof ElementaryTypeNameExpression) &&
      safeGetNodeType(node.vExpression, ast.inference) instanceof TypeNameType
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
    return elem !== null ? safeGetNodeType(elem, ast.inference) instanceof TypeNameType : false;
  }
}

function updateTypeString(node: TupleExpression): void {
  node.typeString = `tuple(${node.vComponents.map((value) => value.typeString)})`;
}
