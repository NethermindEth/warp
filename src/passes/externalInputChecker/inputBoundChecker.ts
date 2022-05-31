import { AST } from '../../ast/ast';
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionCall,
  getNodeType,
  UserDefinedType,
  StructDefinition,
  TypeNode,
  AddressType,
  ArrayType,
  IntType,
  BoolType,
  EnumDefinition,
} from 'solc-typed-ast';
import { ASTMapper } from '../../ast/mapper';
import { isExternallyVisible } from '../../utils/utils';
import assert from 'assert';
import { createExpressionStatement } from '../../utils/nodeTemplates';
// Add throw if they try pass in a DynArray of Static Arrays
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
        const type = getNodeType(decl, ast.compilerVersion);
        if (this.checkableType(type)) {
          const functionCall = ast
            .getUtilFuncGen(node)
            .externalFunctions.inputsChecks.refCheck.gen(decl, node);
          this.insertFunctionCall(node, functionCall, ast);
        }
      });
    }

    this.commonVisit(node, ast);
  }

  private insertFunctionCall(node: FunctionDefinition, funcCall: FunctionCall, ast: AST): void {
    const body = node.vBody;
    assert(body !== undefined && funcCall.vArguments !== undefined);
    const expressionStatement = createExpressionStatement(ast, funcCall);
    body.insertAtBeginning(expressionStatement);
    ast.setContextRecursive(expressionStatement);
  }

  checkableType(type: TypeNode): boolean {
    if (
      type instanceof ArrayType ||
      (type instanceof UserDefinedType &&
        (type.definition instanceof StructDefinition ||
          type.definition instanceof EnumDefinition)) ||
      type instanceof AddressType ||
      type instanceof IntType ||
      type instanceof BoolType
    ) {
      return true;
    }
    return false;
  }
}
