import {
  ASTNode,
  ContractDefinition,
  FunctionDefinition,
  Identifier,
  IdentifierPath,
  MemberAccess,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';

export function getBaseContracts(node: ContractDefinition): ContractDefinition[] {
  return node.vLinearizedBaseContracts.slice(1);
}

export function updateReferencedDeclarations(
  node: ASTNode,
  idRemapping: Map<number, VariableDeclaration | FunctionDefinition | ModifierDefinition>,
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
  });
}
