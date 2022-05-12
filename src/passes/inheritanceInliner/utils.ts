import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  FunctionDefinition,
  FunctionKind,
  Identifier,
  IdentifierPath,
  InheritanceSpecifier,
  MemberAccess,
  ModifierDefinition,
  StructDefinition,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { createCallToFunction, createStructConstructorCall } from '../../utils/functionGeneration';
import { getStructTypeString } from '../../utils/getTypeString';

export function getBaseContracts(node: ContractDefinition): ContractDefinition[] {
  return node.vLinearizedBaseContracts.slice(1);
}

export function updateReferencedDeclarations(
  node: ASTNode,
  idRemapping: Map<
    number,
    VariableDeclaration | FunctionDefinition | ModifierDefinition | StructDefinition
  >,
  ast: AST,
) {
  node.walk((node) => {
    if (node instanceof Identifier || node instanceof IdentifierPath) {
      const remapping = idRemapping.get(node.referencedDeclaration);
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
    /* else if (
      node instanceof FunctionCall &&
      node.kind === FunctionCallKind.StructConstructorCall &&
      node.vReferencedDeclaration !== undefined
    ) {
      const remapping = idRemapping.get(node.vReferencedDeclaration.id);
      if (remapping instanceof StructDefinition) {
        ast.replaceNode(node, createStructConstructorCall(remapping, node.vArguments, ast));
      }
    } else if (node instanceof UserDefinedTypeName) {
      const remapping = idRemapping.get(node.referencedDeclaration);
      if (remapping instanceof StructDefinition) {
        ast.replaceNode(
          node,
          new UserDefinedTypeName(
            ast.reserveId(),
            '',
            node.typeString, //`type(struct ${}.${remapping.name} storage poinetr)`,
            remapping.name,
            remapping.id,
            node.path,
          ),
        );
      }
    }*/
  });
}

export function removeBaseContractDependence(node: ContractDefinition): void {
  const toRemove = node.children.filter(
    (child): child is InheritanceSpecifier => child instanceof InheritanceSpecifier,
  );
  toRemove.forEach((inheritanceSpecifier) => node.removeChild(inheritanceSpecifier));
}
