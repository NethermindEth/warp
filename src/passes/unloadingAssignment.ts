import assert from 'assert';
import {
  Assignment,
  BinaryOperation,
  ContractDefinition,
  DataLocation,
  Expression,
  ExpressionStatement,
  FunctionDefinition,
  getNodeType,
  Identifier,
  Literal,
  LiteralKind,
  Mutability,
  StateVariableVisibility,
  UnaryOperation,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { createIdentifier } from '../utils/nodeTemplates';
import { toHexString } from '../utils/utils';

export class UnloadingAssignment extends ASTMapper {
  lastUsedTempVar = 0;

  // When assignments are not used as statements each value change is
  // stored in a temporal var which will hold the value of the assignment
  // as an expression
  private handleAssignmentAsExpressionOnly(node: Assignment, ast: AST) {
    assert(
      node.vLeftHandSide instanceof Identifier,
      `Assignment left hand side must be an Identifier, intead ${printNode(node)} was found`,
    );

    let scope = node.getClosestParentByType(FunctionDefinition)?.id;
    scope = scope === undefined ? node.getClosestParentByType(ContractDefinition)?.id : scope;
    assert(scope !== undefined, 'Scope for temporal var initialization could not be found');

    const lhs = cloneASTNode(node.vLeftHandSide, ast);
    const rhs = cloneASTNode(node.vRightHandSide, ast);
    const tempVarStatement = createVariableDeclaration(
      `__warp_temp${this.lastUsedTempVar++}`,
      rhs,
      scope,
      ast,
    );
    const realVarAssignmet = createAssignmentStatement(
      '=',
      lhs,
      createIdentifier(tempVarStatement.vDeclarations[0], ast),
      ast,
    );

    ast.insertStatementBefore(node, tempVarStatement);
    ast.insertStatementBefore(node, realVarAssignmet);
    ast.replaceNode(node, createIdentifier(tempVarStatement.vDeclarations[0], ast));
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (node.operator === '=' && !(node.getParents()[0] instanceof ExpressionStatement)) {
      const inmediateParent = node.getParents()[0];
      // Create temp vars only when handling local vars which are not directly
      // encapsulated on an ExpressionStatement
      if (
        !(inmediateParent instanceof ExpressionStatement) &&
        node.vLeftHandSide instanceof Identifier &&
        !identifierReferenceStateVar(node.vLeftHandSide)
      ) {
        return this.handleAssignmentAsExpressionOnly(node, ast);
      }

      return this.visitExpression(node, ast);
    }

    const lhsValue = cloneASTNode(node.vLeftHandSide, ast);
    // Extract e.g. "+" from "+="
    const operator = node.operator.slice(0, node.operator.length - 1);
    node.operator = '=';
    ast.replaceNode(
      node.vRightHandSide,
      new BinaryOperation(
        ast.reserveId(),
        node.src,
        node.typeString,
        operator,
        lhsValue,
        node.vRightHandSide,
      ),
      node,
    );

    this.visitExpression(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (node.operator !== '++' && node.operator !== '--') {
      return this.commonVisit(node, ast);
    }

    const literalOne = new Literal(
      ast.reserveId(),
      node.src,
      'int_const 1',
      LiteralKind.Number,
      toHexString('1'),
      '1',
    );

    const compoundAssignment = new Assignment(
      node.id,
      node.src,
      node.typeString,
      `${node.operator[0]}=`,
      node.vSubExpression,
      literalOne,
    );

    if (!node.prefix) {
      const subtraction = new BinaryOperation(
        node.id,
        node.src,
        node.typeString,
        node.operator === '++' ? '-' : '+',
        compoundAssignment,
        cloneASTNode(literalOne, ast),
      );
      compoundAssignment.id = ast.reserveId();
      ast.replaceNode(node, subtraction);
      this.dispatchVisit(subtraction, ast);
    } else {
      ast.replaceNode(node, compoundAssignment);
      this.dispatchVisit(compoundAssignment, ast);
    }
  }
}

function createVariableDeclaration(name: string, initalValue: Expression, scope: number, ast: AST) {
  const varDecl = new VariableDeclarationStatement(
    ast.reserveId(),
    '',
    [],
    [
      new VariableDeclaration(
        ast.reserveId(),
        '',
        false,
        false,
        name,
        scope,
        false,
        DataLocation.Default,
        StateVariableVisibility.Internal,
        Mutability.Mutable,
        initalValue.typeString,
      ),
    ],
    initalValue,
  );
  return varDecl;
}

function createAssignmentStatement(operator: string, lhs: Expression, rhs: Expression, ast: AST) {
  return new ExpressionStatement(
    ast.reserveId(),
    '',
    new Assignment(ast.reserveId(), '', lhs.typeString, operator, lhs, rhs),
  );
}

function identifierReferenceStateVar(id: Identifier) {
  const refDecl = id.vReferencedDeclaration;
  return (
    refDecl instanceof VariableDeclaration &&
    refDecl.getClosestParentByType(ContractDefinition)?.id === refDecl.scope
  );
}
