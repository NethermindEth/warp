import { FunctionVisibility, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, CairoReturnMemoryFinalizer } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';

export class ReturnMemoryFinalizer extends ASTMapper {
  /*
  This class replace all return statements with a special return stape that sepcifies
  that warp_memory should be finalize before returning when transpiling.
  The return statements are only replaced when the Cairo Function has warp_memory as an
  implicit parameter and it is an external function
  */
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
