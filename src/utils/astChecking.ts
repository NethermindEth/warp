import assert from 'assert';
import {
  ArrayTypeName,
  Assignment,
  ASTContext,
  ASTNode,
  BinaryOperation,
  Block,
  Break,
  Conditional,
  Continue,
  ContractDefinition,
  DoWhileStatement,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EmitStatement,
  EnumDefinition,
  EnumValue,
  ErrorDefinition,
  EventDefinition,
  Expression,
  ExpressionStatement,
  ForStatement,
  FunctionCall,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionKind,
  FunctionTypeName,
  Identifier,
  IdentifierPath,
  IfStatement,
  ImportDirective,
  IndexAccess,
  IndexRangeAccess,
  InheritanceSpecifier,
  InlineAssembly,
  InsaneASTError,
  Literal,
  Mapping,
  MemberAccess,
  ModifierDefinition,
  ModifierInvocation,
  NewExpression,
  OverrideSpecifier,
  ParameterList,
  PlaceholderStatement,
  PragmaDirective,
  Return,
  RevertStatement,
  SourceUnit,
  StructDefinition,
  StructuredDocumentation,
  Throw,
  TryCatchClause,
  TryStatement,
  TupleExpression,
  UnaryOperation,
  UncheckedBlock,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
  UsingForDirective,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
} from 'solc-typed-ast';
import { pp } from 'solc-typed-ast/dist/misc/index';
import { AST } from '../ast/ast';
import { CairoAssert } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { printNode } from './astPrinter';
import { safeGetNodeType } from './nodeTypeProcessing';
import { isNameless } from './utils';

// This is the solc-typed-ast AST checking code, with additions for CairoAssert and CairoContract

/**
 * Helper function to check if the node/nodes `arg` is in the `ASTContext` `ctx`.
 */
function inCtx(arg: ASTNode | ASTNode[], ctx: ASTContext): boolean {
  if (arg instanceof ASTNode) {
    return ctx.contains(arg);
  }

  for (const node of arg) {
    if (!inCtx(node, ctx)) {
      return false;
    }
  }

  return true;
}

/**
 * Check that the property `prop` of an `ASTNode` `node` is either an `ASTNode`
 * in the expected `ASTContext` `ctx` or an array `ASTNode[]` all of which are in
 * the expected `ASTContext`
 */
function checkVFieldCtx<T extends ASTNode, K extends keyof T>(
  node: T,
  prop: K,
  ctx: ASTContext,
): void {
  const val: T[K] = node[prop];

  if (val instanceof ASTNode) {
    if (!inCtx(val, ctx)) {
      throw new Error(
        `Node ${pp(node)} property ${String(prop)} ${pp(val)} not in expected context ${pp(
          ctx,
        )}. Instead in ${pp(val.context)}`,
      );
    }
  } else if (val instanceof Array) {
    for (let idx = 0; idx < val.length; idx++) {
      const el = val[idx];

      if (!(el instanceof ASTNode)) {
        throw new Error(
          `Expected property ${String(prop)}[${idx}] of ${pp(node)} to be an ASTNode not ${el}`,
        );
      }

      if (!inCtx(val, ctx)) {
        throw new Error(
          `Node ${pp(node)} property ${String(prop)}[${idx}] ${pp(el)} not in expected context ${pp(
            ctx,
          )}. Instead in ${pp(el.context)}`,
        );
      }
    }
  } else {
    throw new Error(
      `Expected property ${String(prop)} of ${pp(node)} to be an ASTNode, not ${val}`,
    );
  }
}

/**
 * Helper to check that:
 *
 * 1) the field `field` of `node` is either a number or array of numbers
 * 2) the field `vField` of `node` is either an `ASTNode` or an array of ASTNodes
 * 3) if field is a number then `vField` is an `ASTNode` and `field == vField.id`
 * 4) if field is an array of numbers then `vField` is an `ASTNode[]` and
 *      `node.field.length === node.vField.length` and `node.field[i] ===
 *      node.vField[i].id` forall i in `[0, ... node.field.lenth)`
 *
 */
