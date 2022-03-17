import assert = require('assert');
import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  Identifier,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  ElementaryTypeName,
  FunctionCallKind,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';

export class BooleanBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const external = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    );
    if (external) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (parameter.typeString === 'bool' && parameter.vType instanceof ElementaryTypeName) {
          const newIdentifier = new Identifier(
            ast.reserveId(),
            '',
            'Identifier',
            parameter.typeString,
            parameter.name,
            parameter.id,
          );
          const functionCall = new ExpressionStatement(
            ast.reserveId(),
            '',
            'ExpressionStatement',
            new FunctionCall(
              ast.reserveId(),
              '',
              'FunctionCall',
              'tuple()',
              FunctionCallKind.FunctionCall,
              new Identifier(
                ast.reserveId(),
                '',
                'Identifier',
                'int8',
                'function (int8) ',
                'warp_external_input_check_bool',
              ),
            ),
          );

          //const boolAssertStatment = ast
          //  .getUtilFuncGen(node)
          //  .externalInputChecks.bool.gen(parameter, newIdentifier);
          //const expressionStatement = new ExpressionStatement(
          //  ast.reserveId(),
          //  '',
          //  'ExpressionStatement',
          //  boolAssertStatment,
          //);
          //const functionBlock = node.vBody;
          //assert(functionBlock != undefined);
          //if (functionBlock.getChildren().length === 0) {
          //  functionBlock.appendChild(expressionStatement);
          //} else {
          //  const firstStatement = functionBlock.getChildrenByType(Statement)[0];
          //  ast.insertStatementBefore(firstStatement, expressionStatement);
          //}

          //  ast.setContextRecursive(expressionStatement);
        }
      });
      this.commonVisit(node, ast);
    }
  }
}
