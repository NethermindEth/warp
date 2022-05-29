import { AST } from '../../ast/ast';
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionCall,
  getNodeType,
  Statement,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { isExternallyVisible } from '../../utils/utils';
import assert from 'assert';
import { createExpressionStatement } from '../../utils/nodeTemplates';
import { CairoFunctionDefinition, FunctionStubKind } from '../../ast/cairoNodes';
import { isDynamicCallDataArray } from '../../utils/nodeTypeProcessing';

export class BoundChecker extends ASTMapper {
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
    const arg = funcCall.vArguments[0];
    assert(body !== undefined && funcCall.vArguments !== undefined);
    const argType = getNodeType(arg, ast.compilerVersion);
    // If there is a Dynamic Array in the parameters there should be a StructConstructorStub present by the
    // time this pass is hit.
    if (isDynamicCallDataArray(argType)) {
      const dynConstructorStatements = node.getChildren(true).filter((n) => {
        const containsStrucConstructorStub = n
          // See if you need true here.
          .getChildren(true)
          .some(
            (m) =>
              m instanceof FunctionCall &&
              m.vReferencedDeclaration instanceof CairoFunctionDefinition &&
              m.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub,
          );
        return n instanceof Statement && containsStrucConstructorStub;
      });
      // This needs to change to last. Find the TypeScript analog to [-1]
      const lastDynArrayStatement = dynConstructorStatements[0];
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