function checkFieldAndVFieldMatch<T extends ASTNode, K1 extends keyof T, K2 extends keyof T>(
  node: T,
  field: K1,
  vField: K2,
): void {
  const val1 = node[field];
  const val2 = node[vField];

  if (typeof val1 === 'number') {
    if (!(val2 instanceof ASTNode)) {
      throw new Error(
        `Expected property ${String(vField)} of ${pp(node)} to be an ASTNode when ${String(
          field,
        )} is a number, not ${val2}`,
      );
    }

    if (val1 != val2.id) {
      throw new InsaneASTError(
        `Node ${pp(node)} property ${String(field)} ${val1} differs from ${String(vField)}.id ${pp(
          val2,
        )}`,
      );
    }
  } else if (val1 instanceof Array) {
    if (!(val2 instanceof Array)) {
      throw new Error(
        `Expected property ${String(vField)} of ${pp(node)} to be an array when ${String(
          vField,
        )} is an array, not ${val2}`,
      );
    }

    if (val1.length !== val2.length) {
      throw new InsaneASTError(
        `Node ${pp(node)} array properties ${String(field)} and ${String(
          vField,
        )} have different lengths ${val1.length} != ${val2.length}`,
      );
    }

    for (let idx = 0; idx < val1.length; idx++) {
      const el1 = val1[idx];
      const el2 = val2[idx];

      if (typeof el1 !== 'number') {
        throw new Error(
          `Expected property ${String(field)}[${idx}] of ${pp(node)} to be a number not ${el1}`,
        );
      }

      if (!(el2 instanceof ASTNode)) {
        throw new Error(
          `Expected property ${String(vField)}[${idx}] of ${pp(node)} to be a number not ${el2}`,
        );
      }

      if (el1 != el2.id) {
        throw new InsaneASTError(
          `Node ${pp(node)} property ${String(field)}[${idx}] ${el1} differs from ${String(
            vField,
          )}[${idx}].id ${pp(el2)}`,
        );
      }
    }
  } else {
    throw new Error(
      `Expected property ${String(field)} of ${pp(
        node,
      )} to be a number or  array of numbers not ${val1}`,
    );
  }
}

/**
 * Helper to check that:
 *
 * 1. All ASTNodes that appear in each of the `fields` of `node` is a direct child of `node`
 * 2. All the direct children of `node` are mentioned in some of the `fields`.
 */
function checkDirectChildren<T extends ASTNode>(node: T, ...fields: Array<keyof T>): void {
  const directChildren = new Set(node.children);
  const computedChildren = new Set<ASTNode>();

  for (const field of fields) {
    const val = node[field];

    if (val === undefined) {
      continue;
    }

    if (val instanceof ASTNode) {
      if (!directChildren.has(val)) {
        throw new InsaneASTError(
          `Field ${String(field)} of node ${pp(node)} is not a direct child: ${pp(
            val,
          )} child of ${pp(val.parent)}`,
        );
      }

      computedChildren.add(val);
    } else if (val instanceof Array) {
      for (let i = 0; i < val.length; i++) {
        const el = val[i];

        if (el === null) {
          continue;
        }

        if (!(el instanceof ASTNode)) {
          throw new Error(
            `Field ${String(field)} of ${pp(
              node,
            )} is expected to be ASTNode, array or map with ASTNodes - instead array containing ${el}`,
          );
        }

        if (!directChildren.has(el)) {
          throw new InsaneASTError(
            `Field ${String(field)}[${i}] of node ${pp(node)} is not a direct child: ${pp(
              el,
            )} child of ${pp(el.parent)}`,
          );
        }

        computedChildren.add(el);
      }
    } else if (val instanceof Map) {
      for (const [k, v] of val.entries()) {
        if (v === null) {
          continue;
        }

        if (!(v instanceof ASTNode)) {
          throw new Error(
            `Field ${String(field)} of ${pp(
              node,
            )} is expected to be ASTNode, array or map with ASTNodes - instead map containing ${v}`,
          );
        }

        if (!directChildren.has(v)) {
          throw new InsaneASTError(
            `Field ${String(field)}[${k}] of node ${pp(node)} is not a direct child: ${pp(
              v,
            )} child of ${pp(v.parent)}`,
          );
        }

        computedChildren.add(v);
      }
    } else {
      throw new Error(
        `Field ${String(field)} of ${pp(
          node,
        )} is neither an ASTNode nor an array of ASTNode or nulls: ${val}`,
      );
    }
  }

  if (computedChildren.size < directChildren.size) {
    let missingChild: ASTNode | undefined;

    for (const child of directChildren) {
      if (computedChildren.has(child)) {
        continue;
      }

      missingChild = child;

      break;
    }

    throw new InsaneASTError(
      `Fields ${fields.join(', ')} don't completely cover the direct children: ${pp(
        missingChild,
      )} is missing`,
    );
  }
}

