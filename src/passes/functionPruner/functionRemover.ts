import assert from 'assert';
import { ContractDefinition, FunctionDefinition, SourceUnit } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { isExternallyVisible } from '../../utils/utils';

export class FunctionRemover extends ASTMapper {
  functionGraph: Map<number, FunctionDefinition[]>;
  reachableFunctions: Set<string>;
  reachableFunctionsFromRemovedFunctions: Set<string>;

  constructor(graph: Map<number, FunctionDefinition[]>) {
    super();
    this.functionGraph = graph;
    this.reachableFunctions = new Set();
    this.reachableFunctionsFromRemovedFunctions = new Set();
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);

    this.collectReachableFunctions(node);
    const utilFunGen = ast.getUtilFuncGen(node);

    // Remove unreachable functions
    node.vFunctions
      .filter(
        (func) =>
          this.reachableFunctionsFromRemovedFunctions.has(func.name) &&
          !this.reachableFunctions.has(func.name),
      )
      .forEach((func) => {
        node.removeChild(func);
        utilFunGen.removeGeneratedFunction(func.name);
      });
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST) {
    this.collectReachableFunctions(node);

    // Remove unreachable functions
    node.vFunctions
      .filter((func) => !this.reachableFunctions.has(func.name))
      .forEach((func) => {
        node.removeChild(func);
        this.dfs(func, this.reachableFunctionsFromRemovedFunctions);
      });
  }

  collectReachableFunctions(node: SourceUnit | ContractDefinition) {
    // Collect visible functions and obtain ids of all reachable functions
    node.vFunctions
      .filter((func) => isExternallyVisible(func))
      .forEach((func) => this.dfs(func, this.reachableFunctions));
  }

  dfs(f: FunctionDefinition, visited: Set<string>): void {
    visited.add(f.name);

    const functions = this.functionGraph.get(f.id);
    assert(functions !== undefined, `Function ${printNode(f)} was not added to the functionGraph`);
    functions.forEach((f) => {
      if (!visited.has(f.name)) this.dfs(f, visited);
    });
  }
}
