import {
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  Identifier,
  MemberAccess,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

export class InternalFunctionCallCollector extends ASTMapper {
  constructor(public internalFunctionCallSet: Set<FunctionDefinition>) {
    super();
  }

  /*
     This class collects all internal function calls in the contract
  */
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const functionDefintion = node.vReferencedDeclaration;
    if (
      node.kind === FunctionCallKind.FunctionCall &&
      functionDefintion instanceof FunctionDefinition &&
      (node.vExpression instanceof MemberAccess || node.vExpression instanceof Identifier)
    ) {
      this.internalFunctionCallSet.add(functionDefintion);
    }
    this.commonVisit(node, ast);
  }
}
