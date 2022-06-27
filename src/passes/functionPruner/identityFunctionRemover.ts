import assert from 'assert';
import {
  Expression,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  Return,
  TupleExpression,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { isExternallyVisible, toSingleExpression } from '../../utils/utils';

export class IdentityFunctionRemover extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST) {
    if (!isExternallyVisible(node) && this.isIdentity(node)) {
      const order = this.getArgsOrder(node);
      this.replaceNodeReferences(node, order, ast);

      // Remove this function
      const parent = node.vScope;
      parent.removeChild(node);
    } else this.commonVisit(node, ast);
  }

  isIdentity(node: FunctionDefinition): boolean {
    if (node.vBody !== undefined) {
      const statements = node.vBody.vStatements;
      if (statements.length == 1) {
        const stmt = statements[0];
        if (stmt instanceof Return) {
          const retExpr = stmt.vExpression;
          if (retExpr !== undefined) {
            if (retExpr instanceof Identifier) {
              return checkParamsLength(node, 1) && checkIdentifierInParams(retExpr, node);
            } else if (retExpr instanceof TupleExpression) {
              const exprList = retExpr.vOriginalComponents;
              return (
                checkParamsLength(node, exprList.length) && allElementsInParams(exprList, node)
              );
            }
          }
        }
      }
    }
    return false;
  }

  getArgsOrder(node: FunctionDefinition) {
    assert(
      node.vBody !== undefined,
      `Expected a Block in ${printNode(node)}, but got undefined instead`,
    );
    assert(
      node.vBody.vStatements.length == 1,
      `Expected only one statement in ${printNode(node.vBody)}`,
    );
    const stmt = node.vBody.vStatements[0];
    assert(
      stmt instanceof Return,
      `Expected a Return statement but got ${printNode(stmt)} instead`,
    );
    assert(
      stmt.vExpression !== undefined,
      `Expected a return expression in ${printNode(stmt)}, but got undefined instead`,
    );

    const retExpr = stmt.vExpression;
    if (retExpr instanceof Identifier) return [0];

    assert(
      retExpr instanceof TupleExpression,
      `Expected TupleExpression, but got ${printNode(retExpr)} instead`,
    );
    const exprList = retExpr.vOriginalComponents;
    return exprList.reduce((res, expr) => [...res, getIndexOf(expr, node)], new Array<number>());
  }

  replaceNodeReferences(node: FunctionDefinition, order: number[], ast: AST): void {
    ast.roots.forEach((root) => {
      root.walk((n) => {
        if (n instanceof FunctionCall) {
          const refFunc = n.vReferencedDeclaration;
          if (refFunc !== undefined && refFunc instanceof FunctionDefinition && refFunc === node) {
            const exprList = order.reduce(
              (res, idx) => [...res, n.vArguments[idx]],
              new Array<Expression>(),
            );
            const retExpr = toSingleExpression(exprList, ast);
            ast.replaceNode(n, retExpr);
          }
        }
      });
    });
  }
}

function checkParamsLength(node: FunctionDefinition, length: number) {
  return node.vParameters.vParameters.length == length;
}

function checkIdentifierInParams(expr: Identifier, node: FunctionDefinition): boolean {
  return node.vParameters.vParameters.some((param) => param.id === expr.referencedDeclaration);
}

function allElementsInParams(exprList: (Expression | null)[], node: FunctionDefinition): boolean {
  return exprList.every((expr) => {
    if (expr !== null && expr instanceof Identifier) return checkIdentifierInParams(expr, node);
    else return false;
  });
}

function getIndexOf(expr: Expression | null, node: FunctionDefinition): number {
  assert(expr !== null, `Expected expression but got null instead`);
  assert(expr instanceof Identifier, `Expected Identifier but got ${printNode(expr)} instead`);

  const parameters = node.vParameters.vParameters;
  const varDec = parameters.find((param) => param.id == expr.referencedDeclaration);
  assert(
    varDec !== undefined,
    `${printNode(expr)} should be referencing one of the function's parameters`,
  );
  return parameters.indexOf(varDec);
}
