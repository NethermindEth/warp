import {
  Block,
  FunctionCall,
  Identifier,
  IfStatement,
  UncheckedBlock,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { createBlock, createCairoTempVar } from '../utils/nodeTemplates';
import { hasPathWithoutReturn } from '../utils/controlFlowAnalyser';
import assert from 'assert';
import { isBlock } from '../export';

/*
 * This pass does a live variable analysis of the code while simultaneously
 * postpending tempvars of the live variables at the end of each if branch and
 * after each IfStatement in order to prevent against revoked references.
 *
 * A variable is 'live' at a line if there is a reference to the variable after
 * the line in the control flow for which there is no matching declaration.
 *
 * This following:
 *
 ********************
 * // y is not live
 * let y = 0
 *   // y is live
 *   if (x == 0) {
 *   // y is live
 * } else {
 *   // y is not live
 *   let y = 4;
 *   // y is live
 * }
 * g(y) // reference to y
 ********************
 *
 * Becomes:
 *
 ********************
 * // y is not live
 * let y = 0
 * // y is live
 * if (x == 0) {
 *   // y is live
 *   tempvar y = y;
 * } else {
 *   // y is not live
 *   let y = 4;
 *   // y is live
 *   tempvar y = y;
 * }
 * tempvar y = y;
 * g(y) // reference to y
 ********************
 */

export class IfStatementTempVarPostpender extends ASTMapper {
  private liveVars: Set<string> = new Set();

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'An', // AnotateImplicit pass creates cairoFunctionDefinitions which this pass use
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    this.liveVars = new Set<string>();
    [...node.implicits].forEach((implicit) => this.liveVars.add(implicit));

    // analyse the block
    if (node.vBody !== undefined) {
      this.dispatchVisit(node.vBody, ast);
    }

    // remove the parameters and implicits
    const deadVars = [...node.implicits].filter((implicit) => !this.liveVars.delete(implicit));
    if (deadVars.length > 0) {
      throw new TranspileFailedError(
        `Implicit variable(s) dead in function ${node.name}:\n ${deadVars
          .map((implicit) => `  * ${implicit}`)
          .join('\n')} `,
      );
    }

    this.liveVars = new Set<string>();
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (
      node.vReferencedDeclaration !== undefined &&
      node.vReferencedDeclaration.getClosestParentByType(CairoFunctionDefinition) !== undefined
    ) {
      this.liveVars.add(node.name);
    }
  }

  visitBlock(node: Block, ast: AST): void {
    node.vStatements
      .slice(0)
      .reverse()
      .map((child) => this.dispatchVisit(child, ast));
  }

  visitUncheckedBlock(node: UncheckedBlock, ast: AST): void {
    node.vStatements
      .slice(0)
      .reverse()
      .map((child) => this.dispatchVisit(child, ast));
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    node.vDeclarations.forEach((declaration) => this.liveVars.delete(declaration.name));
    if (node.vInitialValue) {
      this.dispatchVisit(node.vInitialValue, ast);
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    // ignore the function identifier
    for (const arg of node.vArguments) {
      this.dispatchVisit(arg, ast);
    }
  }

  visitIfStatement(node: IfStatement, ast: AST): void {
    ensureBothBranchesAreBlocks(node, ast);
    assert(node.vTrueBody instanceof Block && node.vFalseBody instanceof Block);

    const liveVarsBefore = new Set(this.liveVars);
    this.dispatchVisit(node.vTrueBody, ast);
    const liveVarsAfterTrueBody = new Set(this.liveVars);

    this.liveVars = new Set(liveVarsBefore);
    let liveVarsAfterFalseBody = new Set<string>();

    this.dispatchVisit(node.vFalseBody, ast);
    liveVarsAfterFalseBody = new Set(this.liveVars);

    this.liveVars = new Set(liveVarsBefore);
    this.dispatchVisit(node.vCondition, ast);

    this.liveVars = new Set([
      ...this.liveVars,
      ...liveVarsAfterFalseBody,
      ...liveVarsAfterTrueBody,
    ]);

    const trueHasPathWithoutReturn = hasPathWithoutReturn(node.vTrueBody);
    if (trueHasPathWithoutReturn) {
      setBlockTempvars(node.vTrueBody, liveVarsBefore, ast);
    }

    const falseHasPathWithoutReturn = hasPathWithoutReturn(node.vFalseBody);
    if (falseHasPathWithoutReturn) {
      setBlockTempvars(node.vFalseBody, liveVarsBefore, ast);
    }

    if (falseHasPathWithoutReturn || trueHasPathWithoutReturn) {
      const parent = node.parent;
      const blockWithAfter = createBlock(
        [node, ...[...liveVarsBefore].map((v) => createCairoTempVar(v, ast))],
        ast,
      );
      ast.replaceNode(node, blockWithAfter, parent);
    }
  }
}

function ensureBothBranchesAreBlocks(node: IfStatement, ast: AST): void {
  if (!isBlock(node.vTrueBody)) {
    node.vTrueBody = createBlock([node.vTrueBody], ast);
    ast.registerChild(node.vTrueBody, node);
  }

  if (node.vFalseBody === undefined) {
    node.vFalseBody = createBlock([], ast);
    ast.registerChild(node.vFalseBody, node);
  } else if (!isBlock(node.vFalseBody)) {
    node.vFalseBody = createBlock([node.vFalseBody], ast);
    ast.registerChild(node.vFalseBody, node);
  }
}

function setBlockTempvars(node: Block, liveVars: Set<string>, ast: AST) {
  for (const liveVar of liveVars) {
    const child = createCairoTempVar(liveVar, ast);
    node.appendChild(child);
    ast.registerChild(child, node);
  }
}
