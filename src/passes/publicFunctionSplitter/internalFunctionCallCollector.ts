import assert = require('assert');
import {
  ContractDefinition,
  FunctionCall,
  FunctionDefinition,
  FunctionType,
  MemberAccess,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';

export class InternalFunctionCallCollector extends ASTMapper {
  /*
  This class collects all functions which are internal. This is used in later sub-passes to 
  avoid splitting public functions with no internal calls. This produces cleaner Cairo code 
  and lessens the step and line counts.
  
  All public Solidity functions which have no internal calls pointing to them will be modified
  to be external only functions.
  */
  constructor(public internalFunctionCallSet: Set<FunctionDefinition>) {
    super();
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const funcDef = node.vReferencedDeclaration;
    if (funcDef instanceof FunctionDefinition) {
      if (node.vExpression instanceof MemberAccess) {
        const typeNode = safeGetNodeType(node.vExpression.vExpression, ast.inference);
        if (
          typeNode instanceof UserDefinedType &&
          typeNode.definition instanceof ContractDefinition
        ) {
          this.commonVisit(node, ast);
          return;
        }
      }
      this.internalFunctionCallSet.add(funcDef);
    }
    this.commonVisit(node, ast);
  }
}
