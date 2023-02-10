import assert from 'assert';
import {
  ASTContext,
  ASTNode,
  Block,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
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
import { SolcOutput } from '../solCompile';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';
import { Implicits } from '../utils/implicits';
import { createBlock } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getContainingSourceUnit, isExternalCall, mergeImports } from '../utils/utils';
import { CairoFunctionDefinition } from './cairoNodes';
import { WarpInferType } from './warpInferType';

/*
 A centralised store of information required for transpilation, a reference
 to the AST is passed around during processing so that such information is 
 always available.
 Both contains members that exist in the original compilation data, such as
 compilerVersion and context, that are generally inconvenient to access from
 arbitrary points in the tree, as well as holding information we create during
 the course of transpilation such as the import mappings.

 When creating nodes, it is important to assign their context. There are 3 ways
 to do this:
 - setContextRecursive is the most basic and handles the given node and all children
 - registerChild is for when you add a child node, it ensures both contexts and parent
 links are set correctly
 - replaceNode is for when you need to replace the current node that is being visited
 with a new one. Should only be used where necessary as it can be used to get around
 the type system. If the new node is of the same type as the current one, assigning to
 members of the existing node is preferred
*/

export class AST {
  // SourceUnit id -> CairoUtilFuncGen
  private cairoUtilFuncGen: Map<number, CairoUtilFuncGen> = new Map();

  context: ASTContext;
  // node requiring cairo import -> file to import from -> symbols to import
  imports: Map<ASTNode, Map<string, Set<string>>> = new Map();
  public inference: WarpInferType;

  readonly tempId = -1;

  constructor(
    public roots: SourceUnit[],
    compilerVersion: string,
    public solidityABI: SolcOutput['result'],
  ) {
    assert(
      roots.length > 0,
      'An ast must have at least one root so that the context can be set correctly',
    );
    assert(
      roots.every((sourceUnit) => sourceUnit.requiredContext === roots[0].requiredContext),
      'All contexts should be the same, otherwise they are from seperate solc-typed-ast compiles and they will have no relationship to each other.',
    );
    this.context = roots[0].requiredContext;
    this.inference = new WarpInferType(compilerVersion);
    assert(
      this.context.locate(this.tempId) === undefined,
      `Attempted to create an AST with a context that already has ${this.tempId} registered`,
    );
  }

  copyRegisteredImports(oldNode: ASTNode, newNode: ASTNode): void {
    this.imports.set(
      newNode,
      mergeImports(
        this.imports.get(oldNode) ?? new Map<string, Set<string>>(),
        this.imports.get(newNode) ?? new Map<string, Set<string>>(),
      ),
    );
  }

  extractToConstant(
    node: Expression,
    vType: TypeName,
    newName: string,
  ): [insertedIdentifier: Identifier, declaration: VariableDeclarationStatement] {
    const scope = this.getContainingScope(node);
    let location: DataLocation;
    if (node instanceof FunctionCall && isExternalCall(node)) {
      location =
        generalizeType(safeGetNodeType(node, this.inference))[1] === undefined
          ? DataLocation.Default
          : DataLocation.CallData;
    } else {
      location = generalizeType(safeGetNodeType(node, this.inference))[1] ?? DataLocation.Default;
    }
    const replacementVariable = new VariableDeclaration(
      this.tempId,
      node.src,
      true, // constant
      false, // indexed
      newName,
      scope,
      false, // stateVariable
      location,
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
      [replacementVariable.id],
      [replacementVariable],
    );
    this.insertStatementBefore(node, declaration);
    const replacementIdentifer = new Identifier(
      this.tempId,
      node.src,
      node.typeString,
      newName,
      replacementVariable.id,
      node.raw,
    );
    this.replaceNode(node, replacementIdentifer);
    declaration.vInitialValue = node;
    this.registerChild(node, declaration);
    return [replacementIdentifer, declaration];
  }

  getContainingRoot(node: ASTNode): SourceUnit {
    if (node instanceof SourceUnit) return node;

    const root = getContainingSourceUnit(node);
    assert(
      this.roots.includes(root),
      `Found ${printNode(root)} as root of ${printNode(node)}, but this is not in the AST roots`,
    );

    return root;
  }

  getContainingScope(node: ASTNode): number {
    const scope = node.getClosestParentBySelector(
      (node) => node instanceof Block || node instanceof UncheckedBlock,
    );
    if (scope === undefined) {
      // post-audit TODO improve this to always produce the scope and to follow solc-typed-ast's
      // rules for scope being lexical scope
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
    const utilFunctionImports = this.getUtilFuncGen(sourceUnit)?.getImports();
    return mergeImports(utilFunctionImports, ...reachableNodeImports);
  }

  getUtilFuncGen(node: ASTNode): CairoUtilFuncGen {
    const sourceUnit = node instanceof SourceUnit ? node : getContainingSourceUnit(node);
    const gen = this.cairoUtilFuncGen.get(sourceUnit.id);
    if (gen === undefined) {
      const newGen = new CairoUtilFuncGen(this, sourceUnit);
      this.cairoUtilFuncGen.set(sourceUnit.id, newGen);
      return newGen;
    }
    return gen;
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
    const replacementBlock = createBlock([existingStatement, newStatement], this);
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
    const replacementBlock = createBlock([newStatement, existingStatement], this);
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
      this.replaceNode(statement, createBlock([], this, statement.documentation));
    }
  }

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
  replaceNode(oldNode: ASTNode, newNode: ASTNode, parent?: ASTNode, copyImports = true): number {
    if (oldNode === newNode) {
      console.log(`WARNING: Attempted to replace node ${printNode(oldNode)} with itself`);
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
    } else if (newNode.getChildren(true).includes(parent)) {
      throw new TranspileFailedError(
        `Attempted to insert a subtree containing the given parent node ${printNode(parent)}`,
      );
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

// TODO now that AST contains multiple roots, this may not be necessary

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
