import { ASTMapper } from '../../ast/mapper';
import { DeclarationNameMangler } from './declarationNameMangler';
import { AST } from '../../ast/ast';
import { ExpressionNameMangler } from './expressionNameMangler';
export class IdentifierMangler extends ASTMapper {
  static map(ast: AST): AST {
    ast = DeclarationNameMangler.map(ast);
    ast = ExpressionNameMangler.map(ast);
    return ast;
  }
}
