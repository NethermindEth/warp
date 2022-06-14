import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropFreeSourceUnits extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots = ast.roots.filter((su) => su.absolutePath.includes('__WARP_CONTRACT__'));
    return ast;
  }
}
