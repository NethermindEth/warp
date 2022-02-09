import {
  Assignment,
  ASTNode,
  Block,
  ContractDefinition,
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
import { cloneVariableDeclaration } from '../../utils/cloning';
import { createIdentifier, getFunctionTypeString, getReturnTypeString } from '../../utils/utils';

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

export function extractToFunction(
  node: WhileStatement,
  variables: VariableDeclaration[],
  ast: AST,
): FunctionDefinition {
  const scope = node.getClosestParentByType<ContractDefinition>(ContractDefinition) ?? ast.root;

  const retParamsId = ast.reserveId();
  const defId = ast.reserveId();
  const defName = `__warp_while${loopFnCounter++}`;

  const funcBody = new Block(ast.reserveId(), '', 'Block', [
    createStartingIf(node.vCondition, node.vBody, variables, retParamsId, ast),
  ]);

  const funcDef = new FunctionDefinition(
    defId,
    node.src,
    'FunctionDefinition',
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
      'ParameterList',
      variables.map((v) => cloneVariableDeclaration(v, ast)),
    ),
    new ParameterList(
      retParamsId,
      '',
      'ParameterList',
      variables.map((v) => cloneVariableDeclaration(v, ast)),
    ),
    [],
    undefined,
    funcBody,
  );

  scope.insertAtBeginning(funcDef);
  ast.registerChild(funcDef, scope);

  ast.insertStatementAfter(
    node.vBody,
    new Return(
      ast.reserveId(),
      '',
      'Return',
      funcDef.vReturnParameters.id,
      createLoopCall(funcDef, variables, ast),
    ),
  );

  return funcDef;
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
    'IfStatement',
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
  return new Return(ast.reserveId(), '', 'Return', retParamListId, retValue);
}

export function toSingleExpression(expressions: Expression[], ast: AST): Expression {
  if (expressions.length === 1) return expressions[0];

  return new TupleExpression(
    ast.reserveId(),
    '',
    'Tuple',
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
    'FunctionCall',
    getReturnTypeString(loopFunction),
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      'Identifier',
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
    'ExpressionStatement',
    resultIdentifiers.length === 0
      ? createLoopCall(functionDef, [...unboundVariables.keys()], ast)
      : new Assignment(
          ast.reserveId(),
          '',
          'Assignment',
          assignmentValue.typeString,
          '=',
          assignmentValue,
          createLoopCall(functionDef, [...unboundVariables.keys()], ast),
        ),
    node.documentation,
    node.raw,
  );
}
