import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  EmitStatement,
  EventDefinition,
  FunctionDefinition,
  Identifier,
  IdentifierPath,
  InheritanceSpecifier,
  MemberAccess,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { createCallToEvent } from '../../utils/functionGeneration';

export function getBaseContracts(node: ContractDefinition): ContractDefinition[] {
  return node.vLinearizedBaseContracts.slice(1);
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

export function removeBaseContractDependence(node: ContractDefinition): void {
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
