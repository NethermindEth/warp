import { Block, ExpressionStatement, FunctionVisibility, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, CairoReturnMemoryFinalizer } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';

// Change name to ReturnWarpmMemoryFinalizer
//
export class ReturnMemoryFinalizer extends ASTMapper {
  constructor() {
    super();
  }

  visitReturn(node: Return, ast: AST): void {
    const funcParent = node.getClosestParentByType(CairoFunctionDefinition);
    if (
      funcParent === undefined ||
      !funcParent.implicits.has('warp_memory') ||
      !(
        funcParent.visibility === FunctionVisibility.External ||
        funcParent.visibility === FunctionVisibility.Public
      )
    ) {
      return;
    }

    const temp = new CairoReturnMemoryFinalizer(
      node.id,
      node.src,
      node.functionReturnParameters,
      node.vExpression,
      node.documentation,
      node.raw,
    );
    console.log(`replacing return in ${printNode(funcParent)}`);
    console.log(funcParent.print());

    ast.replaceNode(
      node,
      new CairoReturnMemoryFinalizer(
        node.id,
        node.src,
        node.functionReturnParameters,
        node.vExpression,
        node.documentation,
        node.raw,
      ),
    );
  }
}