/**
 * Check that a single SourceUnit has a sane structure. This checks that:
 *
 *  - all reachable nodes belong to the same context, have their parent/sibling set correctly,
 *  - all number id properties of nodes point to a node in the same context
 *  - when a number property (e.g. `scope`) has a corresponding `v` prefixed property (e.g. `vScope`)
 *    check that the number property corresponds to the id of the `v` prefixed property.
 *  - most 'v' properties point to direct children of a node
 *
 * NOTE: While this code can be slightly slow, its meant to be used mostly in testing so its
 * not performance critical.
 *
 * @param unit - source unit to check
 * @param ctx - `ASTContext`s for each of the groups of units
 */
export function checkSane(unit: SourceUnit, ctx: ASTContext): void {
  for (const node of unit.getChildren(true)) {
    if (!inCtx(node, ctx)) {
      throw new InsaneASTError(
        `Child ${pp(node)} in different context: ${ctx.id} from expected ${ctx.id}`,
      );
    }

    const immediateChildren = node.children;

    for (const child of immediateChildren) {
      if (child.parent !== node) {
        throw new InsaneASTError(
          `Child ${pp(child)} has wrong parent: expected ${pp(node)} got ${pp(child.parent)}`,
        );
      }
    }

    if (
      node instanceof PragmaDirective ||
      node instanceof StructuredDocumentation ||
      node instanceof EnumValue ||
      node instanceof Break ||
      node instanceof Continue ||
      node instanceof InlineAssembly ||
      node instanceof PlaceholderStatement ||
      node instanceof Throw ||
      node instanceof ElementaryTypeName ||
      node instanceof Literal
    ) {
      /**
       * These nodes do not have any children or references.
       * There is nothing to check, so just skip them.
       */
      continue;
    }

    if (node instanceof SourceUnit) {
      for (const [name, symId] of node.exportedSymbols) {
        const symNode = ctx.locate(symId);

        if (symNode === undefined) {
          throw new InsaneASTError(
            `Exported symbol ${name} ${symId} missing from context ${ctx.id}`,
          );
        }

        if (symNode !== node.vExportedSymbols.get(name)) {
          throw new InsaneASTError(
            `Exported symbol ${name} for id ${symId} (${pp(
              symNode,
            )}) doesn't match vExportedSymbols entry: ${pp(node.vExportedSymbols.get(name))}`,
          );
        }
      }

      checkDirectChildren(
        node,
        'vPragmaDirectives',
        'vImportDirectives',
        'vContracts',
        'vEnums',
        'vStructs',
        'vFunctions',
        'vVariables',
        'vErrors',
        'vUserDefinedValueTypes',
        'vUsingForDirectives',
      );
    } else if (node instanceof ImportDirective) {
      /**
       * Unfortunately due to compiler bugs in older compilers, when child.symbolAliases[i].foreign is a number
       * its invalid. When its an Identifier, only its name is valid.
       */
      if (
        node.vSymbolAliases.length !== 0 &&
        node.vSymbolAliases.length !== node.symbolAliases.length
      ) {
        throw new InsaneASTError(
          `symbolAliases.length (${node.symbolAliases.length}) and vSymboliAliases.length ${
            node.vSymbolAliases.length
          } misamtch for import ${pp(node)}`,
        );
      }

      for (let i = 0; i < node.vSymbolAliases.length; i++) {
        const def = node.vSymbolAliases[i][0];

        if (!inCtx(def, ctx)) {
          throw new InsaneASTError(
            `Imported symbol ${pp(def)} from import ${pp(node)} not in expected context ${pp(ctx)}`,
          );
        }
      }

      checkFieldAndVFieldMatch(node, 'scope', 'vScope');
      checkVFieldCtx(node, 'vScope', ctx);

      checkFieldAndVFieldMatch(node, 'sourceUnit', 'vSourceUnit');
      checkVFieldCtx(node, 'vSourceUnit', ctx);
    } else if (node instanceof InheritanceSpecifier) {
      checkDirectChildren(node, 'vBaseType', 'vArguments');
    } else if (node instanceof ModifierInvocation) {
      checkVFieldCtx(node, 'vModifier', ctx);
      checkDirectChildren(node, 'vModifierName', 'vArguments');
    } else if (node instanceof OverrideSpecifier) {
      checkDirectChildren(node, 'vOverrides');
    } else if (node instanceof ParameterList) {
      checkVFieldCtx(node, 'vParameters', ctx);
      checkDirectChildren(node, 'vParameters');
    } else if (node instanceof UsingForDirective) {
      checkDirectChildren(node, 'vLibraryName', 'vFunctionList', 'vTypeName');
    } else if (node instanceof ContractDefinition) {
      checkFieldAndVFieldMatch(node, 'scope', 'vScope');
      checkVFieldCtx(node, 'vScope', ctx);

      if (node.vScope !== node.parent) {
        throw new InsaneASTError(
          `Contract ${pp(node)} vScope ${pp(node.vScope)} and parent ${pp(node.parent)} differ`,
        );
      }

      checkFieldAndVFieldMatch(node, 'linearizedBaseContracts', 'vLinearizedBaseContracts');
      checkVFieldCtx(node, 'vLinearizedBaseContracts', ctx);

      checkFieldAndVFieldMatch(node, 'usedErrors', 'vUsedErrors');
      checkVFieldCtx(node, 'vUsedErrors', ctx);

      const fields: Array<keyof ContractDefinition> = [
        'documentation',
        'vInheritanceSpecifiers',
        'vStateVariables',
        'vModifiers',
        'vErrors',
        'vEvents',
        'vFunctions',
        'vUsingForDirectives',
        'vStructs',
        'vEnums',
        'vUserDefinedValueTypes',
        'vConstructor',
      ];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof EnumDefinition) {
      checkVFieldCtx(node, 'vScope', ctx);

      checkDirectChildren(node, 'vMembers');
    } else if (node instanceof ErrorDefinition) {
      checkVFieldCtx(node, 'vScope', ctx);

      const fields: Array<keyof ErrorDefinition> = ['vParameters'];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof EventDefinition) {
      checkVFieldCtx(node, 'vScope', ctx);

      const fields: Array<keyof EventDefinition> = ['vParameters'];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof FunctionDefinition) {
      checkFieldAndVFieldMatch(node, 'scope', 'vScope');
      checkVFieldCtx(node, 'vScope', ctx);

      const fields: Array<keyof FunctionDefinition> = [
        'vParameters',
        'vOverrideSpecifier',
        'vModifiers',
        'vReturnParameters',
        'vBody',
      ];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof ModifierDefinition) {
      checkVFieldCtx(node, 'vScope', ctx);

      const fields: Array<keyof ModifierDefinition> = [
        'vParameters',
        'vOverrideSpecifier',
        'vBody',
      ];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof StructDefinition) {
      checkFieldAndVFieldMatch(node, 'scope', 'vScope');
      checkVFieldCtx(node, 'vScope', ctx);

      checkDirectChildren(node, 'vMembers');
    } else if (node instanceof UserDefinedValueTypeDefinition) {
      checkVFieldCtx(node, 'vScope', ctx);
      checkVFieldCtx(node, 'underlyingType', ctx);

      checkDirectChildren(node, 'underlyingType');
    } else if (node instanceof VariableDeclaration) {
      checkFieldAndVFieldMatch(node, 'scope', 'vScope');
      checkVFieldCtx(node, 'vScope', ctx);

      const fields: Array<keyof VariableDeclaration> = ['vType', 'vOverrideSpecifier', 'vValue'];

      if (node.documentation instanceof StructuredDocumentation) {
        checkVFieldCtx(node, 'documentation', ctx);

        fields.push('documentation');
      }

      checkDirectChildren(node, ...fields);
    } else if (node instanceof Block || node instanceof UncheckedBlock) {
      checkDirectChildren(node, 'vStatements');
    } else if (node instanceof DoWhileStatement) {
      checkDirectChildren(node, 'vCondition', 'vBody');
    } else if (node instanceof EmitStatement) {
      checkDirectChildren(node, 'vEventCall');
    } else if (node instanceof RevertStatement) {
      checkDirectChildren(node, 'errorCall');
    } else if (node instanceof ExpressionStatement) {
      checkDirectChildren(node, 'vExpression');
    } else if (node instanceof ForStatement) {
      checkDirectChildren(
        node,
        'vInitializationExpression',
        'vLoopExpression',
        'vCondition',
        'vBody',
      );
    } else if (node instanceof IfStatement) {
      checkVFieldCtx(node, 'vCondition', ctx);
      checkVFieldCtx(node, 'vTrueBody', ctx);

      if (node.vFalseBody !== undefined) {
        checkVFieldCtx(node, 'vFalseBody', ctx);
      }

      checkDirectChildren(node, 'vCondition', 'vTrueBody', 'vFalseBody');
    } else if (node instanceof Return) {
      // return functionReturnParameters member is undefined for returns in modifiers
      if (node.functionReturnParameters !== undefined) {
        checkFieldAndVFieldMatch(node, 'functionReturnParameters', 'vFunctionReturnParameters');
        checkVFieldCtx(node, 'vFunctionReturnParameters', ctx);
      }
      checkDirectChildren(node, 'vExpression');
    } else if (node instanceof TryCatchClause) {
      checkDirectChildren(node, 'vParameters', 'vBlock');
    } else if (node instanceof TryStatement) {
      checkDirectChildren(node, 'vExternalCall', 'vClauses');
    } else if (node instanceof VariableDeclarationStatement) {
      checkDirectChildren(node, 'vDeclarations', 'vInitialValue');
    } else if (node instanceof WhileStatement) {
      checkDirectChildren(node, 'vCondition', 'vBody');
    } else if (node instanceof ArrayTypeName) {
      checkDirectChildren(node, 'vBaseType', 'vLength');
    } else if (node instanceof FunctionTypeName) {
      checkDirectChildren(node, 'vParameterTypes', 'vReturnParameterTypes');
    } else if (node instanceof Mapping) {
      checkDirectChildren(node, 'vKeyType', 'vValueType');
    } else if (node instanceof UserDefinedTypeName) {
      checkFieldAndVFieldMatch(node, 'referencedDeclaration', 'vReferencedDeclaration');
      checkVFieldCtx(node, 'vReferencedDeclaration', ctx);
      checkDirectChildren(node, 'path');
    } else if (node instanceof Assignment) {
      checkDirectChildren(node, 'vLeftHandSide', 'vRightHandSide');
    } else if (node instanceof BinaryOperation) {
      checkDirectChildren(node, 'vLeftExpression', 'vRightExpression');
    } else if (node instanceof Conditional) {
      checkDirectChildren(node, 'vCondition', 'vTrueExpression', 'vFalseExpression');
    } else if (node instanceof ElementaryTypeNameExpression) {
      if (!(typeof node.typeName === 'string')) {
        checkDirectChildren(node, 'typeName');
      }
    } else if (node instanceof FunctionCall) {
      checkDirectChildren(node, 'vExpression', 'vArguments');
    } else if (node instanceof FunctionCallOptions) {
      checkDirectChildren(node, 'vExpression', 'vOptionsMap');
    } else if (node instanceof Identifier || node instanceof IdentifierPath) {
      if (node.referencedDeclaration !== null && node.vReferencedDeclaration !== undefined) {
        checkFieldAndVFieldMatch(node, 'referencedDeclaration', 'vReferencedDeclaration');
        checkVFieldCtx(node, 'vReferencedDeclaration', ctx);
      }
    } else if (node instanceof IndexAccess) {
      checkDirectChildren(node, 'vBaseExpression', 'vIndexExpression');
    } else if (node instanceof IndexRangeAccess) {
      checkDirectChildren(node, 'vBaseExpression', 'vStartExpression', 'vEndExpression');
    } else if (node instanceof MemberAccess) {
      if (node.referencedDeclaration !== null && node.vReferencedDeclaration !== undefined) {
        checkFieldAndVFieldMatch(node, 'referencedDeclaration', 'vReferencedDeclaration');
        checkVFieldCtx(node, 'vReferencedDeclaration', ctx);
      }

      checkDirectChildren(node, 'vExpression');
    } else if (node instanceof NewExpression) {
      checkDirectChildren(node, 'vTypeName');
    } else if (node instanceof TupleExpression) {
      checkDirectChildren(node, 'vOriginalComponents', 'vComponents');
    } else if (node instanceof UnaryOperation) {
      checkVFieldCtx(node, 'vSubExpression', ctx);
      checkDirectChildren(node, 'vSubExpression');
    } else if (node instanceof CairoAssert) {
      checkDirectChildren(node, 'vExpression');
    } else {
      throw new Error(`Unknown ASTNode type ${node.constructor.name}`);
    }
  }
}

