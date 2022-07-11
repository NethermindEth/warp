import {
  ContractDefinition,
  DataLocation,
  FunctionCall,
  FunctionVisibility,
  NewExpression,
  TypeName,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { UserDefinedTypeName } from 'solc-typed-ast';
import assert from 'assert';
import { createCairoFunctionStub, createCallToFunction } from '../utils/functionGeneration';
import {
  createAddressTypeName,
  createBytesTypeName,
  createNumberLiteral,
  createUintNTypeName,
} from '../utils/nodeTemplates';
import { cloneASTNode } from '../utils/cloning';

export class NewToDeploy extends ASTMapper {
  visitNewExpression(node: NewExpression, ast: AST): void {
    if (
      !(
        node.vTypeName instanceof UserDefinedTypeName &&
        node.vTypeName.vReferencedDeclaration instanceof ContractDefinition
      )
    ) {
      return;
    }
    const newFuncCall = node.parent;
    assert(newFuncCall instanceof FunctionCall);
    const deployCall = createDeploySysCall(newFuncCall, node.vTypeName, ast);

    ast.replaceNode(newFuncCall, deployCall);
  }
}

function createDeploySysCall(node: FunctionCall, typeName: TypeName, ast: AST) {
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

  // Todo define place holder
  // Todo define salt
  const mainParam = ast.getUtilFuncGen(node).utils.encodeAsFelt.gen(node);
  return createCallToFunction(
    deployStub,
    [createNumberLiteral(0, ast), createNumberLiteral(0, ast), mainParam],
    ast,
    node,
  );
}
