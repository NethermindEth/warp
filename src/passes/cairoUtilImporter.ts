import { ElementaryTypeName, FunctionVisibility } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { primitiveTypeToCairo } from '../utils/utils';

export class CairoUtilImporter extends ASTMapper {
  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    if (primitiveTypeToCairo(node.name) === 'Uint256') {
      ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
    }
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (
      node.implicits.has('warp_memory') &&
      (node.visibility === FunctionVisibility.External ||
        node.visibility === FunctionVisibility.Public)
    ) {
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_new');
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_finalize');
    }

    this.commonVisit(node, ast);
  }
}
