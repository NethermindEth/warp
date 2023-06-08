import assert from 'assert';
import { ContractDefinition, FunctionDefinition, SourceUnit } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { isExternallyVisible } from '../../utils/utils';
import { CairoImportFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';

export class FunctionRemover extends ASTMapper {
  private functionGraph: Map<number, FunctionDefinition[]>;
  private reachableFunctions: Set<number>;

  constructor(graph: Map<number, FunctionDefinition[]>) {
    super();
    this.functionGraph = graph;
    this.reachableFunctions = new Set();
  }

  importFuncFilter = (funcs: readonly FunctionDefinition[]) =>
    funcs
      .filter((func) => !this.reachableFunctions.has(func.id))
      .filter(
        (func) =>
          !(
            func instanceof CairoImportFunctionDefinition &&
            func.functionStubKind === FunctionStubKind.TraitStructDefStub
          ),
      );

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vFunctions.filter((func) => isExternallyVisible(func)).forEach((func) => this.dfs(func));

    node.vContracts.forEach((c) => this.visitContractDefinition(c, ast));

    this.importFuncFilter(node.vFunctions).forEach((func) => node.removeChild(func));
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST) {
    // Collect visible functions and obtain ids of all reachable functions
    node.vFunctions.filter((func) => isExternallyVisible(func)).forEach((func) => this.dfs(func));

    // Remove unreachable functions
    this.importFuncFilter(node.vFunctions).forEach((func) => node.removeChild(func));
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
