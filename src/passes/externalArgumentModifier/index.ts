import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { DynamicArrayModifier } from './dynamicArrayModifier';
import { StaticArrayModifier } from './staticArrayModifier';
import { StructModifier } from './structModifier';

export class ExternalArgumentModifier extends ASTMapper {
  static map(ast: AST): AST {
    ast = StructModifier.map(ast);
    ast = StaticArrayModifier.map(ast);
    ast = DynamicArrayModifier.map(ast);
    return ast;
  }
}
