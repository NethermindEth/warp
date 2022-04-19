import assert from 'assert';
import {
  Block,
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
import { createReturn, generateFunctionCall } from '../../utils/functionGeneration';
import { createIdentifier, createParameterList } from '../../utils/nodeTemplates';
import { FunctionModifierInliner } from './functionModifierInliner';

/*  This pass handles functions with modifiers.
    
    Modifier invocations are processed in the same order of appearance.
    The i-th modifier invocation is transformed into a function which contains the code 
    of the corresponding modifier. Wherever there is a placeholder, this is replaced 
    with a call to the function that results of transforming the function with modifiers
    from (i + 1) to n.
    When there are no more modifier invocations left, it simply calls the function which 
    contains the original function code.
*/

export class FunctionModifierHandler extends ASTMapper {
  count = 0;

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    this.removeNonModifierInvocations(node);
    if (node.vModifiers.length === 0) return this.commonVisit(node, ast);

    let functionToCall = this.extractOriginalFunction(node, ast);
    for (let i = node.vModifiers.length - 1; i >= 0; i--) {
      const modifier = node.vModifiers[i].vModifier;
      assert(
        modifier instanceof ModifierDefinition,
        `Unexpected call to contract ${modifier.id} constructor`,
      );
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

  removeNonModifierInvocations(node: FunctionDefinition) {
    const modifiers = node.vModifiers.filter((modInvocation) => {
      return modInvocation.vModifier instanceof ModifierDefinition;
    });
    node.vModifiers = modifiers;
  }

  extractOriginalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const scope = node.vScope;

    const funcDef = cloneASTNode(node, ast);
    funcDef.name = `__warp_original_function_${node.name}`;
    funcDef.visibility = FunctionVisibility.Internal;
    funcDef.isConstructor = false;
    funcDef.kind = FunctionKind.Function;
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
}
