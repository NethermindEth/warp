import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  ElementaryTypeName,
  Identifier,
  IntType,
  VariableDeclaration,
  FunctionCall,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';

export class IntBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (FunctionVisibility.External === node.visibility) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (
          (parameter.typeString.slice(0, 4) === 'uint' ||
            parameter.typeString.slice(0, 3) === 'int') &&
          parameter.vType instanceof ElementaryTypeName
        ) {
          const functionCall = this.generateFunctionCall(parameter, ast);
          this.insertFunctionCall(node, functionCall, ast);
        }
      });
    }
    this.commonVisit(node, ast);
  }

  private generateFunctionCall(parameter: VariableDeclaration, ast: AST): FunctionCall {
    const intStubArgument = new Identifier(
      ast.reserveId(),
      '',
      'Identifier',
      parameter.typeString,
      parameter.name,
      parameter.id,
    );

    const int_width = parameter.typeString.replace('u', '').replace('int', '');

    const name = `warp_external_input_check_int${int_width}`;

    const intType = new IntType(Number(int_width), false);

    const functionStub = createCairoFunctionStub(
      name,
      [['x', typeNameFromTypeNode(intType, ast)]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      ast,
      parameter,
    );

    const functionCall = createCallToFunction(functionStub, [intStubArgument], ast);
    ast.registerImport(functionCall, 'warplib.maths.external_input_check_ints', name);

    return functionCall;
  }

  private insertFunctionCall(node: FunctionDefinition, functionCall: FunctionCall, ast: AST): void {
    if (node.vBody !== undefined) {
      const expressionStatement = new ExpressionStatement(
        ast.reserveId(),
        '',
        'ExpressionStatement',
        functionCall,
      );

      const functionBlock = node.vBody;

      if (functionBlock.getChildren().length === 0) {
        functionBlock.appendChild(expressionStatement);
      } else {
        const firstStatement = functionBlock.getChildrenByType(Statement)[0];

        ast.insertStatementBefore(firstStatement, expressionStatement);
      }

      ast.setContextRecursive(expressionStatement);
    }
  }
}
