import { FunctionDefinition, getNodeType, VariableDeclarationStatement } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { getDefaultValue } from '../utils/defaultValueNodes';
import { collectUnboundVariables } from './loopFunctionaliser/utils';

export class ReturnVariableInitializer extends ASTMapper {
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
          'VariableDeclarationStatement',
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
