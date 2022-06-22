import assert from 'assert';
import { ContractDefinition, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { isExternallyVisible } from '../../utils/utils';

export class FunctionRemover extends ASTMapper {
  functionGraph: Map<number, FunctionDefinition[]>;

  constructor(graph: Map<number, FunctionDefinition[]>) {
    super();
    this.functionGraph = graph;
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST) {
    const reachableFunctions: Set<number> = new Set();
    // Collect visible functions and obtain ids of all reachable functions
    node.vFunctions
      .filter((func) => isExternallyVisible(func))
      .forEach((func) => this.dfs(func, reachableFunctions));
    // Remove unreachable functions
    node.vFunctions
      .filter((func) => !reachableFunctions.has(func.id))
      .forEach((func) => node.removeChild(func));
  }

  dfs(f: FunctionDefinition, visited: Set<number>): void {
    visited.add(f.id);

    const functions = this.functionGraph.get(f.id);
    assert(functions !== undefined, `Function ${printNode(f)} was not added to the functionGraph`);
    functions.forEach((f) => {
      if (!visited.has(f.id)) this.dfs(f, visited);
    });
  }
}
