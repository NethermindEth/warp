import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
  FunctionKind,
  Identifier,
  MemberAccess,
  SourceUnit,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { TranspileFailedError } from '../../utils/errors';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../../utils/utils';

export class ExternalContractInterfaceInserter extends ASTMapper {
  /*
    This is a sort of pass which goes through every variable declaration/function call/member access
    and identifies the external contracts that are being used. It then creates a new contract interface
    for each of those contracts and inserts it into the AST.
  */

  constructor(private contractInterfaces: Map<number, ContractDefinition>) {
    super();
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    if (declaration instanceof ContractDefinition) {
      importExternalContract(
        declaration,
        node.getClosestParentByType(SourceUnit),
        this.contractInterfaces,
        ast,
      );
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const nodeType = safeGetNodeType(node.vExpression, ast.inference);
    if (nodeType instanceof UserDefinedType && nodeType.definition instanceof ContractDefinition) {
      // nodeType.definition will get the old ContractDefinition, see the note
      // in storageAllocator on hotfixing getNodeType
      // To fix this we lookup the contract definition id in the context
      if (node.context === undefined)
        throw new TranspileFailedError('Node context should not be undefined');
      importExternalContract(
        node.context.locate(nodeType.definition.id) as ContractDefinition,
        node.getClosestParentByType(SourceUnit),
        this.contractInterfaces,
        ast,
      );
    }
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const varType = node.vType;

    if (!varType) return;

    if (
      varType instanceof UserDefinedTypeName &&
      varType.vReferencedDeclaration instanceof ContractDefinition
    ) {
      importExternalContract(
        varType.vReferencedDeclaration,
        node.getClosestParentByType(SourceUnit),
        this.contractInterfaces,
        ast,
      );
    }
  }
}

function importExternalContract(
  contract: ContractDefinition,
  sourceUnit: SourceUnit | undefined,
  contractInterfaces: Map<number, ContractDefinition>,
  ast: AST,
) {
  assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');

  if (contract.kind === ContractKind.Library) return;
  if (contractInterfaces.has(contract.id)) return;
  contractInterfaces.set(contract.id, genContractInterface(contract, sourceUnit, ast));
}

export function getTemporaryInterfaceName(contractName: string): string {
  return `${contractName}@interface`;
}

export function genContractInterface(
  contract: ContractDefinition,
  sourceUnit: SourceUnit,
  ast: AST,
): ContractDefinition {
  const contractId = ast.reserveId();
  const contractInterface = new CairoContract(
    contractId,
    '',
    // `@interface` is a workaround to avoid the conflict with
    // the existing contract with the same name
    getTemporaryInterfaceName(contract.name),
    sourceUnit.id,
    ContractKind.Interface,
    contract.abstract,
    false, // fullyImplemented
    contract.linearizedBaseContracts,
    contract.usedErrors,
    new Map(),
    new Map(),
    0,
    0,
  );

  contract.vFunctions
    .filter((func) => func.kind !== FunctionKind.Constructor && isExternallyVisible(func))
    .forEach((func) => {
      const funcBody = func.vBody;
      func.vBody = undefined;
      const funcClone = cloneASTNode(func, ast);

      funcClone.scope = contractId;
      funcClone.implemented = false;
      func.vBody = funcBody;
      contractInterface.appendChild(funcClone);
      ast.registerChild(funcClone, contractInterface);
    });
  sourceUnit.appendChild(contractInterface);
  ast.registerChild(contractInterface, sourceUnit);
  return contractInterface;
}
