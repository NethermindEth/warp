import assert from 'assert';
import {
  Assignment,
  ASTNode,
  ExpressionStatement,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionGeneration';
import {
  createBlock,
  createExpressionStatement,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';
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
    if (node.vModifiers.length === 0) return this.commonVisit(node, ast);

    const functionToCall = node.vModifiers.reduceRight((acc, modInvocation) => {
      const modifier = modInvocation.vModifier;
      assert(
        modifier instanceof ModifierDefinition,
        `Unexpected call to contract ${modifier.id} constructor`,
      );
      return this.getFunctionFromModifier(node, modifier, acc, ast);
    }, this.extractOriginalFunction(node, ast));

    const functionArgs = node.vParameters.vParameters.map((v) => createIdentifier(v, ast));
    const retCaptureArgs = node.vReturnParameters.vParameters.map((v) => createIdentifier(v, ast));
    const modArgs = node.vModifiers
      .map((modInvocation) => modInvocation.vArguments)
      .flat()
      .map((arg) => cloneASTNode(arg, ast));
    const argsList = [...modArgs, ...functionArgs, ...retCaptureArgs];
    const returnStatement = createReturn(
      createCallToFunction(functionToCall, argsList, ast),
      node.vReturnParameters.id,
      ast,
    );
    const functionBody = createBlock([returnStatement], ast);

    node.vModifiers = [];
    node.vBody = functionBody;
    ast.registerChild(functionBody, node);
  }

  extractOriginalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const scope = node.vScope;

    const funcDef = cloneASTNode(node, ast);
    const name = node.isConstructor ? `constructor` : `function_${node.name}`;
    funcDef.name = `__warp_original_${name}`;
    funcDef.visibility = FunctionVisibility.Internal;
    funcDef.isConstructor = false;
    funcDef.kind = FunctionKind.Function;
    funcDef.vModifiers = [];

    createOutputCaptures(funcDef, node, ast).forEach(([input, assignment]) => {
      funcDef.vParameters.vParameters.push(input);
      ast.registerChild(input, funcDef.vParameters);
      if (funcDef.vBody !== undefined) {
        funcDef.vBody.insertAtBeginning(assignment);
      }
    });

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
    // First clone the modifier as a whole so all referencedDeclarations are rebound
    const modifierClone = cloneASTNode(modifier, ast);

    const functionParams = functionToCall.vParameters.vParameters.map((v) =>
      this.createInputParameter(v, ast),
    );

    const retParams = node.vReturnParameters.vParameters.map((v) =>
      this.createReturnParameter(v, ast),
    );
    const retParamList = createParameterList(retParams, ast, modifierClone.id);

    ast.context.unregister(modifierClone);

    const modifierAsFunction = new FunctionDefinition(
      modifierClone.id,
      modifierClone.src,
      node.scope,
      FunctionKind.Function,
      `__warp_${modifier.name}_${this.count++}`,
      node.virtual,
      FunctionVisibility.Internal,
      node.stateMutability,
      false,
      createParameterList(
        [...modifierClone.vParameters.vParameters, ...functionParams],
        ast,
        modifierClone.id,
      ),
      retParamList,
      [],
      undefined,
      modifierClone.vBody,
    );

    node.vScope.insertAtBeginning(modifierAsFunction);
    ast.registerChild(modifierAsFunction, node.vScope);

    if (modifierAsFunction.vBody) {
      new FunctionModifierInliner(functionToCall, functionParams, retParamList).dispatchVisit(
        modifierAsFunction.vBody,
        ast,
      );
    }

    ast.setContextRecursive(modifierAsFunction);

    return modifierAsFunction;
  }

  createInputParameter(v: VariableDeclaration, ast: AST): VariableDeclaration {
    const variable = cloneASTNode(v, ast);
    variable.name = `__warp_parameter${this.count++}`;
    return variable;
  }

  createReturnParameter(v: VariableDeclaration, ast: AST): VariableDeclaration {
    const param = cloneASTNode(v, ast);
    param.name = `__warp_ret_parameter${this.count++}`;
    return param;
  }
}

function createOutputCaptures(
  func: FunctionDefinition,
  nodeInSourceUnit: ASTNode,
  ast: AST,
): [VariableDeclaration, ExpressionStatement][] {
  return func.vReturnParameters.vParameters.map((v) => {
    const captureVar = cloneASTNode(v, ast);
    captureVar.name = `${captureVar.name}_m_capture`;
    return [captureVar, createAssignmentStatement(v, captureVar, ast, nodeInSourceUnit)];
  });
}

function createAssignmentStatement(
  lhs: VariableDeclaration,
  rhs: VariableDeclaration,
  ast: AST,
  nodeInSourceUnit: ASTNode,
): ExpressionStatement {
  const lhsIdentifier = createIdentifier(lhs, ast, undefined, nodeInSourceUnit);
  const rhsIdentifier = createIdentifier(rhs, ast, undefined, nodeInSourceUnit);
  return createExpressionStatement(
    ast,
    new Assignment(
      ast.reserveId(),
      '',
      lhsIdentifier.typeString,
      '=',
      lhsIdentifier,
      rhsIdentifier,
    ),
  );
}
