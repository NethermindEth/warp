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
import { createHash } from 'crypto';

export class NewToDeploy extends ASTMapper {
  placeHolderMap = new Map<string, VariableDeclaration>();
  constructor() {
    super();
  }

  visitNewExpression(node: NewExpression, ast: AST): void {
    if (
      !(
        node.vTypeName instanceof UserDefinedTypeName &&
        node.vTypeName.vReferencedDeclaration instanceof ContractDefinition
      )
    ) {
      return;
    }
    const contractName = node.vTypeName.vReferencedDeclaration.name;

    // Get or creat placeholder for class hash
    let placeholder = this.placeHolderMap.get(contractName);
    if (placeholder === undefined) {
      const sourceUnit = node.getClosestParentByType(SourceUnit);
      assert(sourceUnit !== undefined);
      placeholder = this.createPlaceHolder(sourceUnit, contractName, ast);
      console.log('first', sourceUnit.vVariables.map((v) => v.name).join(', '));
      sourceUnit.insertAtBeginning(placeholder);
      ast.setContextRecursive(placeholder);
      console.log('later', sourceUnit.vVariables.map((v) => v.name).join(', '));
      // Insert placeholder declaration in mapping
      this.placeHolderMap.set(contractName, placeholder);
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
    contractName: string,
    ast: AST,
  ): VariableDeclaration {
    const hash = createHash('sha256').update(contractName).digest('hex').slice(0, 16);
    const varName = `${contractName}_${hash}`;
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
    // const varDeclStatement = new VariableDeclarationStatement(
    //   ast.reserveId(),
    //   '',
    //   [varDecl.id],
    //   [varDecl],
    //   createNumberLiteral(0, ast, 'uint160'),
    // );

    return varDecl;
  }
}
