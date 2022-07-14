import {
  ContractDefinition,
  DataLocation,
  FunctionCall,
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
  createBytesTypeName,
  createIdentifier,
  createNumberLiteral,
  createUintNTypeName,
} from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';
import { hashFilename } from '../utils/postCairoWrite';
import { CONTRACT_INFIX } from '../utils/nameModifiers';

export class NewToDeploy extends ASTMapper {
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
      assert(sourceUnit !== undefined);
      placeholder = this.createPlaceHolder(sourceUnit, contractToCreate, ast);
      sourceUnit.insertAtBeginning(placeholder);
      ast.setContextRecursive(placeholder);
      // Insert placeholder declaration in mapping
      this.placeHolderMap.set(contractToCreate.name, placeholder);
    }

    // Swapping new for deploy sys call
    const newFuncCall = node.parent;
    assert(newFuncCall instanceof FunctionCall);
    const placeHolderIdentifier = createIdentifier(placeholder, ast);
    const deployCall = this.createDeploySysCall(
      newFuncCall,
      node.vTypeName,
      placeHolderIdentifier,
      ast,
    );
    ast.replaceNode(newFuncCall, deployCall);
  }

  private createDeploySysCall(
    node: FunctionCall,
    typeName: TypeName,
    placeHolderIdentifier: Identifier,
    ast: AST,
  ): FunctionCall {
    const deployStub = createCairoFunctionStub(
      'deploy',
      [
        ['class_hash', createAddressTypeName(false, ast)],
        ['contract_address_salt', createUintNTypeName(248, ast)],
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
      [placeHolderIdentifier, createNumberLiteral(0, ast), encodedArguments],
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

    const fileName =
      declaredContractFullPath[declaredContractFullPath.length - 1].split(CONTRACT_INFIX)[0];
    const contractName = declaredContract.name;

    const fullPath = declaredContractFullPath.slice(0, -1).join('_');
    const varPrefix = `${fullPath}_${fileName}_${contractName}`;
    const hash = hashFilename(varPrefix);
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
      undefined,
      createUintNTypeName(160, ast),
      undefined,
      createNumberLiteral(0, ast, 'uint160'),
    );

    return varDecl;
  }
}
