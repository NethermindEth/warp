import {
  ContractDefinition,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import assert = require('assert');

export class PublicFunctionCallModifier extends ASTMapper {
  constructor(public publicToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>) {
    super();
  }
  /*
  This class will visit function calls and if they are cross contract and point to the public function that was split
  into internal and external functions it will point the function calls to the external function 
  */
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.vExpression instanceof MemberAccess &&
      node.kind === FunctionCallKind.FunctionCall &&
      node.vExpression.vReferencedDeclaration?.getClosestParentByType(ContractDefinition) !==
        node.getClosestParentByType(ContractDefinition)
    ) {
      assert(
        node.vReferencedDeclaration instanceof FunctionDefinition &&
          this.publicToExternalFunctionMap.get(node.vReferencedDeclaration) !== undefined,
      );
      const replacementFunction = this.publicToExternalFunctionMap.get(node.vReferencedDeclaration);
      assert(replacementFunction !== undefined);

      node.vExpression.memberName = replacementFunction.name;
      node.vExpression.referencedDeclaration = replacementFunction.id;
    }
    this.commonVisit(node, ast);
  }
}
