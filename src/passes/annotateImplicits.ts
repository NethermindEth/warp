import { FunctionDefinition, ASTNode } from 'solc-typed-ast';
import { CairoFunctionCall, CairoStorageVariable } from '../ast/cairoNodes';
import { AST, ASTMapper } from '../ast/mapper';
import { CallGraph, CallGraphBuilder } from '../utils/callGraphBuilder';
import { implicitImports, Implicits } from '../utils/implicits';
import { union } from '../utils/utils';

// TODO: Make a new node for CairoFunctionDefiniton with the implicits in it instead of a external
// mapping.
export class AnnotateImplicits extends ASTMapper {
  implicitsForLastFunction: Set<Implicits> = new Set();

  map(ast: AST): AST {
    ast = super.map(ast);

    const callGraph: CallGraph = new CallGraphBuilder().gather(ast);
    for (const [node, callees] of callGraph.entries()) {
      for (const funDef of callees.keys()) {
        const calleeImplicits = this.functionImplicits.get(funDef.name) || new Set([]);
        const callerImplicits = this.functionImplicits.get(node.name);
        const implicits = union(callerImplicits, calleeImplicits);
        this.functionImplicits.set(node.name, implicits);
        implicits.forEach((i: Implicits) => this.addImport(implicitImports[i]));
      }
    }

    return ast;
  }

  visitFunctionDefinition(n: FunctionDefinition): ASTNode {
    const node = super.commonVisit(n);
    this.functionImplicits.set(n.name, this.implicitsForLastFunction);
    this.implicitsForLastFunction = new Set();
    return node;
  }

  visitCairoFunctionCall(node: CairoFunctionCall): ASTNode {
    this.implicitsForLastFunction = union(this.implicitsForLastFunction, node.implicits);
    return super.commonVisit(node);
  }

  visitCairoStorageVariable(node: CairoStorageVariable): ASTNode {
    ['pedersen_ptr', 'syscall_ptr', 'range_check_ptr'].forEach((i: Implicits) =>
      this.implicitsForLastFunction.add(i),
    );
    return super.commonVisit(node);
  }
}
