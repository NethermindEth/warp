import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
  FunctionKind,
  Identifier,
  SourceUnit,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { CairoFunctionDefinition } from '../ast/cairoNodes/cairoFunctionDefinition';
import { CairoContract } from '../ast/cairoNodes';
// import { formatPath } from '../utils/utils';

function genContractInterface(
  contract: CairoContract,
  sourceUnit: SourceUnit,
  ast: AST,
): ContractDefinition {
  const contractInterface = new CairoContract(
    ast.reserveId(),
    '',
    `${contract.name}@interface`,
    sourceUnit.id,
    ContractKind.Interface,
    contract.abstract,
    false,
    contract.linearizedBaseContracts,
    contract.usedErrors,
    contract.storageAllocations,
    contract.usedStorage,
  );

  contract.vFunctions.forEach((func) => {
    // return if func is constructor
    if (func.kind === FunctionKind.Constructor) return;
    assert(
      func instanceof CairoFunctionDefinition,
      `${func.name} should be a CairoFunctionDefinition`,
    );
    const funcClone = new CairoFunctionDefinition(
      ast.reserveId(),
      '',
      contractInterface.id,
      func.kind,
      func.name,
      func.virtual,
      func.visibility,
      func.stateMutability,
      func.isConstructor,
      func.vParameters,
      func.vReturnParameters,
      func.vModifiers,
      new Set(),
      func.isStub,
    );
    contractInterface.appendChild(funcClone);
    ast.registerChild(funcClone, contractInterface);
  });
  sourceUnit.appendChild(contractInterface);
  ast.registerChild(contractInterface, sourceUnit);
  return contractInterface;
}

export class ExternalContractInterfaceInserter extends ASTMapper {
  /*
    This is a sort of pass which goes through evrey variable declaration
    and identifies the contracts that are used in the variable declaration.
  */

  constructor(private contractInterfaces: Map<number, ContractDefinition>) {
    super();
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    const declarationSourceUnit = declaration.getClosestParentByType(SourceUnit);
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return;

    if (declaration instanceof ContractDefinition) {
      // ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
      assert(
        declaration instanceof CairoContract,
        "Identifier's declaration should be a CairoContract",
      );
      if (declaration.kind === ContractKind.Library) return;
      if (this.contractInterfaces.has(declaration.id)) return;
      this.contractInterfaces.set(
        declaration.id,
        genContractInterface(declaration, sourceUnit, ast),
      );
    }
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const varType = node.vType;

    if (!varType) return;

    if (
      varType instanceof UserDefinedTypeName &&
      varType.vReferencedDeclaration instanceof ContractDefinition
    ) {
      const contract = varType.vReferencedDeclaration;
      assert(contract instanceof CairoContract, 'Reference Contract should be a CairoContract');
      const contractSourceUnit = contract.getClosestParentByType(SourceUnit);
      const sourceUnit = node.getClosestParentByType(SourceUnit);

      assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
      if (contractSourceUnit === undefined) return;

      // ast.registerImport(node, formatPath(contractSourceUnit.absolutePath), contract.name);

      /*
        If variable declaration uses the contract Defintion as a refrence, then,
        In order to call the methods from another contract, 
        define an interface by copying the declarations of the 
        external functions.
      */
      if (contract.kind === ContractKind.Library) return;
      if (this.contractInterfaces.has(contract.id)) return;
      this.contractInterfaces.set(contract.id, genContractInterface(contract, sourceUnit, ast));
    }
  }
}
