import assert from 'assert';
import { FunctionCall, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';

export class CallGraphBuilder extends ASTMapper {
  // callGraph represents a directed graph where:
  //   - node: it contains the id of a function definition
  //   - edges: if there is an edge between node 'a' and node 'b', it means the
  //            function definition that has the id of node 'a', has, as one of
  //            the statements in its body, a call to the function that has the
  //            id of node 'b'
  callGraph: Map<number, Set<number>>;
  functionId: Map<number, FunctionDefinition>;
  currentFunction: FunctionDefinition | undefined;

  constructor() {
    super();
    this.callGraph = new Map();
    this.functionId = new Map();
    this.currentFunction = undefined;
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST) {
    this.currentFunction = node;
    this.functionId.set(node.id, node);
    this.callGraph.set(node.id, new Set());
    this.commonVisit(node, ast);
    this.currentFunction = undefined;
  }

  visitCairoGeneratedFunctionDefinition(node: CairoGeneratedFunctionDefinition, ast: AST): void {
    this.currentFunction = node;
    this.functionId.set(node.id, node);
    this.callGraph.set(node.id, new Set(node.functionsCalled.map((funcDef) => funcDef.id)));
    node.functionsCalled.forEach((funcDef) => this.commonVisit(funcDef, ast));
    this.currentFunction = undefined;
  }

  visitFunctionCall(node: FunctionCall, ast: AST) {
    assert(
      this.currentFunction !== undefined,
      `Function Call ${printNode(node)} outside FunctionDefinition`,
    );
    const existingCalls = this.callGraph.get(this.currentFunction.id);
    assert(
      existingCalls !== undefined,
      `${printNode(this.currentFunction)} should have been added to the map`,
    );
    const refFunc = node.vReferencedDeclaration;
    if (refFunc instanceof FunctionDefinition) {
      existingCalls.add(refFunc.id);
      this.callGraph.set(this.currentFunction.id, existingCalls);
    }

    this.commonVisit(node, ast);
  }

  // Returns the call-graph with the actual functions nodes instead of its ids
  getFunctionGraph(): Map<number, FunctionDefinition[]> {
    return new Map(
      [...this.callGraph].map(([funcId, callFuncs]) => {
        // If the callFunction id was not added to functionId map (undefined is returned) it
        // means it is an external function call, so it can be ignored
        const functions = [...callFuncs]
          .map((id) => this.functionId.get(id))
          .filter((func): func is FunctionDefinition => func !== undefined);
        return [funcId, functions];
      }),
    );
  }
}
