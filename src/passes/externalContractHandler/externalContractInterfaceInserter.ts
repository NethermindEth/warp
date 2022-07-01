import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
  DataLocation,
  ElementaryTypeName,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  getNodeType,
  Identifier,
  MemberAccess,
  Mutability,
  SourceUnit,
  StateVariableVisibility,
  TypeNameType,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { isExternallyVisible } from '../../utils/utils';

export class ExternalContractInterfaceInserter extends ASTMapper {
  /*
    This is a sort of pass which goes through every variable declaration/function call/member access
    and identifies the external contracts that are being used. It then creates a new contract interface
    for each of those contracts and inserts it into the AST.
  */

  constructor(private contractInterfaces: Map<number, ContractDefinition>) {
    super();
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    if (declaration instanceof ContractDefinition) {
      importExternalContract(
        declaration,
        node.getClosestParentByType(ContractDefinition),
        this.contractInterfaces,
        ast,
      );
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const nodeType = getNodeType(node.vExpression, ast.compilerVersion);
    if (nodeType instanceof UserDefinedType && nodeType.definition instanceof ContractDefinition) {
      importExternalContract(
        nodeType.definition,
        node.getClosestParentByType(ContractDefinition),
        this.contractInterfaces,
        ast,
      );
    } else if (
      nodeType instanceof TypeNameType &&
      nodeType.type instanceof UserDefinedType &&
      nodeType.type.definition instanceof ContractDefinition
    ) {
      importExternalContract(
        nodeType.type.definition,
        node.getClosestParentByType(ContractDefinition),
        this.contractInterfaces,
        ast,
      );
    }
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const varType = node.vType;

    if (!varType) return;

    if (
      varType instanceof UserDefinedTypeName &&
      varType.vReferencedDeclaration instanceof ContractDefinition
    ) {
      importExternalContract(
        varType.vReferencedDeclaration,
        node.getClosestParentByType(ContractDefinition),
        this.contractInterfaces,
        ast,
      );
    }
  }
}

function importExternalContract(
  importContract: ContractDefinition,
  baseContract: ContractDefinition | undefined,
  contractInterfaces: Map<number, ContractDefinition>,
  ast: AST,
): ContractDefinition {
  assert(baseContract !== undefined, 'Trying to import a definition into an unknown contract');
  let contractInterface = contractInterfaces.get(importContract.id);
  if (contractInterface !== undefined) {
    return contractInterface;
  }
  contractInterface = genContractInterface(importContract, baseContract, ast);
  contractInterfaces.set(importContract.id, contractInterface);
  return contractInterface;
}

export function getTemporaryInterfaceName(contractName: string): string {
  return `${contractName}@interface`;
}

export function genContractInterface(
  importContract: ContractDefinition,
  baseContract: ContractDefinition,
  ast: AST,
): ContractDefinition {
  const sourceUnit = baseContract.getClosestParentByType(SourceUnit);
  assert(sourceUnit !== undefined, 'Trying to import a definition into an source unit');
  const contractId = ast.reserveId();
  const contractInterface = new ContractDefinition(
    contractId,
    '',
    // `@interface` is a workaround to avoid the conflict with
    // the existing contract with the same name
    getTemporaryInterfaceName(importContract.name),
    sourceUnit.id,
    ContractKind.Interface,
    importContract.abstract,
    false,
    importContract.linearizedBaseContracts,
    importContract.usedErrors,
  );

  importContract.vFunctions
    .filter((func) => func.kind !== FunctionKind.Constructor && isExternallyVisible(func))
    .forEach((func) => {
      const funcBody = func.vBody;
      func.vBody = undefined;
      const funcClone = cloneASTNode(func, ast);
      if (importContract.kind === ContractKind.Library) {
        funcClone.vParameters.insertAtBeginning(createClassHashVarDecl(funcClone, ast));
      }
      funcClone.scope = contractId;
      funcClone.implemented = false;
      func.vBody = funcBody;
      contractInterface.appendChild(funcClone);
      ast.registerChild(funcClone, contractInterface);
      repointFunctionCalls(func, baseContract, funcClone);
    });
  sourceUnit.appendChild(contractInterface);
  ast.registerChild(contractInterface, sourceUnit);
  return contractInterface;
}

function repointFunctionCalls(
  func: FunctionDefinition,
  contract: ContractDefinition,
  funcClone: FunctionDefinition,
) {
  const funcCallsToPoint = contract
    .getChildren(true)
    .filter((n) => n instanceof FunctionCall && n.vReferencedDeclaration === func);

  funcCallsToPoint.forEach((n) => {
    assert(n instanceof FunctionCall);
    const call = n.vCallee;
    assert(call instanceof MemberAccess || call instanceof Identifier);
    call.vReferencedDeclaration = funcClone;
  });
}

function createClassHashVarDecl(funcDef: FunctionDefinition, ast: AST): VariableDeclaration {
  const classHashVarDecl = new VariableDeclaration(
    ast.reserveId(),
    '',
    true,
    false,
    '@class_hash',
    funcDef.id,
    false,
    DataLocation.Default,
    StateVariableVisibility.Default,
    Mutability.Constant,
    'int8',
    undefined,
    new ElementaryTypeName(ast.reserveId(), '', 'int8', 'int8'),
  );
  return classHashVarDecl;
}
