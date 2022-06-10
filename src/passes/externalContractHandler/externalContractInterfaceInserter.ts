import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
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
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
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
    const nodeType = getNodeType(node.vExpression, ast.compilerVersion);
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

function genContractInterface(
  contract: ContractDefinition,
  sourceUnit: SourceUnit,
  ast: AST,
): ContractDefinition {
  const contractId = ast.reserveId();
  const contractInterface = new ContractDefinition(
    contractId,
    '',
    // `@interface` is a workaround to avoid the conflict with
    // the existing contract with the same name
    `${contract.name}@interface`,
    sourceUnit.id,
    ContractKind.Interface,
    contract.abstract,
    false,
    contract.linearizedBaseContracts,
    contract.usedErrors,
  );

  contract.vFunctions
    .filter((func) => func.kind !== FunctionKind.Constructor && isExternallyVisible(func))
    .forEach((func) => {
      const funcBody = func.vBody;
      func.vBody = undefined;
      const funcClone = cloneASTNode(func, ast);

      // TODO check whether it's worth detaching all bodies in the contract's functions,
      // cloning the entire contract, then reattaching (can anything in the function but
      // not the body reference the containing contract other than .scope?)
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
