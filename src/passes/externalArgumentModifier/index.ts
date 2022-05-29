import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { DynArrayModifier } from './dynamicArrayModifier';
import { StaticArrayModifier } from './staticArrayModifier';
import { StructModifier } from './structModifier';
import { DynArrayReturner } from './dynamicArrayReturner';

export class ExternalArgumentModifier extends ASTMapper {
  static map(ast: AST): AST {
    ast = StructModifier.map(ast);
    ast = StaticArrayModifier.map(ast);
    ast = DynArrayModifier.map(ast);
    ast = DynArrayReturner.map(ast);
    return ast;
  }
}
