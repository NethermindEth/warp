import assert from 'assert';
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
import { error } from '../utils/formatting';
import { createCallToFunction } from '../utils/functionStubbing';
import { createIdentifier } from '../utils/nodeTemplates';
import { collectUnboundVariables } from './loopFunctionaliser/utils';

export class IfFunctionaliser extends ASTMapper {
  generatedFunctionCount: Map<FunctionDefinition, number> = new Map();

  visitIfStatement(node: IfStatement, ast: AST): void {
    const block = getContainingBlock(node);

    const postIfStatements = splitBlock(block, node, ast);
    if (postIfStatements.children.length === 0) {
      this.visitStatement(node, ast);
      return;
    }

    const originalFunction = getContainingFunction(node);

    const [funcDef, funcCall] = createSplitFunction(
      originalFunction,
      postIfStatements,
      this.generatedFunctionCount.get(originalFunction) ?? 0,
      ast,
    );
    this.generatedFunctionCount.set(
      originalFunction,
      (this.generatedFunctionCount.get(originalFunction) ?? 0) + 1,
    );

    addSplitFunctionToScope(originalFunction, funcDef, ast);
    addCallsToSplitFunction(node, originalFunction, funcCall, ast);

    ensureBothBranchesAreBlocks(node, ast);

    this.visitStatement(node, ast);
  }
}

function getContainingBlock(node: IfStatement): Block {
  const outerIf = node.getClosestParentByType(IfStatement);

  if (outerIf !== undefined) {
    let block: Statement;
    if (outerIf.vTrueBody.getChildren(true).includes(node)) {
      block = outerIf.vTrueBody;
    } else {
      assert(outerIf.vFalseBody !== undefined);
      block = outerIf.vFalseBody;
    }
    assert(
      block instanceof Block || block instanceof UncheckedBlock,
      `Attempted to functionalise inner if ${printNode(node)} without wrapping`,
    );
    return block;
  }

  const containingFunction = getContainingFunction(node);

  assert(
    containingFunction.vBody !== undefined,
    error(`Unable to find parent of ${printNode(node)}`),
  );
  return containingFunction.vBody;
}

function getContainingFunction(node: IfStatement): FunctionDefinition {
  const func = node.getClosestParentByType(FunctionDefinition);
  assert(func !== undefined, `Unable to find containing function for ${printNode(node)}`);
  return func;
}

function splitBlock(block: Block, split: Statement, ast: AST): Block {
  const res = splitBlockImpl(block, split, ast);
  assert(
    res !== null,
    `Attempted to split ${printNode(block)} around ${printNode(split)}, which is not a child`,
  );
  return res;
}

function splitBlockImpl(block: Block, split: Statement, ast: AST): Block | null {
  const splitIndex = block
    .getChildren()
    .findIndex((statement) => statement.getChildren(true).includes(split));
  if (splitIndex === -1) return null;
  const newBlock =
    block instanceof UncheckedBlock
      ? new UncheckedBlock(ast.reserveId(), '', [])
      : new Block(ast.reserveId(), '', []);
  assert(
    newBlock instanceof block.constructor && block instanceof newBlock.constructor,
    `Encountered unexpected block subclass ${block.constructor.name} when splitting`,
  );

  let foundSplitPoint = false;
  const statementsToExtract: Statement[] = [];
  block.children.forEach((child) => {
    if (foundSplitPoint) {
      assert(
        child instanceof Statement,
        `Found non-statement ${printNode(child)} as child of ${printNode(block)}`,
      );
      statementsToExtract.push(child);
    } else if (child === split) {
      foundSplitPoint = true;
    } else if (child.getChildren().includes(split)) {
      foundSplitPoint = true;
      if (child instanceof Block || child instanceof UncheckedBlock) {
        statementsToExtract.push(splitBlock(child, split, ast));
      } else {
        assert(false);
      }
    }
  });
  statementsToExtract.forEach((child) => {
    if (block.children.includes(child)) {
      block.removeChild(child);
    }
    newBlock.appendChild(child);
  });

  return newBlock;
}

function createSplitFunction(
  existingFunction: FunctionDefinition,
  body: Block,
  counter: number,
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
    existingFunction.scope,
    existingFunction.kind === FunctionKind.Free ? FunctionKind.Free : FunctionKind.Function,
    `${existingFunction.name}_part${counter + 1}`,
    false,
    FunctionVisibility.Private,
    existingFunction.stateMutability,
    false,
    new ParameterList(ast.reserveId(), '', inputParams),
    cloneASTNode(existingFunction.vReturnParameters, ast),
    [],
    undefined,
    body,
  );

  const args = [...unboundVariables.keys()].map((decl) => createIdentifier(decl, ast));

  const call = createCallToFunction(funcDef, args, ast);

  return [funcDef, call];
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

function ensureBothBranchesAreBlocks(node: IfStatement, ast: AST): void {
  if (!(node.vTrueBody instanceof Block) && !(node.vTrueBody instanceof UncheckedBlock)) {
    node.vTrueBody = new Block(ast.reserveId(), '', [node.vTrueBody]);
    ast.registerChild(node.vTrueBody, node);
  }

  if (
    node.vFalseBody &&
    !(node.vFalseBody instanceof Block) &&
    !(node.vFalseBody instanceof UncheckedBlock)
  ) {
    node.vFalseBody = new Block(ast.reserveId(), '', [node.vFalseBody]);
    ast.registerChild(node.vFalseBody, node);
  }
}
