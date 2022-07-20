import { FunctionDefinition } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { hasPathWithoutReturn } from '../utils/controlFlowAnalyser';
import { createIdentifier, createReturn } from '../utils/nodeTemplates';
import { toSingleExpression } from '../utils/utils';

export class ReturnInserter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vBody === undefined) return;

    if (hasPathWithoutReturn(node.vBody)) {
      const retVars = node.vReturnParameters.vParameters;
      let expression;
      if (retVars.length !== 0) {
        expression = toSingleExpression(
          retVars.map((r) => createIdentifier(r, ast)),
          ast,
        );
      }
      const newReturn = createReturn(expression, node.vReturnParameters.id, ast);
      node.vBody.appendChild(newReturn);
      ast.registerChild(newReturn, node.vBody);
    }
  }
}
