import assert from 'assert';
import {
  Assignment,
  ASTNode,
  ContractDefinition,
  DoWhileStatement,
  Expression,
  ExpressionStatement,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Identifier,
  IfStatement,
  SourceUnit,
  Statement,
  VariableDeclaration,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode } from '../../utils/astPrinter';
import { cloneASTNode } from '../../utils/cloning';
import { createCallToFunction } from '../../utils/functionGeneration';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';
import { toSingleExpression } from '../../utils/utils';

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

function fixParameterScopes(node: FunctionDefinition): void {
  [...node.vParameters.vParameters, ...node.vReturnParameters.vParameters].forEach(
    (decl) => (decl.scope = node.id),
  );
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
