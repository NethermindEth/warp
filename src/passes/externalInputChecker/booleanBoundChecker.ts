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
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToStub } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';

export class BooleanBoundChecker extends ASTMapper {
  private generatedBoolCheck = false;

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const externalFunction = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    );
    if (externalFunction) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (parameter.typeString === 'bool' && parameter.vType instanceof ElementaryTypeName) {
          const intType = new BoolType();
          const functionStub = createCairoFunctionStub(
            'warp_external_input_check_bool',
            [['boolValue', typeNameFromTypeNode(intType, ast)]],
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

          const functionCall = createCallToStub(functionStub, [boolStubArgument], ast);
          ast.registerImport(
            functionCall,
            'warplib.maths.external_input_check_bool',
            'warp_external_input_check_bool',
          );

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
      });
    }
    this.commonVisit(node, ast);
  }
}
