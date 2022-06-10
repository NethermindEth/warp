import assert from 'assert';
import {
  ASTNode,
  EmitStatement,
  EventDefinition,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  IdentifierPath,
  InheritanceSpecifier,
  MemberAccess,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { TranspileFailedError } from '../../utils/errors';
import { createCallToEvent } from '../../utils/functionGeneration';
import { isExternalCall } from '../../utils/utils';

export function getBaseContracts(node: CairoContract): CairoContract[] {
  return node.vLinearizedBaseContracts.slice(1).map((cc) => {
    if (!(cc instanceof CairoContract)) {
      throw new TranspileFailedError(
        `Expected all contracts to be cairo contracts prior to inlining`,
      );
    }
    return cc;
  });
}

// Usually overriders remapping should be used to update references, but when the
// contract is specified (through MemberAccess or IdentifierPath), the cloned member
// of that contract is the one that should be used, so the simple remapping is used
// instead.
export function updateReferencedDeclarations(
  node: ASTNode,
  idRemapping: Map<number, VariableDeclaration | FunctionDefinition | ModifierDefinition>,
  idRemappingOverriders: Map<number, VariableDeclaration | FunctionDefinition | ModifierDefinition>,
  ast: AST,
) {
  node.walk((node) => {
    if (node instanceof Identifier) {
      const remapping = idRemappingOverriders.get(node.referencedDeclaration);
      if (remapping !== undefined) {
        node.referencedDeclaration = remapping.id;
        node.name = remapping.name;
      }
    } else if (node instanceof IdentifierPath) {
      const remapping = isSpecificAccess(node)
        ? idRemapping.get(node.referencedDeclaration)
        : idRemappingOverriders.get(node.referencedDeclaration);
      if (remapping !== undefined) {
        node.referencedDeclaration = remapping.id;
        node.name = remapping.name;
      }
    } else if (node instanceof MemberAccess) {
      if (node.parent instanceof FunctionCall && isExternalCall(node.parent)) return;
      const remapping = idRemapping.get(node.referencedDeclaration);
      if (remapping !== undefined) {
        ast.replaceNode(
          node,
          new Identifier(
            ast.reserveId(),
            node.src,
            node.typeString,
            remapping.name,
            remapping.id,
            node.raw,
          ),
        );
      }
    }
  });
}

export function updateReferenceEmitStatemets(
  node: ASTNode,
  idRemapping: Map<number, EventDefinition>,
  ast: AST,
) {
  node.walk((node) => {
    if (node instanceof EmitStatement) {
      const oldEventDef = node.vEventCall.vReferencedDeclaration;
      assert(oldEventDef instanceof EventDefinition);
      const newEventDef = idRemapping.get(oldEventDef.id);
      if (newEventDef !== undefined) {
        const replaceNode = new EmitStatement(
          ast.reserveId(),
          '',
          createCallToEvent(
            newEventDef,
            node.vEventCall.vExpression.typeString,
            node.vEventCall.vArguments,
            ast,
          ),
        );
        ast.replaceNode(node, replaceNode);
      }
    }
  });
}

export function removeBaseContractDependence(node: CairoContract): void {
  const toRemove = node.children.filter(
    (child): child is InheritanceSpecifier => child instanceof InheritanceSpecifier,
  );
  toRemove.forEach((inheritanceSpecifier) => node.removeChild(inheritanceSpecifier));
}

// IdentifierPath doesn't make distinctions between calling function f() or A.f()
// The only difference is the string of the name ('f' or 'A.f' respectively), so
// the string is parsed in order to obtain whether the contract is being specified.
function isSpecificAccess(node: IdentifierPath): boolean {
  const name = node.name.split('.');
  return name.length > 1;
}

// Check whether there is a statement in the body of the node that is a member access
// to super. If that is the case, it needs to fix the reference of that member access
// to the correct function in the linearized order of contract
export function fixSuperReference(
  node: ASTNode,
  base: CairoContract,
  contract: CairoContract,
): void {
  node.walk((n) => {
    if (n instanceof MemberAccess && isSuperAccess(n)) {
      const superFunc = findSuperReferenceNode(n.memberName, base, contract);
      n.referencedDeclaration = superFunc.id;
    }
  });
}

// TODO: Investigate if there are other ways to get super as the MemberAccess expression
function isSuperAccess(n: MemberAccess): boolean {
  const expr = n.vExpression;
  return expr instanceof Identifier && expr.name === 'super';
}

// In the `base` contract there is a super member access, which points to the corresponding
// function in the linearized order of contracts of `base`. However, it should be pointing
// to this function in the linearized order of contracts of `contract`; so the contracts
// after `base` should be reviewed in this order looking for the correct function to fix
// the reference
function findSuperReferenceNode(
  funcName: string,
  base: CairoContract,
  node: CairoContract,
): FunctionDefinition {
  let contractFound = false;
  for (const contract of getBaseContracts(node)) {
    if (contractFound) {
      const functions = contract
        .getChildren()
        .filter(
          (declaration): declaration is FunctionDefinition =>
            declaration instanceof FunctionDefinition && declaration.name === funcName,
        );
      assert(
        functions.length <= 1,
        `Function ${funcName} is defined multiple times in the same contract`,
      );
      if (functions.length == 1) return functions[0];
    } else {
      contractFound = contract.id === base.id;
    }
  }
  throw new TranspileFailedError(`Function ${funcName} was not found in super contracts`);
}
