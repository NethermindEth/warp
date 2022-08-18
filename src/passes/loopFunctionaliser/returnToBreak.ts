import assert from 'assert';
import {
  Assignment,
  ASTNode,
  Block,
  Break,
  DataLocation,
  DoWhileStatement,
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
import {
  createBoolLiteral,
  createBoolTypeName,
  createIdentifier,
  createReturn,
} from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { getContainingFunction, toSingleExpression } from '../../utils/utils';
import { RETURN_FLAG_PREFIX, RETURN_VALUE_PREFIX } from '../../utils/nameModifiers';

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
      false,
      false,
      `${RETURN_FLAG_PREFIX}${this.returnFlags.size}`,
      ast.getContainingScope(containingWhile),
      false,
      DataLocation.Default,
      StateVariableVisibility.Default,
      Mutability.Mutable,
      'bool',
      undefined,
      createBoolTypeName(ast),
    );
    const declStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
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
    const containingFunction = getContainingFunction(node);

    const retVars = this.returnVariables.get(containingFunction);
    assert(retVars !== undefined, `Could not find return variables for ${printNode(node)}`);

    return retVars;
  }
}

let retVarCounter = 0;

function insertReturnValueDeclaration(node: Block, ast: AST): VariableDeclaration[] {
  const containingFunction = getContainingFunction(node);
  if (containingFunction.vReturnParameters.vParameters.length === 0) {
    return [];
  }

  const declarations = containingFunction.vReturnParameters.vParameters.map((v) =>
    cloneASTNode(v, ast),
  );
  declarations.forEach((v) => (v.name = `${RETURN_VALUE_PREFIX}${retVarCounter++}`));

  const declarationStatement = new VariableDeclarationStatement(
    ast.reserveId(),
    '',
    declarations.map((n) => n.id),
    declarations,
    // variableDeclarationInitialiser runs after this, so no need to give a default value
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
): void {
  const containingFunction = getContainingFunction(node);
  ast.insertStatementAfter(
    node,
    new IfStatement(
      ast.reserveId(),
      '',
      createIdentifier(retFlag, ast),
      createReturn(retVars, containingFunction.vReturnParameters.id, ast),
    ),
  );
}

function insertInnerLoopRetFlagCheck(
  node: WhileStatement | DoWhileStatement,
  retFlag: VariableDeclaration,
  ast: AST,
): void {
  ast.insertStatementAfter(
    node,
    new IfStatement(
      ast.reserveId(),
      '',
      createIdentifier(retFlag, ast),
      new Break(ast.reserveId(), ''),
    ),
  );
}

function replaceWithBreak(node: Return, retFlag: VariableDeclaration, ast: AST): void {
  ast.insertStatementBefore(
    node,
    new ExpressionStatement(
      ast.reserveId(),
      '',
      new Assignment(
        ast.reserveId(),
        '',
        'bool',
        '=',
        createIdentifier(retFlag, ast),
        createBoolLiteral(true, ast),
      ),
    ),
  );
  ast.replaceNode(node, new Break(ast.reserveId(), node.src, node.documentation, node.raw));
}

function storeRetValues(node: Return, retVars: VariableDeclaration[], ast: AST): void {
  if (!node.vExpression) return;

  const lhs = toSingleExpression(
    retVars.map((v) => createIdentifier(v, ast)),
    ast,
  );

  const valueCapture = new ExpressionStatement(
    ast.reserveId(),
    '',
    new Assignment(ast.reserveId(), '', lhs.typeString, '=', lhs, node.vExpression),
  );

  ast.insertStatementBefore(node, valueCapture);
}
