import assert from 'assert';
import {
  Assignment,
  Conditional,
  DataLocation,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
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
import { ExpressionSplitter } from '../expressionSplitter';
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

/** This pass handles several features:
      - Conditionals
      - Expression Splitting
      - Tuple Assignment Splitting

    1. CONDITIONALS:
    Every conditional is handled such that a new function is generated. The
    idea would be to have the following conditional:
        
        condition ? thenBranch : elseBranch

    and generate a function with the following structure: 

      function __warp_conditional():
        if (condition)
          return thenBranch
        else return elseBranch

    In addition this function needs to capture all local variables used inside
    the conditional and pass them as parameters. Those variables need to be
    returned as well since its value might have been changed inside the conditional.

    A variable `conditionalResult` is also created to capture the result of the 
    conditional itself. When `__warp_conditional()` is called, its return value needs 
    to be assigned to `conditionalResult` and all the local variables that were
    captured by the function; in order to do so the necessary statements are added
    before the statement where the conditional was.

    Finally, the conditional is replaced with `conditionalResult`. Notice that 
    conditionals might return more than one value or no value at all. This cases
    are handled as well.

    2. EXPRESSION SPLITTING:
    If the splitting of expressions is performed before handling conditionals, both
    branches of a conditional might get extracted and evaluated before actually having
    to execute the conditional, which breaks the idea of conditionals only evaluating 
    one of its branches. An example of this is the following case:

      condition ? f() : g()

    which is transformed into:

      __warp_var_1 = f();
      __warp_var_2 = g();
      condition ? __warp_var_1 : __warp_var_2

    If the splitting of expressions is performed after handling conditionals, there
    might be the case where one of the local variables (that is used inside the conditional)
    changes its value in the same statement where the conditional is, which means that 
    change will not be reflected when extracting the conditional to a function. A simple
    example:
      
      f(y = 5, true ? y : 0)
    
    Handling the conditional first will result in:

      (conditionalResult, y) = __warp_conditional(y)
      f(y = 5, conditionalResult)

    which is not correct since `y` needs to be assigned first
    
    As the splitting of expressions can not happen before nor after handling conditionals,
    they have to be handled together.

    Because is needed to handle together conditionals and other expression splitting this pass
    inherit from ExpressionSplitter. The visitAssignment function is the same for both passes, 
    but visitFunctionCall have a different strategy to compute the data location of the variable 
    that will store the call, so its definition is overwritten.

    3. TUPLE ASSINGMENT SPLITTING:
    Converts a non-declaration tuple assignment into a declaration of temporary variables,
    and piecewise assignments (x,y) = (y,x) -> (int a, int b) = (y,x); x = a; y = b;

    Also converts tuple returns into a tuple declaration and elementwise return
    This allows type conversions in cases where the individual elements would otherwise not be
    accessible, such as when returning a function call

    This is handled before the expression splitting in order to handle assignments correctly.
    After handling conditionals, the statement where the function call is assigned to all
    the corresponding variables needs to be handled by this pass as well. That's why the 
    splitting of tuple assignments is done in this pass as well.
 */

export class ConditionalSplitter extends ExpressionSplitter {
  eGen = expressionGenerator(PRE_SPLIT_EXPRESSION_PREFIX);
  eGenTuple = expressionGenerator(TUPLE_VALUE_PREFIX);
  nameCounter = counterGenerator();

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      // Short circuiting of and/or expressions must be handled before
      // extracting expressions with this splitter, otherwise both
      // expressions (left and right in that operation) might get evaluated.
      'Sc',
      // Assignments operator is assumed to be '=', so the other possible
      // operators like '+=' or '*=' need to be handled first, which is done
      // in UnloadingAssignment pass
      'U',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    let visitNode: ASTNode = node;
    if (
      node.vExpression instanceof Assignment &&
      node.vExpression.vLeftHandSide instanceof TupleExpression
    ) {
      visitNode = this.splitTupleAssignment(node.vExpression, ast);
      ast.replaceNode(node, visitNode);
    }

    this.commonVisit(visitNode, ast);
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
        `ConditionalSplitter expects functions to have at most 1 return argument. ${printNode(
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
