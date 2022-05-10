import assert from 'assert';
import {
  Assignment,
  ContractDefinition,
  DataLocation,
  Expression,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { TranspileFailedError } from '../utils/errors';
import { createEmptyTuple, createIdentifier } from '../utils/nodeTemplates';
import { counterGenerator } from '../utils/utils';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}_${count.next().value}`;
  }
}

export class ExpressionSplitter extends ASTMapper {
  eGen = expressionGenerator('__warp_se');

  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);
    if (!(node.parent instanceof ExpressionStatement)) {
      // No need to create temp vars for state vars
      if (
        node.vLeftHandSide instanceof Identifier &&
        identifierReferenceStateVar(node.vLeftHandSide)
      ) {
        return;
      }

      const leftHandSide = cloneASTNode(node.vLeftHandSide, ast);
      const rightHandSide = cloneASTNode(node.vRightHandSide, ast);

      const tempVarStatement = createVariableDeclaration(
        this.eGen.next().value,
        rightHandSide,
        ast.getContainingScope(node),
        ast,
      );
      const tempVar = tempVarStatement.vDeclarations[0];

      const updateVal = createAssignmentStatement(
        '=',
        leftHandSide,
        createIdentifier(tempVar, ast),
        ast,
      );

      ast.insertStatementBefore(node, tempVarStatement);
      ast.insertStatementBefore(node, updateVal);
      ast.replaceNode(node, createIdentifier(tempVar, ast));
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    // TODO implement this for other instances
    // TODO check how vReferencedDeclaration works for functions like require
    // TODO don't split tail recursion unless necessary (can be necessary because of implicit arguments/returns)
    if (
      !(node.vReferencedDeclaration instanceof FunctionDefinition) ||
      node.parent instanceof ExpressionStatement ||
      node.parent instanceof VariableDeclarationStatement
    ) {
      return;
    }

    const returnTypes = node.vReferencedDeclaration.vReturnParameters.vParameters;
    if (returnTypes.length === 0) {
      const parent = node.parent;
      assert(parent !== undefined, `${printNode(node)} ${node.vFunctionName} has no parent`);
      ast.replaceNode(node, createEmptyTuple(ast));
      ast.insertStatementBefore(parent, new ExpressionStatement(ast.reserveId(), '', node));
    } else if (returnTypes.length === 1) {
      assert(
        returnTypes[0].vType !== undefined,
        'Return types should not be undefined since solidity 0.5.0',
      );
      ast.extractToConstant(node, cloneASTNode(returnTypes[0].vType, ast), this.eGen.next().value);
    } else {
      throw new TranspileFailedError(
        `ExpressionSplitter expects functions to have at most 1 return argument. ${printNode(
          node,
        )} ${node.vFunctionName} has ${returnTypes.length}`,
      );
    }
  }
}

function identifierReferenceStateVar(id: Identifier) {
  const refDecl = id.vReferencedDeclaration;
  return (
    refDecl instanceof VariableDeclaration &&
    refDecl.getClosestParentByType(ContractDefinition)?.id === refDecl.scope
  );
}

function createVariableDeclaration(name: string, initalValue: Expression, scope: number, ast: AST) {
  const varDecl = new VariableDeclaration(
    ast.reserveId(),
    '',
    false,
    false,
    name,
    scope,
    false,
    DataLocation.Memory,
    StateVariableVisibility.Internal,
    Mutability.Constant,
    initalValue.typeString,
  );
  ast.setContextRecursive(varDecl);

  const varDeclStatement = new VariableDeclarationStatement(
    ast.reserveId(),
    '',
    [varDecl.id],
    [varDecl],
    initalValue,
  );
  return varDeclStatement;
}

function createAssignmentStatement(operator: string, lhs: Expression, rhs: Expression, ast: AST) {
  return new ExpressionStatement(
    ast.reserveId(),
    '',
    new Assignment(ast.reserveId(), '', lhs.typeString, operator, lhs, rhs),
  );
}
