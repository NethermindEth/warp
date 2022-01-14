import assert = require('assert');
import {
  Assignment,
  Block,
  DataLocation,
  ElementaryTypeName,
  Expression,
  ExpressionStatement,
  Identifier,
  Mutability,
  StateVariableVisibility,
  TupleExpression,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

// Converts a non-declaration tuple assignment into a declaration of temporary variables,
// and piecewise assignments (x,y) = (y,x) -> (int a, int b) = (y,x); x = a; y = b;

// TODO fix or rule out edge cases where assignment is not direct child of expressionstatement
export class TupleAssignmentSplitter extends ASTMapper {
  lastTempVarNumber = 0;
  newTempVarName(): string {
    return `__warp_tv_${this.lastTempVarNumber++}`;
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vExpression instanceof Assignment) {
      if (node.vExpression.vLeftHandSide instanceof TupleExpression) {
        ast.replaceNode(node, this.splitTupleAssignment(node.vExpression, ast));
      }
    }
  }

  splitTupleAssignment(node: Assignment, ast: AST): Block {
    const lhs = node.vLeftHandSide;
    assert(
      lhs instanceof TupleExpression,
      `Split tuple assignment was called on non-tuple assignment ${node.type} # ${node.id}`,
    );

    const block = new Block(ast.reserveId(), node.src, 'Block', []);
    const blockId = ast.setContextRecursive(block);

    const tempVars = new Map<Expression, VariableDeclaration>(
      lhs.vOriginalComponents
        .filter((n): n is Expression => n !== null)
        .map((child) => {
          // TODO cover all edge cases surrounding which type of typename can go here
          const typeName = new ElementaryTypeName(
            ast.reserveId(),
            node.src,
            'ElementaryTypeName',
            `${child.typeString}`,
            child.typeString,
          );
          ast.setContextRecursive(typeName);
          const decl = new VariableDeclaration(
            ast.reserveId(),
            node.src,
            'VariableDeclaration',
            true,
            false,
            this.newTempVarName(),
            blockId,
            false,
            DataLocation.Default,
            StateVariableVisibility.Default,
            Mutability.Constant,
            child.typeString,
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
      'VariableDeclarationStatement',
      lhs.vOriginalComponents.map((n) => (n === null ? null : tempVars.get(n)?.id ?? null)),
      [...tempVars.values()],
      node.vRightHandSide,
    );

    const assignments = [...tempVars.entries()].map(
      ([target, tempVar]) =>
        new ExpressionStatement(
          ast.reserveId(),
          node.src,
          'ExpressionStatement',
          new Assignment(
            ast.reserveId(),
            node.src,
            'Assignment',
            target.typeString,
            '=',
            target,
            new Identifier(
              ast.reserveId(),
              node.src,
              'Identifier',
              tempVar.typeString,
              tempVar.name,
              tempVar.id,
            ),
          ),
        ),
    );

    block.appendChild(tempTupleDeclaration);
    assignments.forEach((n) => block.appendChild(n));
    ast.setContextRecursive(block);
    return block;
  }
}
