import assert from 'assert';
import {
  ContractDefinition,
  DoWhileStatement,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  IfStatement,
  SourceUnit,
  Statement,
  VariableDeclaration,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction, fixParameterScopes } from '../../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';

// It's okay to use a global counter here as it only affects private functions
// and never anything that can be referenced from another file
let loopFnCounter = 0;

export function extractWhileToFunction(
  node: WhileStatement,
  variables: VariableDeclaration[],
  loopToContinueFunction: Map<number, FunctionDefinition>,
  ast: AST,
  prefix = '__warp_while',
): FunctionDefinition {
  const scope =
    node.getClosestParentByType<ContractDefinition>(ContractDefinition) ??
    node.getClosestParentByType(SourceUnit);
  assert(scope !== undefined, `Couldn't find ${printNode(node)}'s function target root`);

  const retParams = createParameterList(
    variables.map((v) => cloneASTNode(v, ast)),
    ast,
  );
  const defId = ast.reserveId();
  const defName = `${prefix}${loopFnCounter++}`;

  const funcBody = createBlock(
    [createStartingIf(node.vCondition, node.vBody, variables, retParams.id, ast)],
    ast,
  );

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
    createParameterList(
      variables.map((v) => cloneASTNode(v, ast)),
      ast,
    ),
    retParams,
    [],
    undefined,
    funcBody,
  );

  fixParameterScopes(funcDef);

  loopToContinueFunction.set(defId, funcDef);

  scope.insertAtBeginning(funcDef);
  ast.registerChild(funcDef, scope);

  ast.insertStatementAfter(
    node.vBody,
    createReturn(createLoopCall(funcDef, variables, ast), funcDef.vReturnParameters.id, ast),
  );

  return funcDef;
}

export function extractDoWhileToFunction(
  node: DoWhileStatement,
  variables: VariableDeclaration[],
  loopToContinueFunction: Map<number, FunctionDefinition>,
  ast: AST,
): FunctionDefinition {
  const doWhileFuncDef = extractWhileToFunction(
    node,
    variables,
    loopToContinueFunction,
    ast,
    '__warp_do_while_',
  );

  const doBlockDefName = `__warp_do_${loopFnCounter++}`;
  const doBlockRetParams = createParameterList(
    variables.map((v) => cloneASTNode(v, ast)),
    ast,
  );
  const doBlockFuncId = ast.reserveId();

  const doBlockBody = createBlock(
    [
      cloneASTNode(node.vBody, ast),
      createReturn(createLoopCall(doWhileFuncDef, variables, ast), doBlockRetParams.id, ast),
    ],
    ast,
  );

  const doBlockFuncDef = new FunctionDefinition(
    doBlockFuncId,
    node.src,
    doWhileFuncDef.scope,
    doWhileFuncDef.kind,
    doBlockDefName,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    createParameterList(
      variables.map((v) => cloneASTNode(v, ast)),
      ast,
    ),
    doBlockRetParams,
    [],
    undefined,
    doBlockBody,
  );

  fixParameterScopes(doBlockFuncDef);

  doWhileFuncDef.vScope.insertAtBeginning(doBlockFuncDef);
  ast.registerChild(doBlockFuncDef, doWhileFuncDef.vScope);
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

export function createLoopCall(
  loopFunction: FunctionDefinition,
  variables: VariableDeclaration[],
  ast: AST,
): FunctionCall {
  return createCallToFunction(
    loopFunction,
    variables.map((v) => createIdentifier(v, ast)),
    ast,
  );
}
