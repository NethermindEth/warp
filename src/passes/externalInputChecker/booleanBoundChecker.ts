import assert from 'assert';
import { AST } from '../../ast/ast';
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionVisibility,
  Statement,
  ExpressionStatement,
  BoolType,
  VariableDeclaration,
  FunctionCall,
  getNodeType,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../utils/utils';
import { createIdentifier } from '../../utils/nodeTemplates';

export class BooleanBoundChecker extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.kind === ContractKind.Interface) {
      return;
    }
    this.commonVisit(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (
      (FunctionVisibility.External === node.visibility ||
        FunctionVisibility.Public === node.visibility) &&
      node.vBody !== undefined
    ) {
      node.vParameters.vParameters.forEach((parameter) => {
        const typeNode = getNodeType(parameter, ast.compilerVersion);
        if (typeNode instanceof BoolType) {
          const functionCall = this.generateFunctionCall(parameter, typeNode, ast);
          this.insertFunctionCall(node, functionCall, ast);
        }
      });
    }
    this.commonVisit(node, ast);
  }

  private generateFunctionCall(
    parameter: VariableDeclaration,
    typeNode: BoolType,
    ast: AST,
  ): FunctionCall {
    const functionStub = createCairoFunctionStub(
      'warp_external_input_check_bool',
      [['boolValue', typeNameFromTypeNode(typeNode, ast)]],
      [],
      ['syscall_ptr', 'range_check_ptr'],
      ast,
      parameter,
    );

    const boolStubArgument = createIdentifier(parameter, ast);

    const functionCall = createCallToFunction(functionStub, [boolStubArgument], ast);
    ast.registerImport(
      functionCall,
      'warplib.maths.external_input_check_bool',
      'warp_external_input_check_bool',
    );
    return functionCall;
  }

  private insertFunctionCall(node: FunctionDefinition, functionCall: FunctionCall, ast: AST): void {
    const expressionStatement = new ExpressionStatement(ast.reserveId(), '', functionCall);

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
