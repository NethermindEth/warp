import assert = require('assert');
import {
  Assignment,
  ASTNode,
  Block,
  Break,
  DataLocation,
  DoWhileStatement,
  ElementaryTypeName,
  ExpressionStatement,
  FunctionDefinition,
  IfStatement,
  Mutability,
  Return,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { createBoolLiteral, createIdentifier } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { toSingleExpression } from './utils';

export class ReturnToBreak extends ASTMapper {
  returnFlags: Map<WhileStatement | DoWhileStatement, VariableDeclaration> = new Map();
  returnVariables: Map<FunctionDefinition, VariableDeclaration[]> = new Map();

  currentOuterLoop: WhileStatement | DoWhileStatement | null = null;

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (!node.vBody) return;

    const loopsWithReturns = node.getChildrenBySelector(
      (n) =>
        (n instanceof WhileStatement || n instanceof DoWhileStatement) &&
        n.getChildren().some((n) => n instanceof Return),
    );

    if (loopsWithReturns.length > 0) {
      const retVars = insertReturnValueDeclaration(node.vBody, ast);
      this.returnVariables.set(node, retVars);
      this.commonVisit(node, ast);
    }
  }

  visitLoop(node: WhileStatement | DoWhileStatement, ast: AST): void {
    if (this.currentOuterLoop === null) {
      if (node.getChildren().some((n) => n instanceof Return)) {
        // Create variables to store the values to return,
        // a flag for whether the loop was broken because of a return,
        // and a handler block to return those variables
        const retFlag = this.createReturnFlag(node, ast);
        const retVars = this.getReturnVariables(node);
        insertOuterLoopRetFlagCheck(node, retFlag, retVars, ast);

        this.currentOuterLoop = node;
        this.commonVisit(node, ast);
        this.currentOuterLoop = null;
      }
    } else {
      if (node.getChildren().some((n) => n instanceof Return)) {
        // Retrieve the flag variable declared for the outermost loop
        // and a a block to the outer loop to break again if it's true
        const retFlag = this.getReturnFlag(this.currentOuterLoop);
        insertInnerLoopRetFlagCheck(node, retFlag, ast);

        this.commonVisit(node, ast);
      }
    }
  }

  visitWhileStatement(node: WhileStatement, ast: AST): void {
    this.visitLoop(node, ast);
  }

  visitDoWhileStatement(node: DoWhileStatement, ast: AST) {
    this.visitLoop(node, ast);
  }

  visitReturn(node: Return, ast: AST): void {
    //We only want to process returns inside loops
    if (this.currentOuterLoop) {
      const retVars = this.getReturnVariables(node);
      storeRetValues(node, retVars, ast);
      const retFlag = this.getReturnFlag(this.currentOuterLoop);
      replaceWithBreak(node, retFlag, ast);
    }
  }

  createReturnFlag(
    containingWhile: WhileStatement | DoWhileStatement,
    ast: AST,
  ): VariableDeclaration {
    const decl = new VariableDeclaration(
      ast.reserveId(),
      '',
      'VariableDeclaration',
      false,
      false,
      `__warp_rf${this.returnFlags.size}`,
      ast.getContainingScope(containingWhile),
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      'bool',
      undefined,
      new ElementaryTypeName(ast.reserveId(), '', 'ElementaryTypeName', 'bool', 'bool'),
    );
    const declStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      'VariableDeclarationStatement',
      [decl.id],
      [decl],
      createBoolLiteral(false, ast),
    );

    ast.insertStatementBefore(containingWhile, declStatement);
    this.returnFlags.set(containingWhile, decl);
    return decl;
  }

  getReturnFlag(whileStatement: WhileStatement | DoWhileStatement): VariableDeclaration {
    const existing = this.returnFlags.get(whileStatement);
    assert(existing !== undefined, `${printNode(whileStatement)} has no return flag`);
    return existing;
  }

  getReturnVariables(node: ASTNode): VariableDeclaration[] {
    const containingFunction = node.getClosestParentByType(FunctionDefinition);
    assert(
      containingFunction !== undefined,
      `Could not find a containing function for ${printNode(node)}`,
    );

    const retVars = this.returnVariables.get(containingFunction);
    assert(retVars !== undefined, `Could not find return variables for ${printNode(node)}`);

    return retVars;
  }
}

let retVarCounter = 0;

function insertReturnValueDeclaration(node: Block, ast: AST): VariableDeclaration[] {
  const containingFunction = node.getClosestParentByType(FunctionDefinition);
  assert(containingFunction !== undefined, `Unable to find containing function for ${node}`);

  if (containingFunction.vReturnParameters.vParameters.length === 0) {
    return [];
  }

  const declarations = containingFunction.vReturnParameters.vParameters.map((v) =>
    cloneASTNode(v, ast),
  );
  declarations.forEach((v) => (v.name = `__warp_rv${retVarCounter++}`));

  const declarationStatement = new VariableDeclarationStatement(
    ast.reserveId(),
    '',
    'VariableDeclarationStatement',
    declarations.map((n) => n.id),
    declarations,
    // TODO initial value once default value function is done
  );

  node.insertAtBeginning(declarationStatement);
  ast.registerChild(declarationStatement, node);

  return declarations;
}

function insertOuterLoopRetFlagCheck(
  node: WhileStatement | DoWhileStatement,
  retFlag: VariableDeclaration,
  retVars: VariableDeclaration[],
  ast: AST,
) {
  const containingFunction = node.getClosestParentByType(FunctionDefinition);
  assert(
    containingFunction !== undefined,
    `Unable to find containing function for ${printNode(node)}`,
  );
  ast.insertStatementAfter(
    node,
    new IfStatement(
      ast.reserveId(),
      '',
      'IfStatement',
      createIdentifier(retFlag, ast),
      new Return(
        ast.reserveId(),
        '',
        'Return',
        containingFunction.vReturnParameters.id,
        toSingleExpression(
          retVars.map((r) => createIdentifier(r, ast)),
          ast,
        ),
      ),
    ),
  );
}

function insertInnerLoopRetFlagCheck(
  node: WhileStatement | DoWhileStatement,
  retFlag: VariableDeclaration,
  ast: AST,
) {
  ast.insertStatementAfter(
    node,
    new IfStatement(
      ast.reserveId(),
      '',
      'IfStatement',
      createIdentifier(retFlag, ast),
      new Break(ast.reserveId(), '', 'Break'),
    ),
  );
}

function replaceWithBreak(node: Return, retFlag: VariableDeclaration, ast: AST) {
  ast.insertStatementBefore(
    node,
    new ExpressionStatement(
      ast.reserveId(),
      '',
      'ExpressionStatement',
      new Assignment(
        ast.reserveId(),
        '',
        'Assignment',
        'bool',
        '=',
        createIdentifier(retFlag, ast),
        createBoolLiteral(true, ast),
      ),
    ),
  );
  ast.replaceNode(
    node,
    new Break(ast.reserveId(), node.src, 'Break', node.documentation, node.raw),
  );
}

function storeRetValues(node: Return, retVars: VariableDeclaration[], ast: AST) {
  if (!node.vExpression) return;

  const lhs = toSingleExpression(
    retVars.map((v) => createIdentifier(v, ast)),
    ast,
  );

  const valueCapture = new ExpressionStatement(
    ast.reserveId(),
    '',
    'ExpressionStatement',
    new Assignment(ast.reserveId(), '', 'Assignment', lhs.typeString, '=', lhs, node.vExpression),
  );

  ast.insertStatementBefore(node, valueCapture);
}
