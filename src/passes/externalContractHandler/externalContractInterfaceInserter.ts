import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  getNodeType,
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

function genContractInterface(
  contract: ContractDefinition,
  sourceUnit: SourceUnit,
  ast: AST,
): ContractDefinition {
  const contractId = ast.reserveId();
  const contractInterface = new CairoContract(
    contractId,
    '',
    `${contract.name}@interface`,
    sourceUnit.id,
    ContractKind.Interface,
    contract.abstract,
    false,
    contract.linearizedBaseContracts,
    contract.usedErrors,
    new Map(),
    0,
  );

  contract.vFunctions.forEach((func) => {
    // return if func is constructor
    if (func.kind === FunctionKind.Constructor) return;

    const funcClone = new FunctionDefinition(
      ast.reserveId(),
      '',
      contractInterface.id,
      func.kind,
      func.name,
      func.virtual,
      func.visibility,
      func.stateMutability,
      func.isConstructor,
      cloneASTNode(func.vParameters, ast),
      cloneASTNode(func.vReturnParameters, ast),
      func.vModifiers,
    );
    contractInterface.appendChild(funcClone);
    ast.registerChild(funcClone, contractInterface);
  });
  sourceUnit.appendChild(contractInterface);
  ast.registerChild(contractInterface, sourceUnit);
  return contractInterface;
}

function importExternalContract(
  contract: ContractDefinition,
  sourceUnit: SourceUnit | undefined,
  contractInterfaces: Map<number, ContractDefinition>,
  ast: AST,
) {
  const contractSourceUnit = contract.getClosestParentByType(SourceUnit);

  assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');

  if (contractSourceUnit === undefined || sourceUnit === contractSourceUnit) return;

  if (contract.kind === ContractKind.Library) return;
  if (contractInterfaces.has(contract.id)) return;
  contractInterfaces.set(contract.id, genContractInterface(contract, sourceUnit, ast));
}

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

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const nodeType = getNodeType(node, ast.compilerVersion);
    if (nodeType instanceof UserDefinedType && nodeType.definition instanceof ContractDefinition) {
      importExternalContract(
        nodeType.definition,
        node.getClosestParentByType(SourceUnit),
        this.contractInterfaces,
        ast,
      );
    }
    this.commonVisit(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const nodeType = getNodeType(node, ast.compilerVersion);
    if (nodeType instanceof UserDefinedType && nodeType.definition instanceof ContractDefinition) {
      importExternalContract(
        nodeType.definition,
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
