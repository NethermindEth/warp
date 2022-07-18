import { Assignment, BinaryOperation, UnaryOperation } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { createNumberLiteral } from '../utils/nodeTemplates';

export class UnloadingAssignment extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
      'Rv',
      'If',
      'T',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (node.operator === '=') {
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
}
