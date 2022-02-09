import {
  ExpressionStatement,
  FunctionDefinition,
  Return,
  Statement,
  StatementWithChildren,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { analyseControlFlow } from '../utils/controlFlowAnalyser';

export class UnreachableStatementPruner extends ASTMapper {
  reachableStatements: Set<Statement> = new Set();

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    if (body === undefined) return;

    const controlFlows = analyseControlFlow(body);
    controlFlows.forEach((flow) =>
      flow.forEach((statement) => {
        this.reachableStatements.add(statement);
      }),
    );

    this.commonVisit(node, ast);
  }

  visitExpressionStatement(node: ExpressionStatement, _ast: AST): void {
    this.visitStatement(node);
  }

  visitReturn(node: Return, _ast: AST): void {
    this.visitStatement(node);
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, _ast: AST): void {
    this.visitStatement(node);
  }

  visitStatement(node: Statement): void {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    if (containingFunction === undefined) return;

    const containingBlock = node.getClosestParentByType(StatementWithChildren);
    if (containingBlock === undefined) return;

    if (!this.reachableStatements.has(node)) {
      containingBlock.removeChild(node);
    }
  }
}