function checkContextsDefined(node: ASTNode) {
  const context = node.context;
  if (context === undefined) {
    throw new InsaneASTError(`${node.type} ${node.id} has no context`);
  }
  node.children.forEach((child) => checkContextsDefined(child));
}

function checkIdNonNegative(node: ASTNode) {
  if (node.id < 0) throw new InsaneASTError(`${node.type} ${node.id} has invalid id`);
  node.children.forEach((child) => checkIdNonNegative(child));
}

function checkOnlyConstructorsMarkedAsConstructors(nodes: FunctionDefinition[]) {
  nodes.forEach((func) => {
    if ((func.kind === FunctionKind.Constructor) !== func.isConstructor)
      throw new InsaneASTError(
        `${printNode(func)} ${func.name} is incorrectly marked as ${
          func.isConstructor ? '' : 'not '
        } a constructor`,
      );
  });
}

// Check that functions of kind: constructor, receive and fallback are nameless
function checkEmptyNamesForNamelessFunctions(nodes: FunctionDefinition[]) {
  nodes.forEach((func) => {
    if (func.name === '' && !isNameless(func)) {
      throw new InsaneASTError(
        `${printNode(func)} has an empty name but it's kind: ${
          func.kind
        } is different than constructor, fallback or receive`,
      );
    }
    if (func.name !== '' && isNameless(func)) {
      throw new InsaneASTError(
        `${printNode(func)} of kind ${func.kind} has a non-empty name: ${func.name}`,
      );
    }
  });
}

