import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import {
  FunctionCall,
  FunctionDefinition,
  MemberAccess,
  VariableDeclaration,
} from 'solc-typed-ast';

import { TranspileFailedError } from '../../utils/errors';

export class FixFnCallRef extends ASTMapper {
  constructor(private getterFunctions: Map<VariableDeclaration, FunctionDefinition>) {
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
          throw new TranspileFailedError('FixFnCallRef: vExpression is not a MemberAccess');
        }

        //assert getterFunctions has this variable
        const getterFunction = this.getterFunctions.get(node.vReferencedDeclaration);
        if (!getterFunction) {
          throw new TranspileFailedError(
            `FixFnCallRef: getter function for a public state variable not found`,
          );
        }

        node.vExpression.vReferencedDeclaration = getterFunction;
      }
    }
    return this.visitExpression(node, ast);
  }
}
