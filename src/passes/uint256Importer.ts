import { ElementaryTypeName } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { primitiveTypeToCairo } from '../utils/utils';

export class Uint256Importer extends ASTMapper {
  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    if (primitiveTypeToCairo(node.name) === 'Uint256') {
      ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
    }
  }
}
