import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  FunctionCall,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';

// Library calls in solidity are delegate calls
// i.e  libraries can be seen as implicit base contracts of the contracts that use them
// The pass converts external call to a library to an internal call to it
// by adding the referenced Libraries in the `FunctionCall` to the
// linearizedBaselist of a contract/Library.

export class ReferencedLibraries extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const librariesById = new Map<number, ContractDefinition>();
    if (node.vExpression instanceof MemberAccess) {
      //Collect all library nodes and their ids in the map 'contractDef'
      ast.context.map.forEach((astNode, id) => {
        if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
          librariesById.set(id, astNode);
        }
      });

      const calledDeclaration = node.vReferencedDeclaration;
      if (calledDeclaration === undefined) {
        return this.visitExpression(node, ast);
      }

      //Checks if the Function is a referenced Library functions,
      //if yes add it to the linearizedBaseContract list of parent ContractDefinition node
      //free functions calling library functions are not yet supported
      librariesById.forEach((library, _) => {
        if (library.vFunctions.some((libraryFunc) => libraryFunc.id === calledDeclaration.id)) {
          const parent = node.getClosestParentByType(CairoContract);
          if (parent === undefined) return;

          getLibrariesToInherit(library, librariesById).forEach((id) => {
            if (!parent.linearizedBaseContracts.includes(id)) {
              parent.linearizedBaseContracts.push(id);
            }
          });
        }
      });
    }
    this.commonVisit(node, ast);
  }
}

function getLibrariesToInherit(
  calledLibrary: ContractDefinition,
  librariesById: Map<number, ASTNode>,
): number[] {
  const ids: number[] = [calledLibrary.id];

  calledLibrary
    .getChildren()
    .filter((child) => child instanceof FunctionCall && child.vExpression instanceof MemberAccess)
    .forEach((functionCallInCalledLibrary) => {
      if (functionCallInCalledLibrary instanceof FunctionCall) {
        librariesById.forEach((library, libraryId) => {
          assert(functionCallInCalledLibrary.vExpression instanceof MemberAccess);
          const calledFuncId = functionCallInCalledLibrary.vExpression.referencedDeclaration;
          if (library.getChildren().some((node) => node.id === calledFuncId)) {
            ids.push(libraryId);
          }
        });
      }
    });

  return ids;
}
