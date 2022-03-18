import assert = require('assert');
import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  Identifier,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';

export class EnumBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const externalFunction = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    );
    if (externalFunction) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (parameter.typeString.slice(0, 4) === 'enum' && parameter.name != undefined) {
          const enumStubArgument = new Identifier(
            ast.reserveId(),
            '',
            'Identifier',
            parameter.typeString,
            parameter.name,
            parameter.id,
          );

          const enumAssertStatment = ast
            .getUtilFuncGen(node)
            .externalInputChecks.enum.gen(parameter, enumStubArgument);

          const expressionStatement = new ExpressionStatement(
            ast.reserveId(),
            '',
            'ExpressionStatement',
            enumAssertStatment,
          );

          const functionBlock = node.vBody;

          assert(functionBlock != undefined);
          if (functionBlock.getChildren().length === 0) {
            functionBlock.appendChild(expressionStatement);
          } else {
            const firstStatement = functionBlock.getChildrenByType(Statement)[0];

            ast.insertStatementBefore(firstStatement, expressionStatement);
          }
          ast.setContextRecursive(expressionStatement);
        }
      });
    }
    this.commonVisit(node, ast);
  }
}
