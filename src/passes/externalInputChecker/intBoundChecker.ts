import { AST } from '../../ast/ast';
import {
  FunctionDefinition,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  ElementaryTypeName,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToStub } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';

export class IntBoundChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const externalFunction = [FunctionVisibility.Public, FunctionVisibility.External].includes(
      node.visibility,
    );

    if (externalFunction) {
      node.vParameters.vParameters.forEach((parameter) => {
        if (
          (parameter.typeString.slice(0, 4) === 'uint' ||
            parameter.typeString.slice(0, 3) === 'int') &&
          parameter.vType instanceof ElementaryTypeName &&
          node.vBody != undefined
        ) {
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

          const functionCall = createCallToStub(functionStub, [intStubArgument], ast);
          ast.registerImport(functionCall, 'warplib.maths.external_input_check_ints', name);

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
      });
    }
    this.commonVisit(node, ast);
  }
}
