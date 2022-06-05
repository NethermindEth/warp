import { FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropFreeSourceUnitFunctions extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots
      .filter((su) => su.absolutePath.includes('__WARP_FREE__'))
      .map((su) => su.getChildrenByType(FunctionDefinition).map((fd) => su.removeChild(fd)));
    return ast;
  }
}
