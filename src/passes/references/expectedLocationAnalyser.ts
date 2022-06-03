import assert from 'assert';
import {
  Assignment,
  BinaryOperation,
  ContractDefinition,
  DataLocation,
  Expression,
  ExternalReferenceType,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionVisibility,
  generalizeType,
  getNodeType,
  IndexAccess,
  MemberAccess,
  PointerType,
  Return,
  TupleExpression,
  UnaryOperation,
  UserDefinedType,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { locationIfComplexType } from '../../cairoUtilFuncGen/base';
import { printNode } from '../../utils/astPrinter';
import { TranspileFailedError } from '../../utils/errors';
import { error } from '../../utils/formatting';
import { getParameterTypes } from '../../utils/nodeTypeProcessing';
import { notNull } from '../../utils/typeConstructs';
import { isExternallyVisible } from '../../utils/utils';

/*
Analyses the tree top down, marking nodes with the storage location associated
with how they are being used. For example, a struct constructor being assigned
to a storage location would be marked storage, even if the struct is a memory
struct

Prerequisites
TupleAssignmentSplitter - Cannot usefully assign a location to tuple returns
*/

// undefined means unused, default means read

export class ExpectedLocationAnalyser extends ASTMapper {
  constructor(
    private actualLocations: Map<Expression, DataLocation>,
    private expectedLocations: Map<Expression, DataLocation>,
  ) {
    super();
  }

  visitAssignment(node: Assignment, ast: AST): void {
    const lhsLocation = this.actualLocations.get(node.vLeftHandSide);
    if (lhsLocation === DataLocation.Storage) {
      this.expectedLocations.set(node.vLeftHandSide, lhsLocation);
      const rhsLocation =
        generalizeType(getNodeType(node.vRightHandSide, ast.compilerVersion))[1] ??
        DataLocation.Default;
      this.expectedLocations.set(node.vRightHandSide, rhsLocation);
    } else if (lhsLocation === DataLocation.Memory) {
      this.expectedLocations.set(node.vLeftHandSide, lhsLocation);
      const rhsLocation = this.actualLocations.get(node.vRightHandSide);
      assert(
        rhsLocation !== undefined,
        `${printNode(node.vRightHandSide)} has no known location, needed for memory assignment`,
      );
      this.expectedLocations.set(node.vRightHandSide, rhsLocation);
    } else if (lhsLocation === DataLocation.CallData) {
      throw new TranspileFailedError(
        `Left hand side of assignment has calldata location ${printNode(node)}`,
      );
    } else if (lhsLocation === DataLocation.Default) {
      this.expectedLocations.set(node.vLeftHandSide, lhsLocation);
      this.expectedLocations.set(node.vRightHandSide, DataLocation.Default);
    } else {
      throw new TranspileFailedError(
        `Left hand side of assignment has undefined location ${printNode(node)}`,
      );
    }
    this.visitExpression(node, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.expectedLocations.set(node.vLeftExpression, DataLocation.Default);
    this.expectedLocations.set(node.vRightExpression, DataLocation.Default);
    this.visitExpression(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.operator === 'delete') {
      const subExpressionLocation = this.actualLocations.get(node.vSubExpression);
      if (subExpressionLocation !== undefined) {
        this.expectedLocations.set(node.vSubExpression, subExpressionLocation);
      }
    } else {
      this.expectedLocations.set(node.vSubExpression, DataLocation.Default);
    }
    this.visitExpression(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.kind === FunctionCallKind.TypeConversion) {
      node.vArguments.forEach((arg) => this.expectedLocations.set(arg, DataLocation.Default));
      return this.visitExpression(node, ast);
    }

    if (node.vFunctionCallType === ExternalReferenceType.Builtin && node.vFunctionName === 'push') {
      if (node.vArguments.length > 0) {
        const actualLoc = this.actualLocations.get(node.vArguments[0]);
        if (actualLoc) {
          this.expectedLocations.set(node.vArguments[0], actualLoc);
        }
      }
      return this.visitExpression(node, ast);
    }

    const parameterTypes = getParameterTypes(node, ast);
    // When calling `push`, the function recieves two paramaters nonetheless the argument is just one
    // This does not explode because javascript does not gives an index out of range exception
    node.vArguments.forEach((arg, index) => {
      // Solc 0.7.0 types push and pop as you would expect, 0.8.0 adds an extra initial argument
      const paramIndex = index + parameterTypes.length - node.vArguments.length;
      const t = parameterTypes[paramIndex];
      if (t instanceof PointerType) {
        if (node.kind === FunctionCallKind.StructConstructorCall) {
          // The components of a struct being assigned to a location are also being assigned to that location
          const expectedLocation = this.expectedLocations.get(node);
          if (expectedLocation !== undefined && expectedLocation !== DataLocation.Default) {
            this.expectedLocations.set(arg, expectedLocation);
            return;
          }

          // If no expected location, check the type associated with the parent struct constructor
          const structType = getNodeType(node, ast.compilerVersion);
          assert(structType instanceof PointerType);
          if (structType.location !== DataLocation.Default) {
            this.expectedLocations.set(arg, structType.location);
          } else {
            //Finally, default to the type in the pointer itself if we can't infer anything else
            this.expectedLocations.set(arg, t.location);
          }
        } else if (
          node.vReferencedDeclaration instanceof FunctionDefinition &&
          node.vReferencedDeclaration.visibility === FunctionVisibility.External
        ) {
          this.expectedLocations.set(arg, DataLocation.CallData);
        } else {
          this.expectedLocations.set(arg, t.location);
        }
      } else {
        this.expectedLocations.set(arg, DataLocation.Default);
      }
    });
    this.visitExpression(node, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    assert(node.vIndexExpression !== undefined);
    const baseLoc = this.actualLocations.get(node.vBaseExpression);
    assert(baseLoc !== undefined);
    this.expectedLocations.set(node.vBaseExpression, baseLoc);
    this.expectedLocations.set(node.vIndexExpression, DataLocation.Default);
    this.visitExpression(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const baseLoc = this.actualLocations.get(node.vExpression);
    const baseNodeType = getNodeType(node.vExpression, ast.compilerVersion);
    assert(baseLoc !== undefined);
    if (
      baseNodeType instanceof UserDefinedType &&
      baseNodeType.definition instanceof ContractDefinition
    ) {
      this.expectedLocations.set(node.vExpression, DataLocation.Default);
    } else this.expectedLocations.set(node.vExpression, baseLoc);
    this.visitExpression(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    const func = node.getClosestParentByType(FunctionDefinition);
    assert(func !== undefined, `Unable to find containing function for ${printNode(node)}`);
    if (isExternallyVisible(func)) {
      if (node.vExpression) {
        // External functions need to read out their returns
        // TODO might need to expand this to be clear that it's a deep read
        const retExpressions =
          node.vExpression instanceof TupleExpression && !node.vExpression.isInlineArray
            ? node.vExpression.vOriginalComponents.map((element) => {
                assert(element !== null, `Cannot return tuple with empty slots`);
                return element;
              })
            : [node.vExpression];

        retExpressions.forEach((retExpression) => {
          const retType = getNodeType(retExpression, ast.compilerVersion);
          this.expectedLocations.set(
            retExpression,
            locationIfComplexType(retType, DataLocation.CallData),
          );
        });
      }
      return this.visitStatement(node, ast);
    }

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

    if (assignedLocation === undefined) return this.visitExpression(node, ast);

    node.vOriginalComponents.filter(notNull).forEach((element) => {
      const elementType = getNodeType(element, ast.compilerVersion);
      this.expectedLocations.set(element, locationIfComplexType(elementType, assignedLocation));
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

  visitCairoAssert(node: CairoAssert, ast: AST): void {
    this.expectedLocations.set(node.vExpression, DataLocation.Default);
    this.visitExpression(node, ast);
  }
}