/**
 * Check that a single SourceUnit has a sane structure. This checks that:
 *  - All reachable nodes belong to the same context, have their parent/sibling set correctly.
 *  - All number id properties of nodes point to a node in the same context.
 *  - When a number property (e.g. `scope`) has a corresponding `v` prefixed property (e.g. `vScope`)
 *    check that the number proerty corresponds to the id of the `v` prefixed property.
 *  - Most 'v' properties point to direct children of a node.
 *
 * NOTE: While this code can be slightly slow, its meant to be used mostly in testing so its
 * not performance critical.
 */
export function isSane(ast: AST, devMode: boolean): boolean {
  IdChecker.map(ast);
  if (devMode) {
    NodeTypeResolutionChecker.map(ast);
    ParameterScopeChecker.map(ast);
    return ast.roots.every((root) => {
      try {
        checkSane(root, ast.context);
        checkContextsDefined(root);
        checkIdNonNegative(root);
        const functionDefinitions = root.getChildrenByType(FunctionDefinition);
        checkOnlyConstructorsMarkedAsConstructors(functionDefinitions);
        checkEmptyNamesForNamelessFunctions(functionDefinitions);
      } catch (e) {
        if (e instanceof InsaneASTError) {
          console.error(e);

          return false;
        }

        throw e;
      }
      return true;
    });
  }
  return true;
}

