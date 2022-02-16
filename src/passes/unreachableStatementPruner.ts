import { FunctionDefinition, Statement, StatementWithChildren } from 'solc-typed-ast';
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
  visitStatement(node: Statement, ast: AST): void {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    if (containingFunction === undefined) return;
    const containingBlock = node.getClosestParentByType(StatementWithChildren);
    if (containingBlock === undefined) return;
    if (!this.reachableStatements.has(node)) {
      containingBlock.removeChild(node);
    } else {
      this.commonVisit(node, ast);
    }
  }
}
