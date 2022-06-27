import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { DynArrayModifier } from './dynamicArrayModifier';
import { RefTypeModifier } from './memoryRefInputModifier';

export class ExternalArgModifier extends ASTMapper {
  static map(ast: AST): AST {
    // ast = RefTypeModifier.map(ast);
    // ast = DynArrayModifier.map(ast);
    return ast;
  }
}
