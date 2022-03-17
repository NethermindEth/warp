import assert = require('assert');
import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  ElementaryTypeName,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';

export class IntBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const external = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    );
    if (external) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (
          parameter.typeString.slice(0, 4) === 'uint' ||
          parameter.typeString.slice(0, 3) === 'int'
        ) {
          assert(parameter.vType instanceof ElementaryTypeName);

          const boolAssertStatment = ast
            .getUtilFuncGen(node)
            .externalInputChecks.int.gen(parameter);

          const expressionStatement = new ExpressionStatement(
            ast.reserveId(),
            '',
            'ExpressionStatement',
            boolAssertStatment,
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
