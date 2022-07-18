import { FunctionDefinition, getNodeType, VariableDeclarationStatement } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { getDefaultValue } from '../utils/defaultValueNodes';
import { collectUnboundVariables } from '../utils/functionGeneration';

export class ReturnVariableInitializer extends ASTMapper {
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
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
    ];
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
          getDefaultValue(getNodeType(decl, ast.compilerVersion), newDecl, ast),
        );
        identifiers.forEach((identifier) => {
          identifier.referencedDeclaration = newDecl.id;
        });
        body.insertAtBeginning(newDeclStatement);
        ast.registerChild(newDeclStatement, body);
      });
  }
}
