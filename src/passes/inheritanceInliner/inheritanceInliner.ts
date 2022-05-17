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

    // The remapping structures are used to update the references to the new members
    // added in the current contract. The idea is to clone each member from the base
    // contracts and add it to the current contract, so the pair
    // (<old_member_id>, <cloned_member>) is stored in the map for each one of them.
    //
    // When there is an overriding function (or modifier) all references to the function
    // should point to this particular function and not the overriden implementation of it.
    // That is what the overriders maps are used for, they keep the reference to the
    // overriding member.
    // Nevertheless, the references to all the cloned members must also be kept, since they
    // can be called specifying the contract, even if they are being overriden somewhere
    // else down the line of inheritance.
    //
    // Example:
    //    abstract contract A {
    //      function f() public view virtual returns (uint256);

    //      function g() public view virtual returns (uint256) {
    //        return 10;
    //      }
    //    }

    //    abstract contract B is A {
    //      function g() public view override returns (uint256) {
    //        return f();
    //      }
    //    }

    // When analizing contract B, cloned functions f and g will be added, so the
    // function remappings will look something like:
    //    functionRemapping = {
    //      (A.f.id, cloned_f),
    //      (A.g.id, cloned_g)
    //    }
    //    functionRemappingOverriders = {
    //      (A.f.id, cloned_f),
    //      (A.g.id, B.g),
    //      (B.g, B.g)
    //    }
    const functionRemapping: Map<number, FunctionDefinition> = new Map();
    const functionRemappingOverriders: Map<number, FunctionDefinition> = new Map();
    const variableRemapping: Map<number, VariableDeclaration> = new Map();
    const modifierRemapping: Map<number, ModifierDefinition> = new Map();
    const modifierRemappingOverriders: Map<number, ModifierDefinition> = new Map();
    const eventRemapping: Map<number, EventDefinition> = new Map();

    solveConstructorInheritance(node, ast, this.generateIndex.bind(this));
    addPrivateSuperFunctions(node, functionRemapping, functionRemappingOverriders, ast);
    addNonoverridenPublicFunctions(node, functionRemapping, ast);
    addStorageVariables(node, variableRemapping, ast);
    addNonOverridenModifiers(node, modifierRemapping, modifierRemappingOverriders, ast);
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

    updateReferencedDeclarations(node, functionRemapping, functionRemappingOverriders, ast);
    updateReferencedDeclarations(node, variableRemapping, variableRemapping, ast);
    updateReferencedDeclarations(node, modifierRemapping, modifierRemappingOverriders, ast);
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
