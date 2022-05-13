import {
  ContractDefinition,
  EventDefinition,
  FunctionDefinition,
  ModifierDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { TranspileFailedError } from '../../utils/errors';
import { solveConstructorInheritance } from './constructorInheritance';
import { addEventDefintion } from './eventInheritance';
import { addNonoverridenPublicFunctions, addPrivateSuperFunctions } from './functionInheritance';
import { addNonOverridenModifiers } from './modifiersInheritance';
import { addStorageVariables } from './storageVariablesInheritance';
import { addStructDefinition } from './structInheritance';
import {
  getBaseContracts,
  removeBaseContractDependence,
  updateReferencedDeclarations,
  updateReferenceEmitStatemets,
} from './utils';

export class InheritanceInliner extends ASTMapper {
  counter = 0;

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    if (node.vLinearizedBaseContracts.length < 2) {
      // LinearizedBaseContracts includes self as the first element,
      // and we only care about those which inherit from something else
      return;
    }

    const functionRemapping: Map<number, FunctionDefinition> = new Map();
    const variableRemapping: Map<number, VariableDeclaration> = new Map();
    const modifierRemapping: Map<number, ModifierDefinition> = new Map();
    const eventRemapping: Map<number, EventDefinition> = new Map();

    solveConstructorInheritance(node, ast, this.generateIndex.bind(this));
    addPrivateSuperFunctions(node, functionRemapping, ast);
    addNonoverridenPublicFunctions(node, functionRemapping, ast);
    addStorageVariables(node, variableRemapping, ast);
    addNonOverridenModifiers(node, modifierRemapping, ast);
    addEventDefintion(node, eventRemapping, ast);
    // Structs from parent classes are added but references inside the contract definition
    // are not updated since this is not enough.
    // The typeStrings of everything that reference an inherited struct must be updated as
    // well because two equally defined structs in different contracts are considered different
    // types. Also the typeString of anything that references something which reference an
    // inherited struct must be updated. (e.g. An Identifier which references a VariableDeclaration
    // which references an inherited struct)
    // By just adding the structs this issues are avoided and valid cairo code is produced.
    addStructDefinition(node, ast);

    updateReferencedDeclarations(node, functionRemapping, ast);
    updateReferencedDeclarations(node, variableRemapping, ast);
    updateReferencedDeclarations(node, modifierRemapping, ast);
    updateReferenceEmitStatemets(node, eventRemapping, ast);

    removeBaseContractDependence(node);

    ast.setContextRecursive(node);

    this.commonVisit(node, ast);
  }

  static map(ast: AST): AST {
    // The inheritance inliner needs to process subclasses before their parents
    // If a base contract is processed before a derived one then the methods added
    // to the base will get copied into the derived leading to unnecessary duplication
    let contractsToProcess = ast.roots.flatMap((root) => root.vContracts);
    while (contractsToProcess.length > 0) {
      // Find contracts that no other contract inherits from
      const mostDerivedContracts = contractsToProcess.filter(
        (derivedContract) =>
          !contractsToProcess.some((otherContract) =>
            getBaseContracts(otherContract).includes(derivedContract),
          ),
      );
      if (mostDerivedContracts.length === 0 && contractsToProcess.length > 0) {
        throw new TranspileFailedError('Unable to serialise contracts');
      }
      contractsToProcess = contractsToProcess.filter((c) => !mostDerivedContracts.includes(c));
      mostDerivedContracts.forEach((contract) => {
        const pass = new this();
        pass.dispatchVisit(contract, ast);
      });
    }

    return ast;
  }

  generateIndex() {
    return this.counter++;
  }
}
