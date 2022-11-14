import { FunctionDefinition, VariableDeclarationStatement } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { getDefaultValue } from '../utils/defaultValueNodes';
import { collectUnboundVariables } from '../utils/functionGeneration';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

export class ReturnVariableInitializer extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    this.commonVisit(node, ast);
    const body = node.vBody;
    if (body === undefined) return;

    [...collectUnboundVariables(body).entries()]
      .filter(([decl]) => node.vReturnParameters.vParameters.includes(decl))
      .forEach(([decl, identifiers]) => {
        const newDecl = cloneASTNode(decl, ast);
        const newDeclStatement = new VariableDeclarationStatement(
          ast.reserveId(),
          '',
          [newDecl.id],
          [newDecl],
          getDefaultValue(safeGetNodeType(decl, ast.compilerVersion), newDecl, ast),
        );
        identifiers.forEach((identifier) => {
          identifier.referencedDeclaration = newDecl.id;
        });
        body.insertAtBeginning(newDeclStatement);
        ast.registerChild(newDeclStatement, body);
      });
  }
}
