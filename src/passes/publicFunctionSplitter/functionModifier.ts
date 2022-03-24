import {
  ASTNode,
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
  constructor(
    public publicToExternalFunctionMapMaster: Map<FunctionDefinition, FunctionDefinition>,
  ) {
    super();
  }
  /*
  This class will visit function calls and if they are cross contract and point to the public function that was split
  into internal and external functions it will point the function calls to the external function 
  */
  NODESET = new Set<ASTNode>();
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.vExpression instanceof MemberAccess &&
      node.kind === FunctionCallKind.FunctionCall &&
      node.vExpression.vReferencedDeclaration?.getClosestParentByType(ContractDefinition) !==
        node.getClosestParentByType(ContractDefinition)
    ) {
      assert(
        node.vReferencedDeclaration !== undefined &&
          node.vReferencedDeclaration instanceof FunctionDefinition &&
          this.publicToExternalFunctionMapMaster.get(node.vReferencedDeclaration) !== undefined,
      );
      const replacementFunction = this.publicToExternalFunctionMapMaster.get(
        node.vReferencedDeclaration,
      );
      assert(replacementFunction !== undefined);

      node.vExpression.memberName = replacementFunction.name;
      node.vExpression.referencedDeclaration = replacementFunction.id;

      //console.log(node);
      //this.NODESET.add(node);
    }
    this.commonVisit(node, ast);
  }
}
