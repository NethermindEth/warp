import { EmitStatement, EventDefinition, FunctionCall } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

import { createExpressionStatement } from '../export';

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
    const replacement: FunctionCall = ast
      .getUtilFuncGen(node)
      .events.event.gen(node, node.vEventCall.vReferencedDeclaration as EventDefinition);
    ast.replaceNode(node, createExpressionStatement(ast, replacement));
    this.commonVisit(node, ast);
  }
}
