import { ASTNode, FunctionCall, FunctionDefinition } from 'solc-typed-ast';
import { CairoFunctionCall } from '../ast/cairoNodes';
import { AST, ASTMapper } from '../ast/mapper';

export type CallGraph = Map<FunctionDefinition, Map<FunctionDefinition, undefined>>;

export class CallGraphBuilder extends ASTMapper {
  callGraph: CallGraph = new Map();

  lastVisitedFunction: FunctionDefinition;

  gather(ast: AST): CallGraph {
    super.map(ast);
    return this.callGraph;
  }

  visitFunctionDefinition(node: FunctionDefinition): ASTNode {
    this.lastVisitedFunction = node;
    this.callGraph.set(node, new Map());
    return super.commonVisit(node);
  }

  visitFunctionCall(node: FunctionCall): ASTNode {
    if (node.vReferencedDeclaration instanceof FunctionDefinition)
      this.callGraph
        .get(this.lastVisitedFunction)
        .set(node.vReferencedDeclaration as FunctionDefinition, undefined);
    return super.commonVisit(node);
  }

  visitCairoFunctionCall(node: CairoFunctionCall): ASTNode {
    if (node.vReferencedDeclaration instanceof FunctionDefinition)
      this.callGraph
        .get(this.lastVisitedFunction)
        .set(node.vReferencedDeclaration as FunctionDefinition, undefined);
    return super.commonVisit(node);
  }
}
