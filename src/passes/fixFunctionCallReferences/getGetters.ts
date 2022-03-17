import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

import {
  ContractDefinition,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
} from 'solc-typed-ast';

export class GetGetters extends ASTMapper {
  constructor(private getterFunctions: Map<number, FunctionDefinition>) {
    super();
  }

  visitContractDefinition(node: ContractDefinition, _ast: AST): void {
    node.vStateVariables.forEach((v) => {
      // check if v is public state variable
      if (v.visibility === 'public' && v.stateVariable) {
        /*
                    for every function definition in the contract,
                    check if it's a getter function with name of the state variable
                */
        node.vFunctions.forEach((func) => {
          if (
            func.kind === FunctionKind.Function &&
            func.name === v.name &&
            func.visibility === FunctionVisibility.Public
          ) {
            this.getterFunctions.set(v.id, func);
          }
        });
      }
    });
  }
}
