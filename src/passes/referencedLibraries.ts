import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  FunctionCall,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

// Library calls in solidity are delegate calls
// i.e  libraries can be seen as implicit base contracts of the contracts that use them
// The pass converts external call to a library to an internal call to it
// by adding the referenced Libraries in the `FunctionCall` to the
// linearizedBaselist of a contract/Library.

export class ReferencedLibraries extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const contractDefLib = new Map<number, ASTNode>();
    if (node.vExpression instanceof MemberAccess) {
      //Collect all library nodes and their ids in the map 'contractDef'
      ast.context.map.forEach((astNode, key) => {
        if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library) {
          contractDefLib.set(key, astNode);
        }
      });

      const func_id = node.vExpression.referencedDeclaration;

      //Checks if the Function is a referenced Library functions,
      //if yes add it to the linearizedBaseContract list of parent ContractDefinition node
      //free functions calling library functions are not yet supported
      contractDefLib.forEach((astNode, _) => {
        assert(astNode instanceof ContractDefinition);

        if (astNode.vFunctions.some((func) => func.id === func_id)) {
          const parent = node.getClosestParentByType(ContractDefinition);
          const ids = getLibBase(astNode, contractDefLib);

          if (parent === undefined) return;

          ids.forEach((id) => {
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

function getLibBase(node: ContractDefinition, ContractDefLibs: Map<number, ASTNode>): number[] {
  const ids: number[] = [node.id];

  node.getChildren().forEach((child) => {
    if (child instanceof FunctionCall) {
      ContractDefLibs.forEach((astNode, id) => {
        assert(child.vExpression instanceof MemberAccess);
        const f_id = child.vExpression.referencedDeclaration;
        if (astNode.getChildren().some((node) => node.id === f_id)) {
          ids.push(id);
        }
      });
    }
  });

  return ids;
}
