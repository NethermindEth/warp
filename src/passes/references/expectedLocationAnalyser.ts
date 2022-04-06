import assert from 'assert';
import {
  Assignment,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  PointerType,
  Return,
  TupleExpression,
  TupleType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { error } from '../../utils/formatting';
import { getParameterTypes } from '../../utils/nodeTypeProcessing';

/*
Analyses the tree top down, marking nodes with the storage location associated
with how they are being used. For example, a struct constructor being assigned
to a storage location would be marked storage, even if the struct is a memory
struct

Prerequisites
TupleAssignmentSplitter - Cannot usefully assign a location to tuple returns
*/

export class ExpectedLocationAnalyser extends ASTMapper {
  constructor(private expectedLocations: Map<Expression, DataLocation>) {
    super();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.kind === FunctionCallKind.TypeConversion) {
      return this.visitExpression(node, ast);
    }

    const parameterTypes = getParameterTypes(node, ast);
    parameterTypes.forEach((t, index) => {
      if (t instanceof PointerType) {
        this.expectedLocations.set(node.vArguments[index], t.location);
      } else {
        this.expectedLocations.set(node.vArguments[index], DataLocation.Default);
      }
    });
    this.visitExpression(node, ast);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (node.vLeftHandSide instanceof TupleExpression) {
      return this.visitExpression(node, ast);
    }
    const lhsType = getNodeType(node.vLeftHandSide, ast.compilerVersion);
    assert(!(lhsType instanceof TupleType));
    if (lhsType instanceof PointerType) {
      this.expectedLocations.set(node.vRightHandSide, lhsType.location);
    }
    this.visitExpression(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    const retParams = node.vFunctionReturnParameters.vParameters;
    if (retParams.length === 1) {
      assert(node.vExpression !== undefined, `expected ${printNode(node)} to return a value`);

      this.expectedLocations.set(node.vExpression, retParams[0].storageLocation);
    } else if (retParams.length > 1) {
      assert(
        node.vExpression instanceof TupleExpression,
        `Expected ${printNode(node)} to return a tuple. Has TupleAssignmentSplitter been run?`,
      );

      const subExpressions = node.vExpression.vOriginalComponents;
      assert(
        subExpressions.length === retParams.length,
        `Expected ${printNode(node)} to have ${retParams.length} members, found ${
          subExpressions.length
        }`,
      );
      subExpressions.forEach((subExpression, index) => {
        assert(subExpression !== null, `Expected ${printNode(node)} not to contain empty slots`);
        this.expectedLocations.set(subExpression, retParams[index].storageLocation);
      });
    }

    this.visitStatement(node, ast);
  }

  visitTupleExpression(node: TupleExpression, ast: AST): void {
    const assignedLocation = this.expectedLocations.get(node);

    if (assignedLocation === undefined) return;

    assert(
      node.isInlineArray,
      `Unexpectedly assigned non-array tuple ${printNode(node)} as ${assignedLocation}`,
    );

    node.vOriginalComponents.forEach((element) => {
      assert(
        element !== null,
        `Expected inline array ${printNode(node)} not to contain empty slots`,
      );
      this.expectedLocations.set(element, assignedLocation);
    });

    this.visitExpression(node, ast);
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    const declarations = node.assignments.map((id) => {
      if (id === null) return null;
      const decl = node.vDeclarations.find((v) => v.id === id);
      assert(decl !== undefined, `${printNode(node)} expected to have declaration with id ${id}`);
      return decl;
    });
    if (declarations.length === 1) {
      assert(
        declarations[0] !== null,
        error(`expected ${printNode(node)} to assign to a variable`),
      );
      assert(
        node.vInitialValue !== undefined,
        error(`expected ${printNode(node)} to assign an initial value`),
      );

      this.expectedLocations.set(node.vInitialValue, declarations[0].storageLocation);
    } else if (declarations.length > 1 && node.vInitialValue instanceof TupleExpression) {
      const subExpressions = node.vInitialValue.vOriginalComponents;
      assert(
        subExpressions.length === declarations.length,
        `Expected ${printNode(node)} to have ${declarations.length} members, found ${
          subExpressions.length
        }`,
      );
      subExpressions.forEach((subExpression, index) => {
        const declaration = declarations[index];
        if (declaration !== null) {
          assert(
            subExpression !== null,
            `Expected ${printNode(node)} to have a value for ${printNode(declaration)}`,
          );
          this.expectedLocations.set(subExpression, declaration.storageLocation);
        }
      });
    }

    this.visitStatement(node, ast);
  }
}
