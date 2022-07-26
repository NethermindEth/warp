import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { DynArrayModifier } from './dynamicArrayModifier';
import { RefTypeModifier } from './memoryRefInputModifier';

export class ExternalArgModifier extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = RefTypeModifier.map(ast);
    ast = DynArrayModifier.map(ast);
    return ast;
  }
}
