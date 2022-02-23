import { ASTMapper } from '../ast/mapper';
import {
  Return,
  Block,
  ContractDefinition,
  DataLocation,
  FunctionDefinition,
  VariableDeclaration,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Mapping,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  UserDefinedTypeName,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { createIdentifier } from '../utils/utils';
import { cloneTypeName } from '../utils/cloning';
export class GettersPublicStateVars extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    //TODO add support for struct/mapping public state variables
    //TODO add support for UserDefinedTypeNames
    node.vStateVariables.forEach((v) => {
      /*
        Visit every public state variable and Add 
        FunctionDefinition(getter func) as a child of the current 
        ContractDefinition node.
      */
      const stateVarType = v.vType;
      // if it's not a mapping/struct, add getter function to the contract
      if (v.stateVariable && v.visibility === 'public') {
        if (!(v.vType instanceof Mapping)) {
          if (stateVarType instanceof UserDefinedTypeName) {
            return;
          }
          const funcDefID = ast.reserveId();
          const returnParameter = new ParameterList(ast.reserveId(), '', 'ParameterList', [
            new VariableDeclaration(
              ast.reserveId(),
              '',
              'VariableDeclaration',
              false,
              false,
              '',
              funcDefID,
              false,
              DataLocation.Default,
              StateVariableVisibility.Internal,
              Mutability.Mutable,
              v.typeString,
              undefined,
              stateVarType ? cloneTypeName(stateVarType, ast) : undefined,
            ),
          ]);

          const getterBlock = new Block(ast.reserveId(), '', 'Block', [
            new Return(ast.reserveId(), '', 'Return', returnParameter.id, createIdentifier(v, ast)),
          ]);

          const getter = new FunctionDefinition(
            funcDefID,
            '',
            'FunctionDefinition',
            node.id,
            FunctionKind.Function,
            v.name,
            false,
            FunctionVisibility.Public,
            FunctionStateMutability.View,
            false,
            new ParameterList(ast.reserveId(), '', 'ParameterList', []),
            returnParameter,
            [],
            undefined,
            getterBlock,
          );
          node.appendChild(getter);
          ast.registerChild(getter, node);
        }
      }
    });
  }
}
