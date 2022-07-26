import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { CallGraphBuilder } from './callGraph';
import { FunctionRemover } from './functionRemover';

export class UnreachableFunctionPruner extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const graph = new CallGraphBuilder();
      graph.dispatchVisit(root, ast);
      new FunctionRemover(graph.getFunctionGraph()).dispatchVisit(root, ast);
    });
    return ast;
  }
}
