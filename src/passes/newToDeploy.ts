import {
  ContractDefinition,
  DataLocation,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  MemberAccess,
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
    assert(node.parent instanceof FunctionCall);
    const deployCall = createDeploySysCall(node.parent, node.vTypeName, ast);

    ast.replaceNode(node.parent, deployCall);
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
  );

  const mainParam = createAbiEncodeCall(node, ast);
  return createCallToFunction(
    deployStub,
    [createNumberLiteral(0, ast), createNumberLiteral(0, ast), mainParam],
    ast,
    node,
  );
}

function createAbiEncodeCall(node: FunctionCall, ast: AST) {
  const abiIdentifier = new Identifier(ast.reserveId(), '', 'abi', 'abi', -1, undefined);
  const encodeMemberAccess = new MemberAccess(
    ast.reserveId(),
    '',
    createBytesTypeName(ast).typeString,
    abiIdentifier,
    'encode',
    -1,
    undefined,
  );

  return new FunctionCall(
    ast.reserveId(),
    '',
    createBytesTypeName(ast).typeString,
    FunctionCallKind.FunctionCall,
    encodeMemberAccess,
    node.vArguments.map((a) => cloneASTNode(a, ast)),
  );
}
