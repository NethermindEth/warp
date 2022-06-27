import assert from 'assert';
import {
  Assignment,
  DataLocation,
  Expression,
  FunctionDefinition,
  generalizeType,
  getNodeType,
  ModifierDefinition,
  Mutability,
  StateVariableVisibility,
  TupleExpression,
  TupleType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { getDefaultValue } from '../../utils/defaultValueNodes';
import { TUPLE_FILLER_PREFIX } from '../../utils/manglingPrefix';
import { createIdentifier, createVariableDeclarationStatement } from '../../utils/nodeTemplates';
import { notNull } from '../../utils/typeConstructs';
import { expressionHasSideEffects, typeNameFromTypeNode } from '../../utils/utils';

export class TupleFiller extends ASTMapper {
  counter = 0;
  visitAssignment(node: Assignment, ast: AST): void {
    if (
      !(node.vLeftHandSide instanceof TupleExpression) ||
      node.vLeftHandSide.vOriginalComponents.every(notNull)
    ) {
      return this.visitExpression(node, ast);
    }

    const scope = node.getClosestParentBySelector(
      (p) => p instanceof FunctionDefinition || p instanceof ModifierDefinition,
    )?.id;
    assert(scope !== undefined, `Unable to find scope for tuple assignment. ${printNode(node)}`);

    // We are now looking at a tuple with empty slots on the left hand side of the assignment
    // There is a known bug with getNodeType when passed such tuples, so we must fill them
    // or remove the slot if the rhs has no side effects
    const lhs: TupleExpression = node.vLeftHandSide;

    lhs.vOriginalComponents
      .map((value, index) => (value === null ? index : null))
      .filter(notNull)
      .forEach((emptyIndex) => {
        if (shouldRemove(node.vRightHandSide, emptyIndex)) return;
        const tupleType = getNodeType(node.vRightHandSide, ast.compilerVersion);
        assert(
          tupleType instanceof TupleType,
          `Expected rhs of tuple assignment to be tuple type, got ${printTypeNode(
            tupleType,
          )} at ${printNode(node)}`,
        );
        const elementType = tupleType.elements[emptyIndex];
        const [generalisedType, loc] = generalizeType(elementType);
        const typeName = typeNameFromTypeNode(elementType, ast);
        const declaration = new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          `${TUPLE_FILLER_PREFIX}${this.counter++}`,
          scope,
          false,
          loc ?? DataLocation.Default,
          StateVariableVisibility.Default,
          Mutability.Mutable,
          generalisedType.pp(),
          undefined,
          typeName,
        );
        ast.insertStatementBefore(
          node,
          createVariableDeclarationStatement(
            [declaration],
            getDefaultValue(elementType, declaration, ast),
            ast,
          ),
        );
        const child = createIdentifier(declaration, ast);
        lhs.vOriginalComponents[emptyIndex] = child;
        ast.registerChild(child, lhs);
      });

    if (node.vRightHandSide instanceof TupleExpression) {
      const toRemove = lhs.vOriginalComponents
        .map((value, index) => (value === null ? index : null))
        .filter(notNull);
      lhs.vOriginalComponents = lhs.vOriginalComponents.filter(
        (_value, index) => !toRemove.includes(index),
      );
      node.vRightHandSide.vOriginalComponents = node.vRightHandSide.vOriginalComponents.filter(
        (_value, index) => !toRemove.includes(index),
      );
      updateTypeString(node.vRightHandSide);
    }

    updateTypeString(node.vLeftHandSide);
  }
}

function shouldRemove(rhs: Expression, index: number): boolean {
  if (!(rhs instanceof TupleExpression)) return false;
  const elem = rhs.vOriginalComponents[index];

  return elem === null || !expressionHasSideEffects(elem);
}

function updateTypeString(node: TupleExpression): void {
  node.typeString = `tuple(${node.vComponents.map((value) => value.typeString)})`;
}
