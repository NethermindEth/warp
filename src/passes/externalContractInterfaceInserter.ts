import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
  FunctionDefinition,
  Identifier,
  SourceUnit,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
// import { formatPath } from '../utils/utils';

export class ExternalContractInterfaceInserter extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    const declarationSourceUnit = declaration.getClosestParentByType(SourceUnit);
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return;

    if (declaration instanceof ContractDefinition) {
      // ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
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
      console.log('Counting is up to you!!', node.name);
      const root = ast.getContainingRoot(node);
      const contractInterface = new ContractDefinition(
        ast.reserveId(),
        '',
        'ContractDefinition',
        `${contract.name}`,
        root.id,
        ContractKind.Interface,
        false,
        false,
        [],
        contract.usedErrors,
      );
      contract.vFunctions.forEach((func) => {
        const funcClone = new FunctionDefinition(
          ast.reserveId(),
          '',
          'FunctionDefinition',
          contract.id,
          func.kind,
          func.name,
          func.virtual,
          func.visibility,
          func.stateMutability,
          func.isConstructor,
          func.vParameters,
          func.vReturnParameters,
          func.vModifiers,
        );
        contractInterface.appendChild(funcClone);
        ast.registerChild(funcClone, contractInterface);
      });
      root.appendChild(contractInterface);
      ast.registerChild(contractInterface, root);
    }
  }
}
