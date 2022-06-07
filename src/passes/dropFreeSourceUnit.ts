import { ContractDefinition, FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class DropFreeSourceUnitFunctions extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots
      .filter((su) => su.absolutePath.includes('__WARP_FREE__'))
      .forEach((su) =>
        su
          .getChildrenByType(FunctionDefinition)
          .filter((fd) => fd.getClosestParentByType(ContractDefinition) === undefined)
          .forEach((fd) => su.removeChild(fd)),
      );
    return ast;
  }
}
