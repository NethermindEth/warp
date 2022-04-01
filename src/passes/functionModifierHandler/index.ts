import { FunctionModifierHandler } from './functionModifierHandler';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { ModifierRemover } from './modifierRemover';

export class ModifierHandler extends ASTMapper {
  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      new FunctionModifierHandler().dispatchVisit(root, ast);
      new ModifierRemover().dispatchVisit(root, ast);
    });
    return ast;
  }
}
