import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionKind,
  Identifier,
  MemberAccess,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createAddressTypeName } from '../../utils/nodeTemplates';
import { cloneASTNode } from '../../utils/cloning';
import { CairoContract } from '../../ast/cairoNodes';
import { mangleOwnContractInterface } from '../../utils/utils';

export class ThisKeyword extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    if (node.name === 'this') {
      const replacementCall = createCallToFunction(
        createCairoFunctionStub(
          'get_contract_address',
          [],
          [['address', createAddressTypeName(false, ast)]],
          ['syscall_ptr'],
          ast,
          node,
        ),
        [],
        ast,
      );
      ast.replaceNode(node, replacementCall);
      ast.registerImport(
        replacementCall,
        'starkware.starknet.common.syscalls',
        'get_contract_address',
      );
    } else {
      return;
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.vExpression instanceof MemberAccess &&
      node.vExpression.vExpression instanceof Identifier &&
      node.vExpression.vExpression.name === 'this'
    ) {
      const replacementCall = createCallToFunction(
        createCairoFunctionStub(
          'get_contract_address',
          [],
          [['address', createAddressTypeName(false, ast)]],
          ['syscall_ptr'],
          ast,
          node,
        ),
        [],
        ast,
      );
      const currentContract = node.getClosestParentByType(ContractDefinition);
      const sourceUnit = node.getClosestParentByType(SourceUnit);
      if (currentContract && sourceUnit) {
        // check if currentContract.name is in sourceUnit.vContracts[]
        const contractIndex = sourceUnit.vContracts.findIndex(
          (contract) => contract.name === mangleOwnContractInterface(currentContract),
        );
        if (contractIndex === -1)
          genCairoContractInterface(
            currentContract,
            sourceUnit,
            ast,
            mangleOwnContractInterface(currentContract),
          );
      }
      replacementCall.typeString = currentContract
        ? `contract ${mangleOwnContractInterface(currentContract)}`
        : replacementCall.typeString;
      ast.replaceNode(node.vExpression.vExpression, replacementCall);
      ast.registerImport(
        replacementCall,
        'starkware.starknet.common.syscalls',
        'get_contract_address',
      );
    }
    this.commonVisit(node, ast);
  }
}

function genCairoContractInterface(
  contract: ContractDefinition,
  sourceUnit: SourceUnit,
  ast: AST,
  contractName: string,
): ContractDefinition {
  const contractId = ast.reserveId();
  const contractInterface = new CairoContract(
    contractId,
    '',
    contractName,
    sourceUnit.id,
    ContractKind.Interface,
    contract.abstract,
    false,
    contract.linearizedBaseContracts,
    contract.usedErrors,
    new Map(),
    new Map(),
    0,
    0,
  );

  contract.vFunctions
    .filter((func) => func.kind !== FunctionKind.Constructor)
    .forEach((func) => {
      const funcBody = func.vBody;
      func.vBody = undefined;
      const funcClone = cloneASTNode(func, ast);

      // TODO check whether it's worth detaching all bodies in the contract's functions,
      // cloning the entire contract, then reattaching (can anything in the function but
      // not the body reference the containing contract other than .scope?)
      funcClone.scope = contractId;
      funcClone.implemented = false;
      func.vBody = funcBody;
      contractInterface.appendChild(funcClone);
      ast.registerChild(funcClone, contractInterface);
    });
  sourceUnit.appendChild(contractInterface);
  ast.registerChild(contractInterface, sourceUnit);
  return contractInterface;
}
