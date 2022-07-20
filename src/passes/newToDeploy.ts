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
  createUintNTypeName,
} from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';
import { hashFilename } from '../utils/postCairoWrite';
import { CONTRACT_INFIX } from '../utils/nameModifiers';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';

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
      ],
      [['contract_address', cloneASTNode(typeName, ast)]],
      ['syscall_ptr'],
      ast,
      node,
      { acceptsUnpackedStructArray: true },
    );
    ast.registerImport(node, 'starkware.starknet.common.syscalls', 'deploy');

    // Get salt value

    const encodedArguments = ast.getUtilFuncGen(node).utils.encodeAsFelt.gen(node);
    return createCallToFunction(
      deployStub,
      [placeHolderIdentifier, salt, encodedArguments],
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
      'uint160',
      `@declare ${cairoPath}`,
      createUintNTypeName(160, ast),
      undefined,
      createNumberLiteral(0, ast, 'uint160'),
    );

    return varDecl;
  }
}
