import assert from 'assert';
import { ContractDefinition, FunctionDefinition, SourceUnit } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { isExternallyVisible } from '../../utils/utils';

export class FunctionRemover extends ASTMapper {
  private functionGraph: Map<number, FunctionDefinition[]>;
  private reachableFunctions: Set<number>;

  constructor(graph: Map<number, FunctionDefinition[]>) {
    super();
    this.functionGraph = graph;
    this.reachableFunctions = new Set();
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vFunctions.filter((func) => isExternallyVisible(func)).forEach((func) => this.dfs(func));

    node.vContracts.forEach((c) => this.visitContractDefinition(c, ast));

    node.vFunctions
      .filter((func) => !this.reachableFunctions.has(func.id))
      .forEach((func) => {
        console.log('removing', func.name);
        node.removeChild(func);
      });
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST) {
    // Collect visible functions and obtain ids of all reachable functions
    node.vFunctions.filter((func) => isExternallyVisible(func)).forEach((func) => this.dfs(func));

    // Remove unreachable functions
    node.vFunctions
      .filter((func) => !this.reachableFunctions.has(func.id))
      .forEach((func) => node.removeChild(func));
  }

  dfs(f: FunctionDefinition): void {
    this.reachableFunctions.add(f.id);

    const functions = this.functionGraph.get(f.id);
    assert(functions !== undefined, `Function ${printNode(f)} was not added to the functionGraph`);
    functions.forEach((f) => {
      if (!this.reachableFunctions.has(f.id)) this.dfs(f);
    });
  }
}
