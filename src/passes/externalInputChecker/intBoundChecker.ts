import { AST } from '../../ast/ast';
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionCall,
  getNodeType,
  ArrayType,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { isExternallyVisible } from '../../utils/utils';
import assert from 'assert';
import { createExpressionStatement } from '../../utils/nodeTemplates';
import { CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';

export class IntBoundChecker extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.kind === ContractKind.Interface) {
      return;
    }
    this.commonVisit(node, ast);
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (isExternallyVisible(node) && node.vBody !== undefined) {
      node.vParameters.vParameters.forEach((decl) => {
        const functionCall = ast
          .getUtilFuncGen(node)
          .externalFunctions.inputsChecks.refCheck.gen(decl, node);
        this.insertFunctionCall(node, functionCall, ast);
      });
    }
    this.commonVisit(node, ast);
  }

  private insertFunctionCall(node: FunctionDefinition, funcCall: FunctionCall, ast: AST): void {
    const body = node.vBody;
    assert(body !== undefined);
    const funcType = getNodeType(funcCall, ast.compilerVersion);
    // If there is a Dynamic Array in the parameters there should be a StructConstructorStub present by the
    // time this pass is hit.
    if (funcType instanceof ArrayType && funcType.size === undefined) {
      const dynConstructorStatements = node
        .getChildren(true)
        .filter(
          (n) =>
            n instanceof FunctionCall &&
            n.vReferencedDeclaration instanceof CairoFunctionDefinition &&
            n.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub,
        );
      const lastDynArrayStatement = dynConstructorStatements[-1];
      const expressionStatement = createExpressionStatement(ast, funcCall);
      body.insertAfter(expressionStatement, lastDynArrayStatement);
      ast.setContextRecursive(expressionStatement);
    } else {
      const expressionStatement = createExpressionStatement(ast, funcCall);
      body.insertAtBeginning(expressionStatement);
      ast.setContextRecursive(expressionStatement);
    }
  }
}
