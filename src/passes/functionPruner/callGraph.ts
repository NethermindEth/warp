import assert from 'assert';
import {
  Expression,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  IdentifierPath,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';

export class CallGraphBuilder extends ASTMapper {
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
    this.callGraph.set(node.id, new Set());
    this.commonVisit(node, ast);
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

    const refFuncId = getReferencedFunctionId(node.vExpression);
    if (refFuncId !== undefined) {
      existingCalls.add(refFuncId);
      this.callGraph.set(this.currentFunction.id, existingCalls);
    }

    this.commonVisit(node, ast);
  }

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

function getReferencedFunctionId(node: Expression): number | undefined {
  if (node instanceof Identifier || node instanceof IdentifierPath || node instanceof MemberAccess)
    return node.referencedDeclaration;
  return undefined;
}
