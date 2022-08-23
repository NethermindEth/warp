import assert from 'assert';
import {
  Assignment,
  BinaryOperation,
  Expression,
  FunctionCall,
  IndexAccess,
  Literal,
  MemberAccess,
  TupleExpression,
  UnaryOperation,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { COMPOUND_ASSIGNMENT_SUBEXPRESSION_PREFIX } from '../utils/nameModifiers';
import { createNumberLiteral } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';

export class UnloadingAssignment extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (node.operator === '=') {
      return this.visitExpression(node, ast);
    }

    this.extractUnstableSubexpressions(node.vLeftHandSide, ast).forEach((decl) =>
      this.dispatchVisit(decl, ast),
    );
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

    const literalOne = createNumberLiteral(1, ast);

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

  // node is the lvalue of a compound assignment
  // this function extracts subexpressions that are not guaranteed to produce the same result every time
  // to constants to evaluate once before the assignment
  // this is needed because extracting to a 'constant' and then assigning to it would not modify the correct variable
  // we also extract non-trivial expressions so they're only calculated once, though this is not technically necessary
  // an array of created statements are returned so they can be visited
  private extractUnstableSubexpressions(
    node: Expression,
    ast: AST,
  ): VariableDeclarationStatement[] {
    if (node instanceof IndexAccess) {
      // a[i++] += 1 -> x = i++; a[x] = a[x] + 1
      assert(
        node.vIndexExpression !== undefined,
        `Unexpected empty index access in compound assignment ${printNode(node)}`,
      );
      if (!(node.vIndexExpression instanceof Literal)) {
        const decl = this.extractIndividualSubExpression(node.vIndexExpression, ast);
        return [decl, ...this.extractUnstableSubexpressions(node.vBaseExpression, ast)];
      }
    } else if (node instanceof MemberAccess) {
      return this.extractUnstableSubexpressions(node.vExpression, ast);
    } else if (node instanceof FunctionCall) {
      return [this.extractIndividualSubExpression(node, ast)];
    } else if (node instanceof TupleExpression) {
      assert(
        node.isInlineArray,
        `unexpected non-inline-array tuple expression in compound assignment ${printNode(node)}`,
      );
      return [this.extractIndividualSubExpression(node, ast)];
    }

    return [];
  }

  counter = 0;
  private extractIndividualSubExpression(node: Expression, ast: AST): VariableDeclarationStatement {
    return ast.extractToConstant(
      node,
      typeNameFromTypeNode(safeGetNodeType(node, ast.compilerVersion), ast),
      `${COMPOUND_ASSIGNMENT_SUBEXPRESSION_PREFIX}${this.counter++}`,
    )[1];
  }
}
