import assert = require('assert');
import {
  ContractDefinition,
  ContractKind,
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
    if (node.kind === FunctionCallKind.FunctionCall) {
      const funcDef = node.vReferencedDeclaration;
      assert(funcDef instanceof FunctionDefinition && funcDef !== undefined);
      const funcDefContract = funcDef.getClosestParentByType(ContractDefinition);
      const funcCallContract = node.getClosestParentByType(ContractDefinition);
      if (
        //funcDef instanceof FunctionDefinition &&
        funcDefContract?.kind !== ContractKind.Library &&
        (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier) &&
        funcDef !== undefined
      ) {
        const replacementFunction = this.internalToExternalFunctionMap.get(funcDef);
        if (replacementFunction !== undefined && funcDefContract !== funcCallContract) {
          // Changes the referenced function to the external function since this is a cross contract call.
          node.vExpression.referencedDeclaration = replacementFunction.id;
        } else {
          // Modifies the function call to have the function.name + suffix.
          const modifiedFuncName = funcDef.name;
          node.vExpression instanceof Identifier
            ? (node.vExpression.name = modifiedFuncName)
            : (node.vExpression.memberName = modifiedFuncName);
        }
      }
      this.commonVisit(node, ast);
    }
  }
}
