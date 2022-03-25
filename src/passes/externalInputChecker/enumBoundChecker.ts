import assert = require('assert');
import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  Identifier,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  VariableDeclaration,
  FunctionCall,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';

export class EnumBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.External === node.visibility) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (parameter.typeString.slice(0, 4) === 'enum' && parameter.name !== undefined) {
          const functionCall = this.generateFunctionCall(node, parameter, ast);
          this.insertFunctionCall(node, functionCall, ast);
        }
      });
    }
    this.commonVisit(node, ast);
  }

  private generateFunctionCall(
    node: FunctionDefinition,
    parameter: VariableDeclaration,
    ast: AST,
  ): FunctionCall {
    const enumStubArgument = new Identifier(
      ast.reserveId(),
      '',
      'Identifier',
      parameter.typeString,
      parameter.name,
      parameter.id,
    );
    const functionCall = ast
      .getUtilFuncGen(node)
      .externalInputChecks.enum.gen(parameter, enumStubArgument);

    return functionCall;
  }

  private insertFunctionCall(node: FunctionDefinition, functionCall: FunctionCall, ast: AST): void {
    const expressionStatement = new ExpressionStatement(
      ast.reserveId(),
      '',
      'ExpressionStatement',
      functionCall,
    );

    const functionBlock = node.vBody;

    assert(functionBlock !== undefined);
    if (functionBlock.getChildren().length === 0) {
      functionBlock.appendChild(expressionStatement);
    } else {
      const firstStatement = functionBlock.getChildrenByType(Statement)[0];

      ast.insertStatementBefore(firstStatement, expressionStatement);
    }
    ast.setContextRecursive(expressionStatement);
  }
}
