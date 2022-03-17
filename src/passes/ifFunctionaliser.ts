import assert = require('assert');
import {
  Block,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  IfStatement,
  ParameterList,
  Return,
  Statement,
  UncheckedBlock,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { error } from '../utils/errors';
import { createCallToFunction } from '../utils/functionStubbing';
import { createIdentifier } from '../utils/nodeTemplates';
import { collectUnboundVariables } from './loopFunctionaliser/utils';

// TODO check if one branch has a return in it
// TODO split taking into account nested blocks

export class IfFunctionaliser extends ASTMapper {
  visitIfStatement(node: IfStatement, ast: AST): void {
    const block = getContainingBlock(node);

    const postIfStatements = splitBlock(block, node, ast);
    const originalFunction = getContainingFunction(node);

    const [funcDef, funcCall] = createSplitFunction(originalFunction, postIfStatements, ast);

    addSplitFunctionToScope(originalFunction, funcDef, ast);
    addCallsToSplitFunction(node, originalFunction, funcCall, ast);
  }
}

function getContainingBlock(node: IfStatement): Block {
  const block = node.getClosestParentBySelector<Block>(
    (node) => node instanceof Block || node instanceof UncheckedBlock,
  );
  assert(block !== undefined, error(`Unable to find parent of ${printNode(node)}`));
  return block;
}

function getContainingFunction(node: IfStatement): FunctionDefinition {
  const func = node.getClosestParentByType(FunctionDefinition);
  assert(func !== undefined, `Unable to find containing function for ${node}`);
  return func;
}

function splitBlock(block: Block, split: Statement, ast: AST): Block {
  const splitIndex = block.children.findIndex((statement) => statement === split);
  assert(splitIndex !== -1);
  const newBlock = new Block(ast.reserveId(), '', 'Block', []);
  console.log('Splitting');
  while (block.children.length > splitIndex + 1) {
    const child = block.children[splitIndex + 1];
    block.removeChild(child);
    newBlock.appendChild(child);
    console.log(`Appending ${printNode(child)}`);
  }
  return newBlock;
}

function createSplitFunction(
  existingFunction: FunctionDefinition,
  body: Block,
  ast: AST,
): [FunctionDefinition, FunctionCall] {
  // Collect variables referenced in the split function that need to be passed in
  const unboundVariables = new Map(
    [...collectUnboundVariables(body).entries()].filter(([decl]) => !decl.stateVariable),
  );

  const inputParams = [...unboundVariables.entries()].map(([decl, ids]) => {
    const newDecl = cloneASTNode(decl, ast);
    ids.forEach((id) => (id.referencedDeclaration = newDecl.id));
    return newDecl;
  });

  const funcDef = new FunctionDefinition(
    ast.reserveId(),
    '',
    'FunctionDefinition',
    existingFunction.scope,
    existingFunction.kind === FunctionKind.Free ? FunctionKind.Free : FunctionKind.Function,
    generateNewFunctionName(existingFunction.name),
    false,
    FunctionVisibility.Private,
    existingFunction.stateMutability,
    false,
    new ParameterList(ast.reserveId(), '', 'ParameterList', inputParams),
    cloneASTNode(existingFunction.vReturnParameters, ast),
    [],
    undefined,
    body,
  );

  const args = [...unboundVariables.keys()].map((decl) => createIdentifier(decl, ast));

  const call = createCallToFunction(funcDef, args, ast);

  return [funcDef, call];
}

function generateNewFunctionName(name: string): string {
  const alreadySplitTest = new RegExp('_part[0-9]+$');
  const match = name.search(alreadySplitTest);
  if (match === -1) {
    return `${name}_part2`;
  } else {
    // Extract the number from the end of the function name,
    // then replace it with its incremented value
    const numStart = match + '_part'.length;
    const splitCount = parseInt(name.slice(numStart));
    return `${name.slice(0, numStart)}${splitCount + 1}`;
  }
}

function addSplitFunctionToScope(
  originalFunction: FunctionDefinition,
  splitFunction: FunctionDefinition,
  ast: AST,
): void {
  originalFunction.vScope.insertAfter(splitFunction, originalFunction);
  ast.registerChild(splitFunction, originalFunction.vScope);
}

function addCallsToSplitFunction(
  node: IfStatement,
  originalFunction: FunctionDefinition,
  call: FunctionCall,
  ast: AST,
) {
  const returnStatement = new Return(
    ast.reserveId(),
    '',
    'Return',
    originalFunction.vReturnParameters.id,
    call,
  );
  ast.insertStatementAfter(node.vTrueBody, returnStatement);

  if (node.vFalseBody) {
    ast.insertStatementAfter(node.vFalseBody, cloneASTNode(returnStatement, ast));
  } else {
    node.vFalseBody = cloneASTNode(returnStatement, ast);
    ast.registerChild(node.vFalseBody, node);
  }
}
