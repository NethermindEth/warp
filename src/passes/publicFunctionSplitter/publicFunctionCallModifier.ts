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
import assert = require('assert');

export class PublicFunctionCallModifier extends ASTMapper {
  constructor(
    public publicToExternalFunctionMap: Map<FunctionDefinition, FunctionDefinition>,
    public publicToInternalFunctionMap: Map<FunctionDefinition, string>,
  ) {
    super();
  }
  /*
  This class will visit function calls and if they are cross contract and point to the public function that was split
  into internal and external functions it will point the function calls to the external function 
  */
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    // Changing Contract 2 Contract calls (Not Supported Yet)
    const functionDefintion = node.vReferencedDeclaration as FunctionDefinition;
    const replacementFunction = this.publicToExternalFunctionMap.get(functionDefintion);
    if (
      replacementFunction !== undefined &&
      // functionDefintion instanceof FunctionDefinition &&
      // node.kind === FunctionCallKind.FunctionCall &&
      (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier)
    ) {
      if (
        node.vReferencedDeclaration?.getClosestParentByType(ContractDefinition) !==
        node.getClosestParentByType(ContractDefinition)
      ) {
        //node.vExpression.memberName = replacementFunction.name;
        //node.referencedDeclaration = replacementFunction.id
        node.vExpression.referencedDeclaration = replacementFunction.id;
      } //if (
      //  node.vReferencedDeclaration?.getClosestParentByType(ContractDefinition) ===
      //  node.getClosestParentByType(ContractDefinition)
      //)
      else {
        //assert(node.vExpression instanceof Identifier);
        const newFuncName = this.publicToInternalFunctionMap.get(functionDefintion) as string;
        node.vExpression instanceof Identifier
          ? (node.vExpression.name = newFuncName)
          : (node.vExpression.memberName = newFuncName);
      }
    }
    this.commonVisit(node, ast);
  }
}
