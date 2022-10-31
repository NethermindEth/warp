import {
  ContractDefinition,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionCallOptions,
  Identifier,
  Mutability,
  NewExpression,
  SourceUnit,
  StateVariableVisibility,
  TypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { UserDefinedTypeName } from 'solc-typed-ast';
import assert from 'assert';
import {
  createCairoFunctionStub,
  createCallToFunction,
  createElementaryConversionCall,
} from '../utils/functionGeneration';
import {
  createAddressTypeName,
  createBoolLiteral,
  createBoolTypeName,
  createBytesNTypeName,
  createBytesTypeName,
  createIdentifier,
  createNumberLiteral,
} from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';
import { hashFilename } from '../utils/postCairoWrite';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';
import { getParameterTypes } from '../utils/nodeTypeProcessing';
import { getContainingSourceUnit } from '../utils/utils';

/** Pass that takes all expressions of the form:
 *
 *   `new {salt: salt} Contract(arg1, ..., argn)`
 *
 *   And transpiles them to Cairo `deploy` system call:
 *
 *   `deploy(contract_class_hash, salt, encode(arg1, ... argn), deploy_from_zero)`
 *
 *   -----
 *
 *   Since solidity stores the bytecode of the contract to create, and cairo uses
 *   a declaration address(`class_hash`) of the contract on starknet and the latter
 *   can only be known when interacting with starknet, empty placeholders are used
 *   for compiling, and then filled during deployement with the right address.
 *
 *   Salt in solidity is 32 bytes while in Cairo is a felt, so it'll be safely
 *   narrowed down. Notice that values bigger than a felt will result in errors
 *   such as "abc" which in bytes32 representation gets 0x636465...0000 which is
 *   bigger than a felt.
 *
 *   Encode is a util function generated which takes all the transpiled arguments
 *   and makes them a big dynamic arrays of felts. For example arguments:
 *   (a : Uint256, b : felt, c : (felt, felt, felt))
 *   are encoded as (6, [a.low, a.high, b, c[0], c[1], c[2]])
 *
 *   deploy_from_zero is a bool which determines if the deployer's address will
 *   affect the contract address or not. Is set to FALSE by default.
 *
 */
export class NewToDeploy extends ASTMapper {
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Ffi', // Define the `encoder` util function after the free funtion has been moved
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  // map of: (contract name => class hash placeholder)
  placeHolderMap = new Map<string, VariableDeclaration>();

  visitNewExpression(node: NewExpression, ast: AST): void {
    if (
      !(
        node.vTypeName instanceof UserDefinedTypeName &&
        node.vTypeName.vReferencedDeclaration instanceof ContractDefinition
      )
    ) {
      return;
    }
    const contractToCreate = node.vTypeName.vReferencedDeclaration;

    // Get or create placeholder for the class hash
    let placeholder = this.placeHolderMap.get(contractToCreate.name);
    if (placeholder === undefined) {
      const sourceUnit = getContainingSourceUnit(node);
      placeholder = this.createPlaceHolder(sourceUnit, contractToCreate, ast);
      sourceUnit.insertAtBeginning(placeholder);
      ast.setContextRecursive(placeholder);
      // Insert placeholder declaration in mapping
      this.placeHolderMap.set(contractToCreate.name, placeholder);
    }

    // Swapping new for deploy sys call
    const parent = node.parent;
    let newFuncCall: FunctionCall;
    let salt: Expression;
    if (parent instanceof FunctionCall) {
      newFuncCall = parent;
      salt = createNumberLiteral(0, ast);
    } else if (parent instanceof FunctionCallOptions) {
      assert(parent.parent instanceof FunctionCall);
      newFuncCall = parent.parent;
      const bytes32Salt = parent.vOptionsMap.get('salt');
      assert(bytes32Salt !== undefined);
      // Narrow salt to a felt range
      salt = createElementaryConversionCall(createBytesNTypeName(30, ast), bytes32Salt, node, ast);
      ast.replaceNode(bytes32Salt, salt, parent);
    } else {
      throw new TranspileFailedError(
        `Contract New Expression has an unexpected parent. Expected FunctionCall or FunctionCallOptions instead ${
          parent !== undefined ? printNode(parent) : 'undefined'
        } was found`,
      );
    }

    const placeHolderIdentifier = createIdentifier(placeholder, ast);
    const deployCall = this.createDeploySysCall(
      newFuncCall,
      node.vTypeName,
      placeHolderIdentifier,
      salt,
      ast,
    );
    ast.replaceNode(newFuncCall, deployCall);

    this.visitExpression(node, ast);
  }

  private createDeploySysCall(
    node: FunctionCall,
    typeName: TypeName,
    placeHolderIdentifier: Identifier,
    salt: Expression,
    ast: AST,
  ): FunctionCall {
    const deployStub = createCairoFunctionStub(
      'deploy',
      [
        ['class_hash', createAddressTypeName(false, ast)],
        ['contract_address_salt', createBytesNTypeName(30, ast)],
        ['constructor_calldata', createBytesTypeName(ast), DataLocation.CallData],
        ['deploy_from_zero', createBoolTypeName(ast)],
      ],
      [['contract_address', cloneASTNode(typeName, ast)]],
      ['syscall_ptr'],
      ast,
      node,
      { acceptsUnpackedStructArray: true },
    );
    ast.registerImport(node, 'starkware.starknet.common.syscalls', 'deploy');

    const encodedArguments = ast
      .getUtilFuncGen(node)
      .utils.encodeAsFelt.gen(node.vArguments, getParameterTypes(node, ast));
    const deployFromZero = createBoolLiteral(false, ast);
    return createCallToFunction(
      deployStub,
      [placeHolderIdentifier, salt, encodedArguments, deployFromZero],
      ast,
      node,
    );
  }

  private createPlaceHolder(
    sourceUnit: SourceUnit,
    declaredContract: ContractDefinition,
    ast: AST,
  ): VariableDeclaration {
    const declaredContractSourceUnit = getContainingSourceUnit(declaredContract);

    const declaredContractFullPath = declaredContractSourceUnit.absolutePath.split(
      new RegExp('/+|\\\\+'),
    );
    const cairoPath = declaredContractSourceUnit.absolutePath.concat('.cairo');

    const fileName = declaredContractFullPath[declaredContractFullPath.length - 2].slice(
      0,
      -'.sol'.length,
    );
    const contractName = declaredContract.name;

    const fullPath = declaredContractFullPath.slice(0, -2).join('_');
    const varPrefix = `${fullPath}_${fileName}_${contractName}`;
    const hash = hashFilename(cairoPath);

    /*
     * The name of the place holder is important because it will be used later
     * during deployment to set the appropriate class hash value (notice below
     * it is being set to zero by default)
     * The name is a combination of:
     * - the path to the cairo file which contain the target contract to deploy
     * - the hash of the path.
     * The path part is unnecessary, but  it's left there for readability.
     * The hash part is the one used for later to search for the correct file
     * declaration. Also it used to avoid naming clashes between different placeholders.
     */
    const varName = `${varPrefix}_${hash}`;
    /*
     * The form of documentation is used later during post-linking to extract the files
     * this source unit depends on. See src/utils/postCairoWrite.ts
     */
    const documentation = `@declare ${cairoPath}`;

    const varDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true, // constant
      false, // indexed
      varName,
      sourceUnit.id,
      false, // stateVariable
      DataLocation.Default,
      StateVariableVisibility.Internal,
      Mutability.Constant,
      'address',
      documentation,
      createAddressTypeName(false, ast),
      undefined,
      createNumberLiteral(0, ast, 'uint160'),
    );

    return varDecl;
  }
}