class NodeTypeResolutionChecker extends ASTMapper {
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node
      .getChildren()
      .filter(
        (child): child is Expression | VariableDeclaration =>
          child instanceof Expression || child instanceof VariableDeclaration,
      )
      .filter((child) => child.parent !== undefined && !(child.parent instanceof ImportDirective))
      .forEach((child) => safeGetNodeType(child, ast.compilerVersion));
  }
}

class ParameterScopeChecker extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, _ast: AST): void {
    [...node.vParameters.vParameters, ...node.vReturnParameters.vParameters].forEach((decl) => {
      if (decl.scope !== node.id) {
        throw new InsaneASTError(
          `${printNode(decl)} in ${printNode(node)} has scope ${decl.scope}, expected ${node.id}`,
        );
      }
    });
  }
}

/* The pass asserts that all id based references refer 
   to nodes that are children of the roots of the AST.
*/

class IdChecker extends ASTMapper {
  static Ids = new Set();

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.scope) || !ast.context.map.has(node.scope),
      `${printNode(node)} has invalid scope`,
    );
  }

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.scope) || !ast.context.map.has(node.scope),
      `${printNode(node)} has invalid scope`,
    );
  }

  visitImportDirective(node: ImportDirective, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.scope) || !ast.context.map.has(node.scope),
      `${printNode(node)} has invalid scope`,
    );
  }

  visitStructDefinition(node: StructDefinition, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.scope) || !ast.context.map.has(node.scope),
      `${printNode(node)} has invalid scope`,
    );
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.scope) || !ast.context.map.has(node.scope),
      `${printNode(node)} has invalid scope`,
    );
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.referencedDeclaration) ||
        !ast.context.map.has(node.referencedDeclaration),
      `${printNode(node)} has invalid referenced declaration`,
    );
  }

  visitIdentifierPath(node: IdentifierPath, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.referencedDeclaration) ||
        !ast.context.map.has(node.referencedDeclaration),
      `${printNode(node)} has invalid referenced declaration`,
    );
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.referencedDeclaration) ||
        !ast.context.map.has(node.referencedDeclaration),
      `${printNode(node)} has invalid referenced declaration`,
    );
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    assert(
      IdChecker.Ids.has(node.referencedDeclaration) ||
        !ast.context.map.has(node.referencedDeclaration),
      `${printNode(node)} has invalid referenced declaration`,
    );
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      root.getChildren(true).forEach((node) => {
        this.Ids.add(node.id);
      });
    });

    ast.roots.forEach((root) => {
      root.getChildren(true).forEach((node) => {
        const pass = new this();
        if (node instanceof ContractDefinition) {
          pass.visitContractDefinition(node, ast);
        } else if (node instanceof FunctionDefinition) {
          pass.visitFunctionDefinition(node, ast);
        } else if (node instanceof ImportDirective) {
          pass.visitImportDirective(node, ast);
        } else if (node instanceof StructDefinition) {
          pass.visitStructDefinition(node, ast);
        } else if (node instanceof VariableDeclaration) {
          pass.visitVariableDeclaration(node, ast);
        } else if (node instanceof Identifier) {
          pass.visitIdentifier(node, ast);
        } else if (node instanceof IdentifierPath) {
          pass.visitIdentifierPath(node, ast);
        } else if (node instanceof MemberAccess) {
          pass.visitMemberAccess(node, ast);
        } else if (node instanceof UserDefinedTypeName) {
          pass.visitUserDefinedTypeName(node, ast);
        }
      });
    });
    return ast;
  }
}
