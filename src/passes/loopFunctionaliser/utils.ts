import assert from 'assert';
import {
  Assignment,
  ASTNode,
  Block,
  ContractDefinition,
  DoWhileStatement,
  Expression,
  ExpressionStatement,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Identifier,
  IfStatement,
  ParameterList,
  Return,
  SourceUnit,
  Statement,
  TupleExpression,
  VariableDeclaration,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { getFunctionTypeString, getReturnTypeString } from '../../utils/utils';

export function collectUnboundVariables(node: ASTNode): Map<VariableDeclaration, Identifier[]> {
  const internalDeclarations = node
    .getChildren(true)
    .filter((n) => n instanceof VariableDeclaration);

  const unboundVariables = node
    .getChildren(true)
    .filter((n): n is Identifier => n instanceof Identifier)
    .map((id): [Identifier, ASTNode | undefined] => [id, id.vReferencedDeclaration])
    .filter(
      (pair: [Identifier, ASTNode | undefined]): pair is [Identifier, VariableDeclaration] =>
        pair[1] !== undefined &&
        pair[1] instanceof VariableDeclaration &&
        !internalDeclarations.includes(pair[1]),
    );

  const retMap: Map<VariableDeclaration, Identifier[]> = new Map();

  unboundVariables.forEach(([id, decl]) => {
    const existingEntry = retMap.get(decl);
    if (existingEntry === undefined) {
      retMap.set(decl, [id]);
    } else {
      retMap.set(decl, [id, ...existingEntry]);
    }
  });

  return retMap;
}

let loopFnCounter = 0;

export function extractWhileToFunction(
  node: WhileStatement,
  variables: VariableDeclaration[],
  loopToContinueFunction: Map<number, FunctionDefinition>,
  ast: AST,
): FunctionDefinition {
  const scope =
    node.getClosestParentByType<ContractDefinition>(ContractDefinition) ??
    node.getClosestParentByType(SourceUnit);
  assert(scope !== undefined, "Couldn't find WhileStatement's function target root");

  const retParamsId = ast.reserveId();
  const defId = ast.reserveId();
  const defName = `__warp_while${loopFnCounter++}`;

  const funcBody = new Block(ast.reserveId(), '', [
    createStartingIf(node.vCondition, node.vBody, variables, retParamsId, ast),
  ]);

  const funcDef = new FunctionDefinition(
    defId,
    node.src,
    scope.id,
    scope instanceof SourceUnit ? FunctionKind.Free : FunctionKind.Function,
    defName,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    new ParameterList(
      ast.reserveId(),
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    new ParameterList(
      retParamsId,
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    [],
    undefined,
    funcBody,
  );

  loopToContinueFunction.set(defId, funcDef);

  scope.insertAtBeginning(funcDef);
  ast.registerChild(funcDef, scope);

  ast.insertStatementAfter(
    node.vBody,
    new Return(
      ast.reserveId(),
      '',
      funcDef.vReturnParameters.id,
      createLoopCall(funcDef, variables, ast),
    ),
  );

  return funcDef;
}

export function extractDoWhileToFunction(
  node: DoWhileStatement,
  variables: VariableDeclaration[],
  loopToContinueFunction: Map<number, FunctionDefinition>,
  ast: AST,
): FunctionDefinition {
  const scope =
    node.getClosestParentByType<ContractDefinition>(ContractDefinition) ??
    node.getClosestParentByType(SourceUnit);
  assert(scope !== undefined, "Couldn't find DoWhileStatement's function target root");

  const doWhileDefName = `__warp_do_while_${loopFnCounter++}`;
  const doWhileRetId = ast.reserveId();
  const doWhileFuncId = ast.reserveId();
  const doWhileBody = new Block(ast.reserveId(), '', [
    createStartingIf(node.vCondition, node.vBody, variables, doWhileRetId, ast),
  ]);

  const doWhileFuncDef = new FunctionDefinition(
    doWhileFuncId,
    node.src,
    scope.id,
    scope instanceof SourceUnit ? FunctionKind.Free : FunctionKind.Function,
    doWhileDefName,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    new ParameterList(
      ast.reserveId(),
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    new ParameterList(
      doWhileRetId,
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    [],
    undefined,
    doWhileBody,
  );

  scope.insertAtBeginning(doWhileFuncDef);
  ast.registerChild(doWhileFuncDef, scope);
  loopToContinueFunction.set(doWhileFuncId, doWhileFuncDef);

  ast.insertStatementAfter(
    node.vBody,
    new Return(
      ast.reserveId(),
      '',
      doWhileFuncDef.vReturnParameters.id,
      createLoopCall(doWhileFuncDef, variables, ast),
    ),
  );

  const doBlockDefName = `__warp_do_${loopFnCounter++}`;
  const doBlockReturnId = ast.reserveId();
  const doBlockFuncId = ast.reserveId();

  const doBlockBody = new Block(ast.reserveId(), '', [
    cloneASTNode(node.vBody, ast),
    new Return(
      ast.reserveId(),
      '',
      doBlockReturnId,
      createLoopCall(doWhileFuncDef, variables, ast),
    ),
  ]);

  const doBlockFuncDef = new FunctionDefinition(
    doBlockFuncId,
    node.src,
    scope.id,
    scope instanceof SourceUnit ? FunctionKind.Free : FunctionKind.Function,
    doBlockDefName,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    new ParameterList(
      ast.reserveId(),
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    new ParameterList(
      doBlockReturnId,
      '',
      variables.map((v) => cloneASTNode(v, ast)),
    ),
    [],
    undefined,
    doBlockBody,
  );

  scope.insertAtBeginning(doBlockFuncDef);
  ast.registerChild(doBlockFuncDef, scope);
  loopToContinueFunction.set(doBlockFuncId, doWhileFuncDef);

  return doBlockFuncDef;
}

function createStartingIf(
  condition: Expression,
  body: Statement,
  variables: VariableDeclaration[],
  retParamsId: number,
  ast: AST,
): IfStatement {
  return new IfStatement(
    ast.reserveId(),
    '',
    condition,
    body,
    createReturn(variables, retParamsId, ast),
  );
}

export function createReturn(
  declarations: VariableDeclaration[],
  retParamListId: number,
  ast: AST,
): Return {
  const returnIdentifiers = declarations.map((d) => createIdentifier(d, ast));
  const retValue = toSingleExpression(returnIdentifiers, ast);
  return new Return(ast.reserveId(), '', retParamListId, retValue);
}

export function toSingleExpression(expressions: Expression[], ast: AST): Expression {
  if (expressions.length === 1) return expressions[0];

  return new TupleExpression(
    ast.reserveId(),
    '',
    `tuple(${expressions.map((e) => e.typeString).join(',')})`,
    false,
    expressions,
  );
}

export function createLoopCall(
  loopFunction: FunctionDefinition,
  variables: VariableDeclaration[],
  ast: AST,
): FunctionCall {
  return new FunctionCall(
    ast.reserveId(),
    '',
    getReturnTypeString(loopFunction),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      getFunctionTypeString(loopFunction, ast.compilerVersion),
      loopFunction.name,
      loopFunction.id,
    ),
    variables.map((v) => createIdentifier(v, ast)),
  );
}

export function createOuterCall(
  node: WhileStatement,
  unboundVariables: Map<VariableDeclaration, Identifier[]>,
  functionDef: FunctionDefinition,
  ast: AST,
): ExpressionStatement {
  const resultIdentifiers = [...unboundVariables.keys()].map((k) => createIdentifier(k, ast));
  const assignmentValue = toSingleExpression(resultIdentifiers, ast);

  return new ExpressionStatement(
    ast.reserveId(),
    node.src,
    resultIdentifiers.length === 0
      ? createLoopCall(functionDef, [...unboundVariables.keys()], ast)
      : new Assignment(
          ast.reserveId(),
          '',
          assignmentValue.typeString,
          '=',
          assignmentValue,
          createLoopCall(functionDef, [...unboundVariables.keys()], ast),
        ),
    node.documentation,
    node.raw,
  );
}
