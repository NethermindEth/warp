import {
  ContractDefinition,
  FunctionDefinition,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { TranspileFailedError } from '../../utils/errors';
import { solveConstructorInheritance } from './constructorInheritance';
import { addNonoverridenPublicFunctions, addPrivateSuperFunctions } from './functionInheritance';
import { addNonOverridenModifiers } from './modifiersInheritance';
import { addStorageVariables } from './storageVariablesInheritance';
import { getBaseContracts, updateReferencedDeclarations } from './utils';

export class InheritanceInliner extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.vLinearizedBaseContracts.length < 2) {
      // LinearizedBaseContracts includes self as the first element,
      // and we only care about those which inherit from something else
      return;
    }

    const functionRemapping: Map<number, FunctionDefinition> = new Map();
    const variableRemapping: Map<number, VariableDeclaration> = new Map();
    const modifierRemapping: Map<number, ModifierDefinition> = new Map();

    solveConstructorInheritance(node, ast);
    addPrivateSuperFunctions(node, functionRemapping, ast);
    addNonoverridenPublicFunctions(node, functionRemapping, ast);
    addStorageVariables(node, variableRemapping, ast);
    addNonOverridenModifiers(node, modifierRemapping, ast);

    updateReferencedDeclarations(node, functionRemapping, ast);
    updateReferencedDeclarations(node, variableRemapping, ast);
    updateReferencedDeclarations(node, modifierRemapping, ast);
    this.commonVisit(node, ast);
  }

  static map(ast: AST): AST {
    let contracts = ast.roots.flatMap((root) => root.vContracts);
    while (contracts.length > 0) {
      const mostDerivedContracts = contracts.filter(
        (derivedContract) =>
          !contracts.some((otherContract) =>
            getBaseContracts(otherContract).includes(derivedContract),
          ),
      );
      if (mostDerivedContracts.length === 0 && contracts.length > 0) {
        throw new TranspileFailedError('Unable to serialise contracts');
      }
      contracts = contracts.filter((c) => !mostDerivedContracts.includes(c));
      mostDerivedContracts.forEach((contract) => {
        const pass = new this();
        pass.visitContractDefinition(contract, ast);
      });
    }
    return ast;
  }
}
