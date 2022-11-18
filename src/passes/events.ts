import { EmitStatement, EventDefinition } from 'solc-typed-ast';
import { AST, ASTMapper } from '../export';

/**
 * Generates a cairo function that emits an event
 * through a cairo syscall. Then replace the emit statement
 * with a call to the generated function.
 */
export class Events extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Abi', // Abi pass is needed to encode the arguments
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitEmitStatement(node: EmitStatement, ast: AST): void {
    const refEventDef = node.vEventCall.vReferencedDeclaration;
    if (refEventDef === undefined || !(refEventDef instanceof EventDefinition)) {
      return;
    }
    ast.replaceNode(node, ast.getUtilFuncGen(node).event.gen(node, refEventDef));
    this.commonVisit(node, ast);
  }
}
