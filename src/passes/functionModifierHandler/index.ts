import { FunctionModifierHandler } from './functionModifierHandler';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { ModifierRemover } from './modifierRemover';

/*  This pass takes all functions that are being modified and transform 
    them into a sequence of functions, which are called in the same order 
    the modifier invocations were declared. Each of these functions will 
    contain the code of the correponding modifier.
    
    Once this is done, ModifierDefinition nodes are removed from the ast 
    since they are no longer needed.
*/
export class ModifierHandler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: string[] = [
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
    ];
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      new FunctionModifierHandler().dispatchVisit(root, ast);
      new ModifierRemover().dispatchVisit(root, ast);
    });
    return ast;
  }
}
