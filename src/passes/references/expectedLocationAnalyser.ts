import assert from 'assert';
import {
  Assignment,
  BinaryOperation,
  ContractDefinition,
  DataLocation,
  Expression,
  ExternalReferenceType,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionVisibility,
  generalizeType,
  IfStatement,
  IndexAccess,
  MappingType,
  MemberAccess,
  PointerType,
  Return,
  TupleExpression,
  TypeNameType,
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
import {
  getParameterTypes,
  isDynamicArray,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { notNull } from '../../utils/typeConstructs';
import { getContainingFunction, isExternallyVisible } from '../../utils/utils';

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
        generalizeType(safeGetNodeType(node.vRightHandSide, ast.inference))[1] ??
        DataLocation.Default;
      this.expectedLocations.set(node.vRightHandSide, rhsLocation);
    } else if (lhsLocation === DataLocation.Memory) {
      this.expectedLocations.set(node.vLeftHandSide, lhsLocation);
      const rhsType = safeGetNodeType(node.vRightHandSide, ast.inference);
      this.expectedLocations.set(
        node.vRightHandSide,
        locationIfComplexType(rhsType, DataLocation.Memory),
      );
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
      const toType = safeGetNodeType(node, ast.inference);
      node.vArguments.forEach((arg) => {
        const [type, location] = generalizeType(safeGetNodeType(arg, ast.inference));
        if (isDynamicArray(type) && !isReferenceType(toType)) {
          this.expectedLocations.set(arg, locationIfComplexType(type, DataLocation.Memory));
        } else {
          this.expectedLocations.set(arg, location ?? DataLocation.Default);
        }
      });
      return this.visitExpression(node, ast);
    }

    if (node.vFunctionCallType === ExternalReferenceType.Builtin) {
      if (node.vFunctionName === 'push') {
        if (node.vArguments.length > 0) {
          const actualLoc = this.actualLocations.get(node.vArguments[0]);
          if (actualLoc) {
            this.expectedLocations.set(node.vArguments[0], actualLoc);
          }
        }
        return this.visitExpression(node, ast);
      }
      if (node.vFunctionName === 'concat') {
        node.vArguments.forEach((arg) => this.expectedLocations.set(arg, DataLocation.Memory));
        return this.visitExpression(node, ast);
      }
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
          const structType = safeGetNodeType(node, ast.inference);
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
    const nodeType = safeGetNodeType(node, ast.inference);
    if (nodeType instanceof TypeNameType) return this.commonVisit(node, ast);
    assert(node.vIndexExpression !== undefined);
    const baseLoc = this.actualLocations.get(node.vBaseExpression);
    assert(baseLoc !== undefined);
    const baseType = safeGetNodeType(node.vBaseExpression, ast.inference);
    if (baseType instanceof FixedBytesType) {
      this.expectedLocations.set(node.vBaseExpression, DataLocation.Default);
    } else {
      this.expectedLocations.set(node.vBaseExpression, baseLoc);
    }
    if (
      baseType instanceof PointerType &&
      baseType.to instanceof MappingType &&
      isReferenceType(baseType.to.keyType)
    ) {
      const indexLoc = generalizeType(safeGetNodeType(node.vIndexExpression, ast.inference))[1];
      assert(indexLoc !== undefined);
      this.expectedLocations.set(node.vIndexExpression, indexLoc);
    } else {
      this.expectedLocations.set(node.vIndexExpression, DataLocation.Default);
    }
    this.visitExpression(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const baseLoc = this.actualLocations.get(node.vExpression);
    const baseNodeType = safeGetNodeType(node.vExpression, ast.inference);
    assert(baseLoc !== undefined);
    if (
      (baseNodeType instanceof UserDefinedType &&
        baseNodeType.definition instanceof ContractDefinition) ||
      baseNodeType instanceof FixedBytesType
    ) {
      this.expectedLocations.set(node.vExpression, DataLocation.Default);
    } else this.expectedLocations.set(node.vExpression, baseLoc);
    this.visitExpression(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    const func = getContainingFunction(node);
    if (isExternallyVisible(func)) {
      if (node.vExpression) {
        // External functions need to read out their returns
        const retExpressions =
          node.vExpression instanceof TupleExpression && !node.vExpression.isInlineArray
            ? node.vExpression.vOriginalComponents.map((element) => {
                assert(element !== null, `Cannot return tuple with empty slots`);
                return element;
              })
            : [node.vExpression];

        retExpressions.forEach((retExpression) => {
          const retType = safeGetNodeType(retExpression, ast.inference);
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
      const elementType = safeGetNodeType(element, ast.inference);
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

  visitIfStatement(node: IfStatement, ast: AST): void {
    this.expectedLocations.set(node.vCondition, DataLocation.Default);
    this.visitStatement(node, ast);
  }
}
