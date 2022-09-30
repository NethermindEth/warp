import assert from 'assert';
import {
  Assignment,
  ContractDefinition,
  Conditional,
  DataLocation,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  Identifier,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
  generalizeType,
  TupleExpression,
  Block,
  TupleType,
  TypeNode,
  IntLiteralType,
  StringLiteralType,
  Expression,
  Return,
  ASTNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { createCallToFunction, fixParameterScopes } from '../../utils/functionGeneration';
import {
  CONDITIONAL_FUNCTION_PREFIX,
  PRE_SPLIT_EXPRESSION_PREFIX,
  TUPLE_VALUE_PREFIX,
} from '../../utils/nameModifiers';
import {
  createBlock,
  createEmptyTuple,
  createExpressionStatement,
  createIdentifier,
  createVariableDeclarationStatement,
} from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { notNull } from '../../utils/typeConstructs';
import {
  counterGenerator,
  getContainingFunction,
  toSingleExpression,
  typeNameFromTypeNode,
} from '../../utils/utils';
import {
  addStatementsToCallFunction,
  createFunctionBody,
  getConditionalReturn,
  getInputs,
  getNodeVariables,
  getParams,
  getReturns,
  getStatementsForVoidConditionals,
} from './conditionalFunctionaliser';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}${count.next().value}`;
  }
}

export class ConditionalSplitter extends ASTMapper {
  eGen = expressionGenerator(PRE_SPLIT_EXPRESSION_PREFIX);
  eGenTuple = expressionGenerator(TUPLE_VALUE_PREFIX);
  nameCounter = counterGenerator();

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    let visitNode: ASTNode = node;
    if (node.vExpression instanceof Assignment) {
      if (node.vExpression.vLeftHandSide instanceof TupleExpression) {
        visitNode = this.splitTupleAssignment(node.vExpression, ast);
        ast.replaceNode(node, visitNode);
      }
    }

    this.commonVisit(visitNode, ast);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);

    // No need to split if it is a statement
    if (node.parent instanceof ExpressionStatement) {
      return;
    }

    // No need to create temp vars for state vars
    if (
      node.vLeftHandSide instanceof Identifier &&
      identifierReferenceStateVar(node.vLeftHandSide)
    ) {
      return;
    }

    this.splitSimpleAssignment(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (
      !(node.vReferencedDeclaration instanceof FunctionDefinition) ||
      node.parent instanceof ExpressionStatement ||
      node.parent instanceof VariableDeclarationStatement
    ) {
      return;
    }

    const returnTypes = node.vReferencedDeclaration.vReturnParameters.vParameters;
    if (returnTypes.length === 0) {
      this.splitFunctionCallWithoutReturn(node, ast);
    } else if (returnTypes.length === 1) {
      this.splitFunctionCallWithReturn(node, returnTypes[0], ast);
    } else {
      throw new TranspileFailedError(
        `ExpressionSplitter expects functions to have at most 1 return argument. ${printNode(
          node,
        )} ${node.vFunctionName} has ${returnTypes.length}`,
      );
    }
  }

  visitConditional(node: Conditional, ast: AST) {
    const containingFunction = getContainingFunction(node);
    const variables = getNodeVariables(node);
    const args = getInputs(variables, ast);
    const inputParams = getParams(variables, ast);
    const newFuncId = ast.reserveId();
    const conditionalResult = getConditionalReturn(node, newFuncId, this.nameCounter, ast);
    const returnParams = getReturns(variables, conditionalResult, ast);

    const func = new FunctionDefinition(
      newFuncId,
      '',
      containingFunction.scope,
      containingFunction.kind === FunctionKind.Free ? FunctionKind.Free : FunctionKind.Function,
      `${CONDITIONAL_FUNCTION_PREFIX}${containingFunction.name}_${this.nameCounter.next().value}`,
      false, // virtual
      FunctionVisibility.Internal,
      containingFunction.stateMutability,
      false, // isConstructor
      inputParams,
      returnParams,
      [],
      undefined,
      createFunctionBody(node, conditionalResult, returnParams, ast),
    );
    fixParameterScopes(func);
    containingFunction.vScope.insertBefore(func, containingFunction);
    ast.registerChild(func, containingFunction.vScope);
    this.dispatchVisit(func, ast);

    // Conditionals might return a value, or they might be void, in which
    // case conditionalResult would contain no elements. Both cases need to be handled
    // separately
    if (conditionalResult.length !== 0) {
      // conditionalResult was already used as the return value of the
      // conditional in the new function. It needs to be cloned to capture the
      // return value of the new function in containingFunction
      const result = conditionalResult.map((v) => {
        const variable = cloneASTNode(v, ast);
        variable.scope = containingFunction.id;
        return variable;
      });

      const statements = addStatementsToCallFunction(
        node,
        result,
        [...variables.keys()],
        createCallToFunction(func, args, ast),
        ast,
      );
      statements.forEach((stmt) => {
        ast.insertStatementBefore(node, stmt);
        this.dispatchVisit(stmt, ast);
      });
      ast.replaceNode(
        node,
        toSingleExpression(
          result.map((v) => createIdentifier(v, ast)),
          ast,
        ),
      );
    } else {
      getStatementsForVoidConditionals(
        node,
        [...variables.keys()],
        createCallToFunction(func, args, ast),
        ast,
      );
    }
  }

  visitReturn(node: Return, ast: AST): void {
    let nodeToVisit: ASTNode = node;
    if (node.vFunctionReturnParameters.vParameters.length > 1) {
      nodeToVisit = this.splitReturnTuple(node, ast);
    }
    this.commonVisit(nodeToVisit, ast);
  }

  splitSimpleAssignment(node: Assignment, ast: AST): void {
    const initialValue = node.vRightHandSide;
    const location =
      generalizeType(safeGetNodeType(initialValue, ast.compilerVersion))[1] ?? DataLocation.Default;
    const varDecl = new VariableDeclaration(
      ast.reserveId(),
      '', // src
      false, // constant
      false, // indexed
      this.eGen.next().value,
      ast.getContainingScope(node),
      false, // stateVariable
      location,
      StateVariableVisibility.Internal,
      Mutability.Constant,
      node.vLeftHandSide.typeString,
    );

    const tempVarStatement = createVariableDeclarationStatement([varDecl], initialValue, ast);
    const tempVar = tempVarStatement.vDeclarations[0];

    const leftHandSide = cloneASTNode(node.vLeftHandSide, ast);
    const rightHandSide = createIdentifier(tempVar, ast, undefined, node);
    const assignment = new Assignment(
      ast.reserveId(),
      '', // src
      leftHandSide.typeString,
      '=', // operator
      leftHandSide,
      rightHandSide,
    );
    const updateVal = createExpressionStatement(ast, assignment);

    // b = (a=7) + 4
    // ~>
    // __warp_se = 7
    // a = __warp_se
    // b = (__warp_se) + 4
    ast.insertStatementBefore(node, tempVarStatement);
    ast.insertStatementBefore(node, updateVal);
    ast.replaceNode(node, createIdentifier(tempVar, ast));
  }

  splitTupleAssignment(node: Assignment, ast: AST): Block {
    const [lhs, rhs] = [node.vLeftHandSide, node.vRightHandSide];
    assert(
      lhs instanceof TupleExpression,
      `Split tuple assignment was called on non-tuple assignment ${node.type} # ${node.id}`,
    );
    const rhsType = safeGetNodeType(rhs, ast.compilerVersion);
    assert(
      rhsType instanceof TupleType,
      `Expected rhs of tuple assignment to be tuple type ${printNode(node)}`,
    );

    const block = createBlock([], ast);

    const tempVars = new Map<Expression, VariableDeclaration>(
      lhs.vOriginalComponents.filter(notNull).map((child, index) => {
        const lhsElementType = safeGetNodeType(child, ast.compilerVersion);
        const rhsElementType = rhsType.elements[index];

        // We need to calculate a type and location for the temporary variable
        // By default we can use the rhs value, unless it is a literal
        let typeNode: TypeNode;
        let location: DataLocation | undefined;
        if (rhsElementType instanceof IntLiteralType) {
          [typeNode, location] = generalizeType(lhsElementType);
        } else if (rhsElementType instanceof StringLiteralType) {
          typeNode = generalizeType(lhsElementType)[0];
          location = DataLocation.Memory;
        } else {
          [typeNode, location] = generalizeType(rhsElementType);
        }
        const typeName = typeNameFromTypeNode(typeNode, ast);
        const decl = new VariableDeclaration(
          ast.reserveId(),
          node.src,
          true, // constant
          false, // indexed
          this.eGenTuple.next().value,
          block.id,
          false, // stateVariable
          location ?? DataLocation.Default,
          StateVariableVisibility.Default,
          Mutability.Constant,
          typeNode.pp(),
          undefined,
          typeName,
        );
        ast.setContextRecursive(decl);
        return [child, decl];
      }),
    );

    const tempTupleDeclaration = new VariableDeclarationStatement(
      ast.reserveId(),
      node.src,
      lhs.vOriginalComponents.map((n) => (n === null ? null : tempVars.get(n)?.id ?? null)),
      [...tempVars.values()],
      node.vRightHandSide,
    );

    const assignments = [...tempVars.entries()]
      .filter(([_, tempVar]) => tempVar.storageLocation !== DataLocation.CallData)
      .map(
        ([target, tempVar]) =>
          new ExpressionStatement(
            ast.reserveId(),
            node.src,
            new Assignment(
              ast.reserveId(),
              node.src,
              target.typeString,
              '=',
              target,
              createIdentifier(tempVar, ast, undefined, node),
            ),
          ),
      )
      .reverse();

    block.appendChild(tempTupleDeclaration);
    assignments.forEach((n) => block.appendChild(n));
    ast.setContextRecursive(block);
    return block;
  }

  splitFunctionCallWithoutReturn(node: FunctionCall, ast: AST): void {
    // If returns nothing then the function can be called in a previous statement and
    // replace this call with an empty tuple
    const parent = node.parent;
    assert(parent !== undefined, `${printNode(node)} ${node.vFunctionName} has no parent`);
    ast.replaceNode(node, createEmptyTuple(ast));
    ast.insertStatementBefore(parent, createExpressionStatement(ast, node));
  }

  splitFunctionCallWithReturn(node: FunctionCall, returnType: VariableDeclaration, ast: AST): void {
    assert(
      returnType.vType !== undefined,
      'Return types should not be undefined since solidity 0.5.0',
    );
    const location =
      generalizeType(safeGetNodeType(node, ast.compilerVersion))[1] ?? DataLocation.Default;
    const replacementVariable = new VariableDeclaration(
      ast.reserveId(),
      node.src,
      true, // constant
      false, // indexed
      this.eGen.next().value,
      ast.getContainingScope(node),
      false, // stateVariable
      location,
      StateVariableVisibility.Private,
      Mutability.Constant,
      returnType.typeString,
      undefined, // documentation
      cloneASTNode(returnType.vType, ast),
    );
    const declaration = createVariableDeclarationStatement(
      [replacementVariable],
      cloneASTNode(node, ast),
      ast,
    );
    const temp_var = declaration.vDeclarations[0];

    // a = f() + 5
    // ~>
    // __warp_se = f()
    // a = __warp_se + 5
    ast.insertStatementBefore(node, declaration);
    ast.replaceNode(node, createIdentifier(temp_var, ast));
  }

  splitReturnTuple(node: Return, ast: AST): VariableDeclarationStatement {
    const returnExpression = node.vExpression;
    assert(
      returnExpression !== undefined,
      `Tuple return ${printNode(node)} has undefined value. Expects ${
        node.vFunctionReturnParameters.vParameters.length
      } parameters`,
    );
    const vars = node.vFunctionReturnParameters.vParameters.map((v) => cloneASTNode(v, ast));
    const replaceStatement = createVariableDeclarationStatement(vars, returnExpression, ast);
    ast.insertStatementBefore(node, replaceStatement);

    node.vExpression = new TupleExpression(
      ast.reserveId(),
      '',
      returnExpression.typeString,
      false, // isInlineArray
      vars.map((v) => createIdentifier(v, ast, undefined, node)),
    );
    ast.registerChild(node.vExpression, node);

    return replaceStatement;
  }
}

function identifierReferenceStateVar(id: Identifier) {
  const refDecl = id.vReferencedDeclaration;
  return (
    refDecl instanceof VariableDeclaration &&
    refDecl.getClosestParentByType(ContractDefinition)?.id === refDecl.scope
  );
}
