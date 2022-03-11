import { ASTMapper } from '../ast/mapper';

import {
  ArrayTypeName,
  Block,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  IndexAccess,
  Mapping,
  MemberAccess,
  Mutability,
  ParameterList,
  Return,
  StateVariableVisibility,
  StructDefinition,
  TupleExpression,
  TypeName,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { NotSupportedYetError, TranspileFailedError } from '../utils/errors';
import { cloneASTNode } from '../utils/cloning';
import { createIdentifier } from '../utils/nodeTemplates';
import { toSingleExpression } from './loopFunctionaliser/utils';

function genReturnVariables(
  vType: TypeName | undefined,
  funcDefID: number,
  ast: AST,
): VariableDeclaration[] {
  /*
    This function will return the list of return variables
    for a getter function of a public state var
    For e.g 
      struct A{ uint a; address b; mapping(int => int) c; }
      A public aa;
      The return list would be (uint , address)
  */
  if (!vType) return [];
  const newVarDecl = (dataLocation = DataLocation.Default) => {
    return new VariableDeclaration(
      ast.reserveId(),
      '',
      'VariableDeclaration',
      false,
      false,
      '',
      funcDefID,
      false,
      dataLocation,
      StateVariableVisibility.Internal,
      Mutability.Mutable,
      vType.typeString,
      undefined,
      cloneASTNode(vType, ast),
    );
  };
  if (vType instanceof ElementaryTypeName) {
    return [newVarDecl()];
  } else if (vType instanceof ArrayTypeName) {
    return genReturnVariables(vType.vBaseType, funcDefID, ast);
  } else if (vType instanceof Mapping) {
    return genReturnVariables(vType.vValueType, funcDefID, ast);
  } else if (vType instanceof UserDefinedTypeName) {
    if (vType.vReferencedDeclaration instanceof StructDefinition) {
      /*
        It will also covers the nested structs variables
        eg. struct A {
              uint a;
              struct B {
                uint b;
              }
            }
          It'll return (uint , B memory) for (a, b) respectively
      */
      const returnVariables: VariableDeclaration[] = [];
      let canStructBeReturned = true;
      vType.vReferencedDeclaration.vMembers.forEach((v) => {
        if (v.vType instanceof Mapping || v.vType instanceof ArrayTypeName) {
          /*
            Solidity doesn't allow recursive types for public state variables
            So, Any nested struct definition can not have member of type
            other than ElementaryTypeName
          */
          canStructBeReturned = false;
          return;
        }
        returnVariables.push(...genReturnVariables(v.vType, funcDefID, ast));
      });
      if (!canStructBeReturned) return returnVariables;
    }
    return [newVarDecl(DataLocation.Memory)];
  } else {
    throw new NotSupportedYetError(
      `Getter fn generation for ${vType.type} typenames not implemented yet`,
    );
  }
}

function genFunctionParams(
  varCount: number,
  vType: TypeName,
  funcDefID: number,
  ast: AST,
): VariableDeclaration[] {
  /*
    This function will return the list of paramters
    for a getter function of a public state var
    For e.g 
      mapping(uint => mapping(address => uint256))  
    The return list would be (uint i0, address i1)
  */
  if (!vType || vType instanceof ElementaryTypeName) {
    return [];
  } else if (vType instanceof ArrayTypeName) {
    return [
      new VariableDeclaration(
        ast.reserveId(),
        '',
        'VariableDeclaration',
        false,
        false,
        `_i${varCount}`,
        funcDefID,
        false,
        DataLocation.Default,
        StateVariableVisibility.Internal,
        Mutability.Mutable,
        'uint256',
        undefined,
        new ElementaryTypeName(ast.reserveId(), '', 'ElementaryTypeName', 'uint256', 'uint256'),
      ),
      ...genFunctionParams(varCount + 1, vType.vBaseType, funcDefID, ast),
    ];
  } else if (vType instanceof Mapping) {
    return [
      new VariableDeclaration(
        ast.reserveId(),
        '',
        'VariableDeclaration',
        false,
        false,
        `_i${varCount}`,
        funcDefID,
        false,
        DataLocation.Default,
        StateVariableVisibility.Internal,
        Mutability.Mutable,
        vType.vKeyType.typeString,
        undefined,
        cloneASTNode(vType.vKeyType, ast),
      ),
      ...genFunctionParams(varCount + 1, vType.vValueType, funcDefID, ast),
    ];
  } else if (vType instanceof UserDefinedTypeName) {
    return [];
  } else {
    throw new NotSupportedYetError(
      `Getter fn generation for ${vType.type} typenames not implemented yet`,
    );
  }
}

function genReturnExpression(
  idx: number,
  fnParams: ParameterList,
  v: VariableDeclaration,
  vType: TypeName | undefined,
  ast: AST,
  baseExpression?: Expression,
): Expression {
  /*
    This is an recursive function to generate the return 
    Expression for a getter function of a public state 
    variable.
    For e.g 
      struct A{ uint a; address b; mapping(int => int) c; }
      mapping(uint => mapping(address => A[])) c;
    The return expression would be a tuple (c[i0][i1][i2].a , c[i0][i1][i2].b)

    baseExpression: is the expression that has been generated in 
    the previous call of genReturnExpression
    e.g `c[i0][i1][i2]` in `c[i0][i1][i2].a`
  */
  if (!vType) {
    throw new TranspileFailedError(`Type of ${v.name} must be defined`);
  }
  if (vType instanceof ElementaryTypeName) {
    return baseExpression ?? createIdentifier(v, ast);
  } else if (vType instanceof ArrayTypeName) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      'IndexAccess',
      vType.vBaseType.typeString,
      baseExpression ?? createIdentifier(v, ast),
      createIdentifier(fnParams.vParameters[idx], ast),
    );
    return genReturnExpression(idx + 1, fnParams, v, vType.vBaseType, ast, baseExp);
  } else if (vType instanceof Mapping) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      'IndexAccess',
      vType.vValueType.typeString,
      baseExpression ?? createIdentifier(v, ast),
      createIdentifier(fnParams.vParameters[idx], ast),
    );
    return genReturnExpression(idx + 1, fnParams, v, vType.vValueType, ast, baseExp);
  } else if (vType instanceof UserDefinedTypeName) {
    if (vType.vReferencedDeclaration instanceof StructDefinition) {
      let canStructBeReturned = true;
      const returnExpressions: Expression[] = [];
      vType.vReferencedDeclaration.vMembers.forEach((m) => {
        if (!m.vType) return;
        if (m.vType instanceof Mapping || m.vType instanceof ArrayTypeName) {
          /*
            Solidity doesn't allow recursive types for public state variables
            So, Any nested struct definition can not have member of type
            other than ElementaryTypeName
          */
          canStructBeReturned = false;
          return;
        }
        const memberAccessExp: MemberAccess = new MemberAccess(
          ast.reserveId(),
          '',
          'MemberAccess',
          m.vType.typeString,
          baseExpression ?? createIdentifier(v, ast),
          m.name,
          vType.vReferencedDeclaration.id,
        );
        const mExpression: Expression = genReturnExpression(
          idx,
          fnParams,
          v,
          m.vType,
          ast,
          memberAccessExp,
        );
        if (mExpression instanceof TupleExpression) {
          returnExpressions.push(...mExpression.vComponents);
        } else {
          returnExpressions.push(mExpression);
        }
      });
      if (!canStructBeReturned) return toSingleExpression(returnExpressions, ast);
    }
    return baseExpression ?? createIdentifier(v, ast);
  } else {
    throw new NotSupportedYetError(
      `Getter fn generation for ${vType?.type} typenames not implemented yet`,
    );
  }
}

export class GettersPublicStateVars extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    node.vStateVariables.forEach((v) => {
      /*
        Visit every public state variable and Add 
        FunctionDefinition(getter func) as a child of the current 
        ContractDefinition node.
      */
      const stateVarType = v.vType;

      if (!stateVarType) {
        // skip getter function generation for state variable
        return;
      }

      if (v.stateVariable && v.visibility === 'public') {
        const funcDefID = ast.reserveId();

        const returnParameterList: ParameterList = new ParameterList(
          ast.reserveId(),
          '',
          'ParameterList',
          genReturnVariables(stateVarType, funcDefID, ast),
        );

        const fnParams: ParameterList = new ParameterList(
          ast.reserveId(),
          '',
          'ParameterList',
          genFunctionParams(0, stateVarType, funcDefID, ast),
        );

        const returnExpression: Expression = genReturnExpression(0, fnParams, v, stateVarType, ast);

        const getterBlock = new Block(ast.reserveId(), '', 'Block', [
          new Return(ast.reserveId(), '', 'Return', returnParameterList.id, returnExpression),
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
          fnParams,
          returnParameterList,
          [],
          undefined,
          getterBlock,
        );
        node.appendChild(getter);
        ast.registerChild(getter, node);
      }
    });
  }
}
