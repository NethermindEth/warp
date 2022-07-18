import { AST } from '../ast/ast';
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  FunctionCall,
  getNodeType,
  FunctionCallKind,
  EnumDefinition,
  IntType,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { isExternallyVisible } from '../utils/utils';
import assert from 'assert';
import { createExpressionStatement } from '../utils/nodeTemplates';
import { checkableType } from '../utils/nodeTypeProcessing';
export class ArgBoundChecker extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: string[] = [
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
      'Rv',
      'If',
      'T',
      'U',
      'V',
      'Vs',
      'I',
      'Dh',
      'Rf',
    ];
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

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
        if (checkableType(type)) {
          const functionCall = ast
            .getUtilFuncGen(node)
            .boundChecks.inputCheck.gen(decl, type, node);
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

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.kind === FunctionCallKind.TypeConversion &&
      node.vReferencedDeclaration instanceof EnumDefinition &&
      getNodeType(node.vArguments[0], ast.compilerVersion) instanceof IntType
    ) {
      const enumDef = node.vReferencedDeclaration;
      const enumCheckFuncCall = ast
        .getUtilFuncGen(node)
        .boundChecks.enums.gen(node, node.vArguments[0], enumDef, node);
      const parent = node.parent;
      ast.replaceNode(node, enumCheckFuncCall, parent);
    }
    this.commonVisit(node, ast);
  }
}
