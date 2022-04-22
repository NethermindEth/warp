import {
  ContractDefinition,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  Identifier,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class InternalFunctionCallCollector extends ASTMapper {
  /*
     This class collects all functions which are called from the same contract it is defined in.
     It is used for later to avoid splitting function which are not called from anywhere in the
    contract producing cleaner Cairo code and lesser step count.
     All public Solidity functions which are not called from the same contract they are defined 
    in will be treated as external only functions.
  */
  constructor(public internalFunctionCallSet: Set<FunctionDefinition>) {
    super();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const functionDefinition = node.vReferencedDeclaration;
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      functionDefinition instanceof FunctionDefinition &&
      (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier) &&
      // Only collect internal calls to functions defined in the same contract
      functionDefinition.getClosestParentByType(ContractDefinition) ===
        node.getClosestParentByType(ContractDefinition)
    ) {
      this.internalFunctionCallSet.add(functionDefinition);
    }
    this.commonVisit(node, ast);
  }
}
