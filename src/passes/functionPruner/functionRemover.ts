import assert from 'assert';
import { ContractDefinition, FunctionDefinition, SourceUnit } from 'solc-typed-ast';
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

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.removeUnreachableFunctions(node, ast);
    this.commonVisit(node, ast);
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST) {
    this.removeUnreachableFunctions(node, _ast);
  }

  removeUnreachableFunctions(node: SourceUnit | ContractDefinition, ast: AST) {
    const reachableFunctions: Set<number> = new Set();
    // Collect visible functions and obtain ids of all reachable functions
    node.vFunctions
      .filter((func) => isExternallyVisible(func))
      .forEach((func) => this.dfs(func, reachableFunctions));
    // Remove unreachable functions
    node.vFunctions
      .filter((func) => !reachableFunctions.has(func.id))
      .forEach((func) => {
        node.removeChild(func);
        const utilFunGen = ast.getUtilFuncGen(node);
        utilFunGen.removeGeneratedFunction(func.name);
      });
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
