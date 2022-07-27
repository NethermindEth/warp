import { FunctionDefinition, Statement, StatementWithChildren } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { collectReachableStatements } from '../utils/controlFlowAnalyser';
import { union } from '../utils/utils';
export class UnreachableStatementPruner extends ASTMapper {
  reachableStatements: Set<Statement> = new Set();

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    if (body === undefined) return;
    this.reachableStatements = union(this.reachableStatements, collectReachableStatements(body));
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
