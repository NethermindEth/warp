import assert = require('assert');
import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  Identifier,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  ElementaryTypeName,
  BoolType,
  VariableDeclaration,
  FunctionCall,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';

export class BooleanBoundChecker extends ASTMapper {
  private generatedBoolCheck = false;

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.External === node.visibility) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (parameter.typeString === 'bool' && parameter.vType instanceof ElementaryTypeName) {
          const functionCall = this.generateFunctionCall(parameter, ast);
          this.insertFunctionCall(node, functionCall, ast);
        }
      });
    }
    this.commonVisit(node, ast);
  }

  private generateFunctionCall(parameter: VariableDeclaration, ast: AST): FunctionCall {
    const boolType = new BoolType();

    const functionStub = createCairoFunctionStub(
      'warp_external_input_check_bool',
      [['boolValue', typeNameFromTypeNode(boolType, ast)]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      ast,
      parameter,
    );

    const boolStubArgument = new Identifier(
      ast.reserveId(),
      '',
      'Identifier',
      parameter.typeString,
      parameter.name,
      parameter.id,
    );

    const functionCall = createCallToFunction(functionStub, [boolStubArgument], ast);
    ast.registerImport(
      functionCall,
      'warplib.maths.external_input_check_bool',
      'warp_external_input_check_bool',
    );
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

    assert(functionBlock != undefined);
    if (functionBlock.getChildren().length === 0) {
      functionBlock.appendChild(expressionStatement);
    } else {
      const firstStatement = functionBlock.getChildrenByType(Statement)[0];

      ast.insertStatementBefore(firstStatement, expressionStatement);
    }
    ast.setContextRecursive(expressionStatement);
  }
}
