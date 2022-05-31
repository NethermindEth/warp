import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { BoundChecker } from './inputBoundChecker';

export class ExternalInputChecker extends ASTMapper {
  static map(ast: AST): AST {
    ast = BoundChecker.map(ast);
    return ast;
  }
}
