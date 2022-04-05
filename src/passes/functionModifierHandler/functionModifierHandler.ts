import {
  Block,
  ContractDefinition,
  Expression,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  ModifierDefinition,
  Return,
  SourceUnit,
  Statement,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { NotSupportedYetError } from '../../utils/errors';
import { createReturn, generateFunctionCall } from '../../utils/functionGeneration';
import { createIdentifier, createParameterList } from '../../utils/nodeTemplates';
import { FunctionModifierInliner } from './functionModifierInliner';

export class FunctionModifierHandler extends ASTMapper {
  count = 0;

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vModifiers.length === 0) return this.commonVisit(node, ast);

    let functionToCall = this.extractOriginalFunction(node, ast);
    for (let i = node.vModifiers.length - 1; i >= 0; i--) {
      const modifier = this.getModifier(node.vModifiers[i].vModifier);
      functionToCall = this.getFunctionFromModifier(node, modifier, functionToCall, ast);
    }

    const functionArgs = node.vParameters.vParameters.map((v) => createIdentifier(v, ast));
    const modArgs: Expression[] = [];
    for (const modifier of node.vModifiers) {
      for (const arg of modifier.vArguments) {
        modArgs.push(cloneASTNode(arg, ast));
      }
    }
    const argsList = [...modArgs, ...functionArgs];
    const returnStatement = new Return(
      ast.reserveId(),
      '',
      node.vReturnParameters.id,
      generateFunctionCall(functionToCall, argsList, ast),
    );
    const functionBody = new Block(ast.reserveId(), '', [returnStatement]);

    node.vModifiers = [];
    node.vBody = functionBody;
    ast.registerChild(functionBody, node);
  }

  extractOriginalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const scope = node.vScope;

    const funcDef = cloneASTNode(node, ast);
    funcDef.name = `__warp_original_function_${node.name}`;
    funcDef.visibility = FunctionVisibility.Internal;
    funcDef.vModifiers = [];

    scope.insertAtBeginning(funcDef);
    ast.registerChild(funcDef, scope);
    return funcDef;
  }

  getFunctionFromModifier(
    node: FunctionDefinition,
    modifier: ModifierDefinition,
    functionToCall: FunctionDefinition,
    ast: AST,
  ): FunctionDefinition {
    const scope = node.vScope;
    const functionName = `__warp_${modifier.name}_${this.count++}`;

    const functionParams = functionToCall.vParameters.vParameters.map((v) =>
      this.createParameter(v, ast),
    );
    const modParams = modifier.vParameters.vParameters.map((v) => cloneASTNode(v, ast));
    const params = [...modParams, ...functionParams];
    const retParams = node.vReturnParameters.vParameters.map((v) => this.getNamedParam(v, ast));
    const retParamList = createParameterList(retParams, ast);

    let statements: Statement[] = [];

    // Add body of modifier
    if (modifier.vBody !== undefined) {
      const modBody = cloneASTNode(modifier.vBody, ast);
      new FunctionModifierInliner(functionToCall, functionParams, retParamList).dispatchVisit(
        modBody,
        ast,
      );
      statements = statements.concat(modBody.vStatements);
    }

    // Add return statement
    if (retParams.length > 0 && !(statements[statements.length - 1] instanceof Return))
      statements.push(createReturn(retParams, retParamList.id, ast));

    // Create Function Definition Node
    const funcDef = new FunctionDefinition(
      ast.reserveId(),
      '',
      scope.id,
      scope instanceof SourceUnit ? FunctionKind.Free : FunctionKind.Function,
      functionName,
      node.virtual,
      FunctionVisibility.Internal,
      node.stateMutability,
      false,
      createParameterList(params, ast),
      retParamList,
      [],
      undefined,
      new Block(ast.reserveId(), '', statements),
    );

    // Insert node into ast
    scope.insertAtBeginning(funcDef);
    ast.registerChild(funcDef, scope);
    return funcDef;
  }

  createParameter(v: VariableDeclaration, ast: AST): VariableDeclaration {
    const variable = cloneASTNode(v, ast);
    variable.name = `__warp_parameter${this.count++}`;
    return variable;
  }

  getNamedParam(v: VariableDeclaration, ast: AST): VariableDeclaration {
    const param = cloneASTNode(v, ast);
    param.name = `__warp_ret_parameter${this.count++}`;
    return param;
  }

  // TODO - Get modifier code when `vModifier` is a Contract Definition
  //        (it should be solved when dealing with inheritance)
  // Note: There is a possibility that constructor of the current contract
  //       invokes a constructor of the super contract.
  //       The `ContractDefinition` of a super contract is the value in such case.
  getModifier(vModifier: ModifierDefinition | ContractDefinition): ModifierDefinition {
    if (vModifier instanceof ModifierDefinition) return vModifier;
    throw new NotSupportedYetError('Modifiers Inheritance is not supported yet');
  }
}
