import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import {
  FunctionCall,
  FunctionDefinition,
  MemberAccess,
  VariableDeclaration,
} from 'solc-typed-ast';

import { TranspilationAbandonedError } from '../../utils/errors';

export class FixFnCallRef extends ASTMapper {
  constructor(private getterFunctions: Map<number, FunctionDefinition>) {
    super();
  }
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.vReferencedDeclaration instanceof VariableDeclaration) {
      if (
        node.vReferencedDeclaration.stateVariable &&
        node.vReferencedDeclaration.visibility === 'public'
      ) {
        /*
                    Getter function of a public state variable can be 
                    only invoked through using this.`functionName` only
                */
        if (!(node.vExpression instanceof MemberAccess)) {
          throw new TranspilationAbandonedError('FixFnCallRef: vExpression is not a MemberAccess');
          ``;
        }

        node.vExpression.vReferencedDeclaration = this.getterFunctions.get(
          node.vReferencedDeclaration.id,
        );
      }
    }
    return this.visitExpression(node, ast);
  }
}
