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
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import {
  createAddressTypeName,
  createBytesNTypeName,
  createBytesTypeName,
  createIdentifier,
  createNumberLiteral,
} from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';
import { hashFilename } from '../utils/postCairoWrite';
import { CONTRACT_INFIX } from '../utils/nameModifiers';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';

/** Pass that takes all expressions of the form:
 *
 *   `new {salt: salt} Contract(arg1, ..., argn)`
 *
 *   And transpiles them to Cairo `deploy` system call:
 *
 *   `deploy(Contract_class_hash, salt, encode(arg1, ... argn))`
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
 */
export class NewToDeploy extends ASTMapper {
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'I', // Encoder util function must have the right type for encoding
      'Ffi', // Define the `encoder` util function after the free funtion has been moved
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  // map of: (contract name => contract declaration hash placeholder)
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
      const sourceUnit = node.getClosestParentByType(SourceUnit);
      assert(sourceUnit !== undefined, `Couldn not find source unit of ${printNode(node)}`);
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
      const narrowStub = createCairoFunctionStub(
        'narrow_safe',
        [['x', createBytesNTypeName(32, ast)]],
        [['val', createBytesNTypeName(30, ast)]],
        ['range_check_ptr'],
        ast,
        parent,
      );
      salt = createCallToFunction(narrowStub, [bytes32Salt], ast, parent);
      ast.replaceNode(bytes32Salt, salt, parent);
      ast.registerImport(salt, 'warplib.maths.utils', 'narrow_safe');
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
        // ['deploy_from_zero', createBoolTypeName(ast)], // uncomment after cairo 0.9.1 bump
      ],
      [['contract_address', cloneASTNode(typeName, ast)]],
      ['syscall_ptr'],
      ast,
      node,
      { acceptsUnpackedStructArray: true },
    );
    ast.registerImport(node, 'starkware.starknet.common.syscalls', 'deploy');

    const encodedArguments = ast.getUtilFuncGen(node).utils.encodeAsFelt.gen(node);
    // const deployFromZero = createBoolLiteral(false, ast); // uncomment after cairo 0.9.1 bump
    return createCallToFunction(
      deployStub,
      [
        placeHolderIdentifier,
        salt,
        encodedArguments,
        // deployFromZero // uncomment after cairo 0.9.1 bump
      ],
      ast,
      node,
    );
  }

  private createPlaceHolder(
    sourceUnit: SourceUnit,
    declaredContract: ContractDefinition,
    ast: AST,
  ): VariableDeclaration {
    const declaredContractSourceUnit = declaredContract.getClosestParentByType(SourceUnit);
    assert(declaredContractSourceUnit !== undefined);

    const declaredContractFullPath = declaredContractSourceUnit.absolutePath.split(
      new RegExp('/+|\\\\+'),
    );
    const cairoPath = declaredContractSourceUnit.absolutePath
      .slice(0, -'.sol'.length)
      .concat('.cairo');

    const fileName =
      declaredContractFullPath[declaredContractFullPath.length - 1].split(CONTRACT_INFIX)[0];
    const contractName = declaredContract.name;

    const fullPath = declaredContractFullPath.slice(0, -1).join('_');
    const varPrefix = `${fullPath}_${fileName}_${contractName}`;
    const hash = hashFilename(cairoPath);
    const varName = `${varPrefix}_${hash}`;

    const varDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      true,
      false,
      varName,
      sourceUnit.id,
      false,
      DataLocation.Default,
      StateVariableVisibility.Internal,
      Mutability.Constant,
      'address',
      `@declare ${cairoPath}`,
      createAddressTypeName(false, ast),
      undefined,
      createNumberLiteral(0, ast, 'uint160'),
    );

    return varDecl;
  }
}
