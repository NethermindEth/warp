import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

import { ContractKind, Identifier, MemberAccess } from 'solc-typed-ast';
import { CairoContract, CairoFunctionDefinition } from '../ast/cairoNodes';
import { isExternallyVisible } from '../utils/utils';
import { getContractTypeString } from '../utils/getTypeString';

export class ReplaceIdentifierContractMemberAccess extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (isExternallyVisible(node)) {
      this.commonVisit(node, ast);
    }
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const referencedDeclarationNode = ast.context.locate(node.referencedDeclaration);
    const functionParent =
      referencedDeclarationNode.getClosestParentByType(CairoFunctionDefinition);
    const contractParent = referencedDeclarationNode.getClosestParentByType(CairoContract);
    if (
      referencedDeclarationNode instanceof CairoContract ||
      (contractParent instanceof CairoContract && contractParent.kind !== ContractKind.Contract)
    ) {
      return;
    }
    if (functionParent === undefined && contractParent !== undefined) {
      const memberAccess = new MemberAccess(
        ast.reserveId(),
        node.src,
        node.typeString,
        new Identifier(
          ast.reserveId(),
          '',
          getContractTypeString(contractParent),
          contractParent.name,
          contractParent.id,
        ),
        node.name,
        referencedDeclarationNode.id,
      );
      ast.replaceNode(node, memberAccess);
    }
  }
}
