import assert = require('assert');
import {
  ASTContext,
  ASTNode,
  Block,
  DataLocation,
  Expression,
  Identifier,
  Mutability,
  SourceUnit,
  Statement,
  StatementWithChildren,
  StateVariableVisibility,
  TypeName,
  UncheckedBlock,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { CairoUtilFuncGen } from '../cairoUtilFuncGen';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';
import { Implicits } from '../utils/implicits';
import { mergeImports } from '../utils/utils';
import { CairoFunctionDefinition } from './cairoNodes';

export type FunctionImplicits = Map<string, Set<Implicits>>;

export class AST {
  // SourceUnit id -> CairoUtilFuncGen
  private cairoUtilFuncGen: Map<number, CairoUtilFuncGen> = new Map();
  context: ASTContext;
  // node requiring cairo import -> file to import from -> symbols to import
  imports: Map<ASTNode, Map<string, Set<string>>> = new Map();

  readonly tempId = -1;

  constructor(public roots: SourceUnit[], public compilerVersion: string) {
    assert(
      roots.length > 0,
      'An ast must have at least one root so that the context can be set correctly',
    );
    assert(
      roots.every((sourceUnit) => sourceUnit.requiredContext === roots[0].requiredContext),
      'All contexts should be the same, otherwise they are from seperate solc-typed-ast compiles and they will have no relationship to each other.',
    );
    this.context = roots[0].requiredContext;
    assert(
      this.context.locate(this.tempId) === undefined,
      `Attempted to create an AST with a context that already has ${this.tempId} registered`,
    );
  }

  copyRegisteredImports(oldNode: ASTNode, newNode: ASTNode): void {
    const oldNodeImports = this.imports.get(oldNode) ?? new Map<string, Set<string>>();
    const newNodeImports = new Map(
      [...oldNodeImports.entries()].map(([file, symbols]) => [file, new Set([...symbols.keys()])]),
    );
    this.imports.set(newNode, newNodeImports);
  }

  getUtilFuncGen(node: ASTNode): CairoUtilFuncGen {
    const sourceUnit = node instanceof SourceUnit ? node : node.getClosestParentByType(SourceUnit);
    assert(
      sourceUnit !== undefined,
      'Could not find the sourceUnit to attach the nodes generated functions to',
    );
    const gen = this.cairoUtilFuncGen.get(sourceUnit.id);
    if (gen === undefined) {
      const newGen = new CairoUtilFuncGen(this);
      this.cairoUtilFuncGen.set(sourceUnit.id, newGen);
      return newGen;
    }
    return gen;
  }

  extractToConstant(node: Expression, vType: TypeName, newName: string): Identifier {
    const scope = this.getContainingScope(node);
    const replacementVariable = new VariableDeclaration(
      this.tempId,
      node.src,
      'VariableDeclaration',
      true,
      false,
      newName,
      scope,
      false,
      DataLocation.Memory,
      StateVariableVisibility.Private,
      Mutability.Constant,
      node.typeString,
      undefined,
      vType,
    );
    this.setContextRecursive(replacementVariable);
    const declaration = new VariableDeclarationStatement(
      this.tempId,
      node.src,
      'VariableDeclarationStatement',
      [replacementVariable.id],
      [replacementVariable],
    );
    this.insertStatementBefore(node, declaration);
    const replacementIdentifer = new Identifier(
      this.tempId,
      node.src,
      'Identifier',
      node.typeString,
      newName,
      replacementVariable.id,
      node.raw,
    );
    this.replaceNode(node, replacementIdentifer);
    declaration.vInitialValue = node;
    this.registerChild(node, declaration);
    return replacementIdentifer;
  }

  getContainingScope(node: ASTNode): number {
    const scope = node.getClosestParentBySelector(
      (node) => node instanceof Block || node instanceof UncheckedBlock,
    );
    if (scope === undefined) {
      // TODO improve this to always produce the scope
      console.log(`WARNING: Unable to find scope of ${printNode(node)}`);
      return -1;
    }
    return scope.id;
  }

  getImplicitsAt(node: Statement): Set<Implicits> {
    const containingFunction = node.getClosestParentByType(CairoFunctionDefinition);
    if (containingFunction === undefined) return new Set();

    return containingFunction.implicits;
  }

  getImports(sourceUnit: SourceUnit): Map<string, Set<string>> {
    assert(
      this.roots.includes(sourceUnit),
      `Tried to get imports associated with ${printNode(
        sourceUnit,
      )}, which is not one of the roots of the AST`,
    );
    const reachableNodeImports = sourceUnit
      .getChildren(true)
      .map((node) => this.imports.get(node) ?? new Map<string, Set<string>>());
    const utilFunctionImports = this.getUtilFuncGen(sourceUnit)?.imports;
    return reachableNodeImports.reduce(mergeImports, utilFunctionImports);
  }

  insertStatementAfter(existingNode: ASTNode, newStatement: Statement) {
    const existingStatementRoot = existingNode.getClosestParentByType(SourceUnit);
    assert(
      existingStatementRoot !== undefined,
      `Attempted to insert statement ${printNode(newStatement)} before ${printNode(
        existingNode,
      )} which is not a child of a source unit`,
    );
    assert(
      this.roots.includes(existingStatementRoot),
      `Existing node root: #${existingStatementRoot.id} is not in the ast roots: ${this.roots.map(
        (su) => '#' + su.id,
      )}`,
    );

    // Find the statement that newStatement needs to go in front of
    const existingStatement =
      existingNode instanceof Statement || existingNode instanceof StatementWithChildren
        ? existingNode
        : existingNode.getClosestParentBySelector<Statement>(
            (parent) => parent instanceof Statement || parent instanceof StatementWithChildren,
          );

    assert(
      existingStatement !== undefined,
      `Unable to find containing statement for ${printNode(existingNode)}`,
    );

    if (
      existingStatement.parent instanceof Block ||
      existingStatement.parent instanceof UncheckedBlock
    ) {
      // This sets the parent but not the context
      existingStatement.parent.insertAfter(newStatement, existingStatement);
      this.setContextRecursive(newStatement);
      return;
    }

    const parent = existingStatement.parent;
    // Blocks are not instances of Statements, but they satisy typescript shaped typing rules to be classed as Statements
    // TODO potentially handle src better
    const replacementBlock = new Block(this.reserveId(), existingStatement.src, 'Block', [
      existingStatement,
      newStatement,
    ]);
    this.replaceNode(existingStatement, replacementBlock, parent);
  }

  insertStatementBefore(existingNode: ASTNode, newStatement: Statement) {
    const existingStatementRoot = existingNode.getClosestParentByType(SourceUnit);
    assert(
      existingStatementRoot !== undefined,
      `Attempted to insert statement ${printNode(newStatement)} before ${printNode(
        existingNode,
      )} which is not a child of a source unit`,
    );
    assert(
      this.roots.includes(existingStatementRoot),
      `Existing node root: #${existingStatementRoot.id} is not in the ast roots: ${this.roots.map(
        (su) => '#' + su.id,
      )}`,
    );

    // Find the statement that newStatement needs to go in front of
    const existingStatement =
      existingNode instanceof Statement || existingNode instanceof StatementWithChildren
        ? existingNode
        : existingNode.getClosestParentBySelector<Statement>(
            (parent) => parent instanceof Statement || parent instanceof StatementWithChildren,
          );

    assert(
      existingStatement !== undefined,
      `Unable to find containing statement for ${printNode(existingNode)}`,
    );

    if (
      existingStatement.parent instanceof Block ||
      existingStatement.parent instanceof UncheckedBlock
    ) {
      // This sets the parent but not the context
      existingStatement.parent.insertBefore(newStatement, existingStatement);
      this.setContextRecursive(newStatement);
      return;
    }

    const parent = existingStatement.parent;
    // Blocks are not instances of Statements, but they satisy typescript shaped typing rules to be classed as Statements
    // TODO potentially handle src better
    const replacementBlock = new Block(-1, existingStatement.src, 'Block', [
      newStatement,
      existingStatement,
    ]);
    this.replaceNode(existingStatement, replacementBlock, parent);
  }

  registerChild(child: ASTNode, parent: ASTNode): number {
    this.setContextRecursive(child);
    child.parent = parent;
    assert(
      parent.children.includes(child),
      `Child ${printNode(child)} not found in parent ${printNode(parent)}'s children`,
    );
    return child.id;
  }

  registerImport(node: ASTNode, location: string, name: string): void {
    const nodeImports = this.imports.get(node) ?? new Map<string, Set<string>>();
    const fileImports = nodeImports.get(location) ?? new Set<string>();
    fileImports.add(name);
    nodeImports.set(location, fileImports);
    this.imports.set(node, nodeImports);
  }

  removeStatement(statement: Statement): void {
    const parent = statement.parent;
    assert(parent !== undefined, `${printNode(statement)} has no parent`);
    if (parent instanceof StatementWithChildren) {
      parent.removeChild(statement);
    } else {
      this.replaceNode(
        statement,
        new Block(
          this.reserveId(),
          statement.src,
          'Block',
          [],
          statement.documentation,
          statement.raw,
        ),
      );
    }
  }

  // TODO tighten these restraints
  // Reference notes/astnodetypes.ts for exact restrictions on what can safely be replaced with what
  replaceNode(
    oldNode: Expression,
    newNode: Expression,
    parent?: ASTNode,
    copyImports?: boolean,
  ): number;
  replaceNode(
    oldNode: Statement,
    newNode: Statement,
    parent?: ASTNode,
    copyImports?: boolean,
  ): number;
  replaceNode(oldNode: ASTNode, newNode: ASTNode, parent?: ASTNode, copyImports = false): number {
    if (oldNode === newNode) {
      console.log('WARNING: Attempted to replace node with itself');
      return oldNode.id;
    }
    if (parent === undefined) {
      if (newNode.getChildren().includes(oldNode)) {
        throw new TranspileFailedError(
          'Parent must be provided when replacing a node with a subtree containing that node',
        );
      } else {
        parent = oldNode.parent;
        if (oldNode.parent === undefined) {
          console.log(`WARNING: Attempting to replace ${printNode(oldNode)} which has no parent`);
        }
        oldNode.parent = undefined;
      }
    }

    replaceNode(oldNode, newNode, parent);
    this.context.unregister(oldNode);
    this.setContextRecursive(newNode);
    if (copyImports) {
      this.copyRegisteredImports(oldNode, newNode);
    }
    return newNode.id;
  }

  reserveId(): number {
    return reserveSafeId(this.context);
  }

  setContextRecursive(node: ASTNode): number {
    node.walk((n) => {
      if (n.id === this.tempId) {
        n.id = this.reserveId();
      }
      if (!this.context.contains(n)) {
        if (n.context !== undefined) {
          throw new TranspileFailedError(
            `Context defined incorrectly during setContextRecursive for node ${printNode(n)}`,
          );
        }
        if (this.context.locate(n.id)) {
          throw new TranspileFailedError(
            `Attempted to register ${printNode(n)} with context, when ${printNode(
              this.context.locate(n.id),
            )} has same id`,
          );
        }
        this.context.register(n);
      }
    });
    return node.id;
  }
}

// Based on the solc-typed-ast replaceNode function, but with adjustments for contexts
function replaceNode(oldNode: ASTNode, newNode: ASTNode, parent: ASTNode | undefined): void {
  if (newNode.context !== undefined && oldNode.context !== newNode.context) {
    throw new TranspileFailedError('Context mismatch');
  }

  if (parent === undefined) {
    return;
  }

  const ownProps = Object.getOwnPropertyDescriptors(parent);

  for (const name in ownProps) {
    const val = ownProps[name].value;

    if (val === oldNode) {
      Object.assign(parent, Object.fromEntries([[name, newNode]]));

      parent.acceptChildren();

      return;
    }

    if (val instanceof Array) {
      for (let i = 0; i < val.length; i++) {
        if (val[i] === oldNode) {
          val[i] = newNode;

          parent.acceptChildren();

          return;
        }
      }
    }

    if (val instanceof Map) {
      for (const [k, v] of val.entries()) {
        if (v === oldNode) {
          val.set(k, newNode);

          parent.acceptChildren();

          return;
        }
      }
    }
  }

  throw new TranspileFailedError(
    `Couldn't find child ${oldNode.type}#${oldNode.id} under parent ${parent.type}#${parent.id}`,
  );
}

//----------------------------------Safe ids-----------------------------------

// Different source units can share contexts
// This means ASTs have to share a registry of reserved ids

const _safeIds: Map<ASTContext, number> = new Map();
function reserveSafeId(context: ASTContext): number {
  const id = _safeIds.get(context);
  if (id === undefined) {
    _safeIds.set(context, context.lastId + 2);
    return context.lastId + 1;
  } else {
    _safeIds.set(context, id + 1);
    return id;
  }
}
