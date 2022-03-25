import {
  Assignment,
  Block,
  ContractDefinition,
  Expression,
  ExpressionStatement,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  getNodeType,
  ModifierDefinition,
  Return,
  SourceUnit,
  Statement,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { getDefaultValue } from '../../utils/defaultValueNodes';
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
      'Return',
      node.vReturnParameters.id,
      generateFunctionCall(functionToCall, argsList, ast),
    );
    const functionBody = new Block(ast.reserveId(), '', 'Block', [returnStatement]);

    ast.replaceNode(
      node,
      new FunctionDefinition(
        node.id,
        node.src,
        node.type,
        node.scope,
        node.kind,
        node.name,
        node.virtual,
        node.visibility,
        node.stateMutability,
        node.isConstructor,
        node.vParameters,
        node.vReturnParameters,
        [],
        node.vOverrideSpecifier,
        functionBody,
        node.documentation,
        node.nameLocation,
        node.raw,
      ),
    );
  }

  extractOriginalFunction(node: FunctionDefinition, ast: AST): FunctionDefinition {
    const scope = node.vScope;
    const defName = `__warp_original_function_${node.name}`;

    const funcDef = new FunctionDefinition(
      ast.reserveId(),
      node.src,
      'FunctionDefinition',
      scope.id,
      scope instanceof SourceUnit ? FunctionKind.Free : FunctionKind.Function,
      defName,
      node.virtual,
      FunctionVisibility.Internal,
      node.stateMutability,
      false,
      createParameterList(
        node.vParameters.vParameters.map((v) => cloneASTNode(v, ast)),
        ast,
      ),
      createParameterList(
        node.vParameters.vParameters.map((v) => cloneASTNode(v, ast)),
        ast,
      ),
      [],
      undefined,
      node.vBody,
    );

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
    const retParams = node.vParameters.vParameters.map((v) => this.getNamedParam(v, ast));
    const retParamList = createParameterList(retParams, ast);

    let statements: Statement[] = [];

    // Initialize return variables
    if (retParams.length > 0) {
      for (const variable of retParams) {
        statements.push(
          new ExpressionStatement(
            ast.reserveId(),
            '',
            'ExpressionStatement',
            new Assignment(
              ast.reserveId(),
              '',
              'Assignment',
              variable.typeString,
              '=',
              createIdentifier(variable, ast),
              getDefaultValue(getNodeType(variable, ast.compilerVersion), variable, ast),
            ),
          ),
        );
      }
    }

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
      'FunctionDefinition',
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
      new Block(ast.reserveId(), '', 'Block', statements),
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

  // TODO - Check how to get modifier code when `vModifier` is a Contract Definition
  // Note: There is a possibility that constructor of the current contract
  //       invokes a constructor of the super contract.
  //       The `ContractDefinition` of a super contract is the value in such case.
  getModifier(vModifier: ModifierDefinition | ContractDefinition): ModifierDefinition {
    if (vModifier instanceof ModifierDefinition) return vModifier;
    // console.log(vModifier);
    // console.log(vModifier.vModifiers);
    throw new Error('Method not implemented');
  }
}
