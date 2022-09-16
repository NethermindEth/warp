import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

import { ContractKind, Identifier, MemberAccess } from 'solc-typed-ast';
import { CairoContract, CairoFunctionDefinition } from '../ast/cairoNodes';
import { isExternallyVisible } from '../utils/utils';
import { getContractTypeString } from '../utils/getTypeString';

/**
 * This pass replaces all identifier whose refrenced declaration defined outside of the function body,
 * by a member access with the expression as an identifier refrenced to it's parent contract.
 * For e.g.
 *        contract A {
 *           uint public a;
 *           function f() public view {
 *              uint b = a;   // would be replace with A.a
 *              g();          // would be replaced with A.g()
 *           }
 *        }
 *     -- function f to be written outside of namespace A (see `cairoWriter.ts: 519`) --
 * This is done to separate the external functions outside of the namspace
 * so that there would be abi's generated for them. see `cairoWriter.ts: 519`.
 * from cairo v0.10.0, for the functions lying inside the cairo namespace , there would be
 * no abi generated for them.
 */

export class ReplaceIdentifierContractMemberAccess extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Sa', // Pass uses CairoFunctionDefintion and CairoContract
    ]);
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
