import {
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  Identifier,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { isInternalFuncCall } from './internalFunctionCallCollector';

export class PublicFunctionCallModifier extends ASTMapper {
  constructor(public internalToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>) {
    super();
  }
  /*
  This class visits FunctionCalls and if they are:
    External function calls, they will be re-pointed to the external function definition created in the previous sub-pass.
    Internal function calls, they will still point to their old function definition, but will need to have their names
    changed to have the '_internal' suffix.
  */
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const funcDef = node.vReferencedDeclaration;
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      funcDef instanceof FunctionDefinition &&
      (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier)
    ) {
      const replacementFunction = this.internalToExternalFunctionMap.get(funcDef);
      // If replacementFunction exists then the FunctionCall pointed to a public function definition.
      // The function call will need to be modified irrespective of whether it is internal or external.
      if (replacementFunction !== undefined) {
        // If it is an external call the function gets re-pointed to the new external call.
        if (!isInternalFuncCall(node, ast)) {
          node.vExpression.referencedDeclaration = replacementFunction.id;
          // If it is an internal call then the functionCall.vExpressions name needs to be changed to
          // match it's modified function definition's name
        } else {
          const modifiedFuncName = funcDef.name;
          node.vExpression instanceof Identifier
            ? (node.vExpression.name = modifiedFuncName)
            : (node.vExpression.memberName = modifiedFuncName);
        }
      }
    }
    this.commonVisit(node, ast);
  }
}
