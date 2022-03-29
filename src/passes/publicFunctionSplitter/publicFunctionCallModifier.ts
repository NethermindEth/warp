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

export class PublicFunctionCallModifier extends ASTMapper {
  constructor(public internalToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>) {
    super();
  }
  /*
  This class visits FunctionCalls and if they are cross contract will repoint them to the new external function
  and if they are calling functions from the same contract it will change the functionCall to have the added suffix.
  */
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const functionDefintion = node.vReferencedDeclaration as FunctionDefinition;
    const replacementFunction = this.internalToExternalFunctionMap.get(functionDefintion);
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      replacementFunction !== undefined &&
      (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier)
    ) {
      if (
        node.vReferencedDeclaration?.getClosestParentByType(ContractDefinition) !==
        node.getClosestParentByType(ContractDefinition)
      ) {
        // Changes the referenced function to the external function since this is a cross contract call.
        node.vExpression.referencedDeclaration = replacementFunction.id;
      } else {
        // Modifies the function call to have the function.name + suffix.
        const newFuncName = functionDefintion.name as string;
        node.vExpression instanceof Identifier
          ? (node.vExpression.name = newFuncName)
          : (node.vExpression.memberName = newFuncName);
      }
    }
    this.commonVisit(node, ast);
  }
}
