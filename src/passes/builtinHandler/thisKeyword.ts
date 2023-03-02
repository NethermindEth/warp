import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  Identifier,
  MemberAccess,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { CairoContract } from '../../ast/cairoNodes';
import { typeNameFromTypeNode } from '../../utils/utils';
import {
  genContractInterface,
  getTemporaryInterfaceName,
} from '../externalContractHandler/externalContractInterfaceInserter';
import { assert } from 'console';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { starkwareSyscallPath } from '../../utils/importFuncGenerator';

export class ThisKeyword extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    if (node.name === 'this') {
      const replacementCall = createCallToFunction(
        ast.registerImport(
          node,
          starkwareSyscallPath(),
          'get_contract_address',
          [],
          [['address', typeNameFromTypeNode(safeGetNodeType(node, ast.inference), ast)]],
        ),
        [],
        ast,
      );
      ast.replaceNode(node, replacementCall);
    } else {
      return;
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression instanceof Identifier &&
      node.vExpression.vExpression.name === 'this'
    ) {
      const currentContract = node.getClosestParentByType(ContractDefinition);
      const sourceUnit = node.getClosestParentByType(SourceUnit);
      if (currentContract && sourceUnit) {
        // check if the interface has already been added
        const contractIndex = sourceUnit.vContracts.findIndex(
          (contract) => contract.name === getTemporaryInterfaceName(currentContract.name),
        );
        if (contractIndex === -1) {
          const insertedInterface = genContractInterface(currentContract, sourceUnit, ast);
          replaceInterfaceWithCairoContract(insertedInterface, ast);
        }
      }
    }
    this.commonVisit(node, ast);
  }
}

function replaceInterfaceWithCairoContract(node: ContractDefinition, ast: AST): void {
  assert(node.kind === ContractKind.Interface);
  const replacement = new CairoContract(
    node.id,
    node.src,
    node.name,
    node.scope,
    node.kind,
    node.abstract,
    node.fullyImplemented,
    node.linearizedBaseContracts,
    node.usedErrors,
    new Map(),
    new Map(),
    0,
    0,
    node.documentation,
    [...node.children],
    node.nameLocation,
    node.raw,
  );
  ast.replaceNode(node, replacement);
}
