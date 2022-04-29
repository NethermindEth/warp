import { ASTMapper } from '../../ast/mapper';

import {
  ArrayTypeName,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  IndexAccess,
  Identifier,
  Mapping,
  MemberAccess,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  StructDefinition,
  TypeName,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { cloneASTNode } from '../../utils/cloning';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
} from '../../utils/nodeTemplates';
import { toSingleExpression } from '../../utils/utils';

/**
* This is a pass to attach the getter function for a public state variable
* to the contract definition. for eg,

  contract A{
    uint public a;
  }

* The getter function for a public state variable will be attached to the contract
* definition as

  function a() public view returns (uint) {
    return a;
  }
* This is a getter function for a public state variable

* `for more information: https://docs.soliditylang.org/en/v0.8.13/contracts.html?highlight=getter#getter-functions
*/

export class GettersGenerator extends ASTMapper {
  constructor(private getterFunctions: Map<VariableDeclaration, FunctionDefinition>) {
    super();
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    node.vStateVariables.forEach((v) => {
      // for every public state variable, create a getter function
      const stateVarType = v.vType;

      if (!stateVarType) {
        // skip getter function generation for state variable
        return;
      }

      if (v.stateVariable && v.visibility === StateVariableVisibility.Public) {
        const funcDefID = ast.reserveId();

        const returnParameterList: ParameterList = createParameterList(
          genReturnParameters(stateVarType, funcDefID, ast),
          ast,
        );

        const fnParams: ParameterList = createParameterList(
          genFunctionParams(0, stateVarType, funcDefID, ast),
          ast,
        );

        const returnExpression: Expression = genReturnExpression(0, fnParams, v, stateVarType, ast);

        const getterBlock = createBlock(
          [createReturn(returnExpression, returnParameterList.id, ast)],
          ast,
        );

        const getter = new FunctionDefinition(
          funcDefID,
          '',
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
        this.getterFunctions.set(v, getter);
        node.appendChild(getter);
        ast.registerChild(getter, node);
      }
    });
  }
}

function genReturnParameters(
  vType: TypeName | undefined,
  funcDefID: number,
  ast: AST,
): VariableDeclaration[] {
  // It is an utility function to generate the return parameters
  // for a getter function corresponding to a public state variable
  if (!vType) return [];
  const newVarDecl = (type: TypeName | undefined, dataLocation = DataLocation.Default) => {
    if (!type) {
      throw new TranspileFailedError(`Type not defined for variable`);
    }
    return new VariableDeclaration(
      ast.reserveId(),
      '',
      false,
      false,
      '',
      funcDefID,
      false,
      dataLocation,
      StateVariableVisibility.Internal,
      Mutability.Mutable,
      type.typeString,
      undefined,
      cloneASTNode(type, ast),
    );
  };
  if (vType instanceof ElementaryTypeName) {
    return [newVarDecl(vType)];
  } else if (vType instanceof ArrayTypeName) {
    return genReturnParameters(vType.vBaseType, funcDefID, ast);
  } else if (vType instanceof Mapping) {
    return genReturnParameters(vType.vValueType, funcDefID, ast);
  } else if (vType instanceof UserDefinedTypeName) {
    if (vType.vReferencedDeclaration instanceof StructDefinition) {
      // if the type is a struct, return the list for member declarations
      const returnVariables: VariableDeclaration[] = [];
      // Mappings and arrays are omitted
      vType.vReferencedDeclaration.vMembers.forEach((v) => {
        if (v.vType instanceof Mapping || v.vType instanceof ArrayTypeName) return;
        returnVariables.push(
          newVarDecl(
            v.vType,
            v.vType instanceof UserDefinedTypeName &&
              v.vType.vReferencedDeclaration instanceof StructDefinition
              ? DataLocation.Memory
              : DataLocation.Default,
          ),
        );
      });
      return returnVariables;
    } else {
      return [newVarDecl(vType)];
    }
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
    The return list would be (uint _i0, address _i1)
  */
  if (!vType || vType instanceof ElementaryTypeName) {
    return [];
  } else if (vType instanceof ArrayTypeName) {
    return [
      new VariableDeclaration(
        ast.reserveId(),
        '',
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
        new ElementaryTypeName(ast.reserveId(), '', 'uint256', 'uint256'),
      ),
      ...genFunctionParams(varCount + 1, vType.vBaseType, funcDefID, ast),
    ];
  } else if (vType instanceof Mapping) {
    return [
      new VariableDeclaration(
        ast.reserveId(),
        '',
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
  const createIdentifierBase = (): Identifier => {
    const node = new Identifier(ast.reserveId(), '', getTypeString(v.vType), v.name, v.id);
    ast.setContextRecursive(node);
    return node;
  };
  if (!vType) {
    throw new TranspileFailedError(`Type of ${v.name} must be defined`);
  }
  if (vType instanceof ElementaryTypeName) {
    return baseExpression ?? createIdentifier(v, ast);
  } else if (vType instanceof ArrayTypeName) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      getTypeString(vType.vBaseType),
      baseExpression ?? createIdentifierBase(),
      createIdentifier(fnParams.vParameters[idx], ast),
    );
    return genReturnExpression(idx + 1, fnParams, v, vType.vBaseType, ast, baseExp);
  } else if (vType instanceof Mapping) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      getTypeString(vType.vValueType),
      baseExpression ?? createIdentifierBase(),
      createIdentifier(fnParams.vParameters[idx], ast),
    );
    return genReturnExpression(idx + 1, fnParams, v, vType.vValueType, ast, baseExp);
  } else if (vType instanceof UserDefinedTypeName) {
    if (vType.vReferencedDeclaration instanceof StructDefinition) {
      // list of return expressions for a struct output
      const returnExpressions: Expression[] = [];
      vType.vReferencedDeclaration.vMembers.forEach((m) => {
        if (!m.vType) return;
        // Solidity doesn't allow recursive types for public state variables
        // So, Any nested struct definition can not have member of type
        // other than ElementaryTypeName
        if (m.vType instanceof Mapping || m.vType instanceof ArrayTypeName) {
          return;
        }
        const memberAccessExp: MemberAccess = new MemberAccess(
          ast.reserveId(),
          '',
          getTypeString(m.vType),
          baseExpression ?? createIdentifierBase(),
          m.name,
          m.id,
        );
        returnExpressions.push(memberAccessExp);
      });
      return toSingleExpression(returnExpressions, ast);
    }
    return baseExpression ?? createIdentifierBase();
  } else {
    throw new NotSupportedYetError(
      `Getter fn generation for ${vType?.type} typenames not implemented yet`,
    );
  }
}

function getTypeString(type: TypeName | undefined): string {
  if (!type) return '';
  if (type instanceof ElementaryTypeName) {
    return type.typeString;
  }
  if (type instanceof ArrayTypeName) {
    const baseTypeString = getTypeString(type.vBaseType);
    // extract the string after last '[' and before last ']'
    const lengthString = type.typeString.substring(
      type.typeString.lastIndexOf('[') + 1,
      type.typeString.lastIndexOf(']'),
    );
    return `${baseTypeString}[${lengthString}] storage ref`;
  }

  if (type instanceof Mapping) {
    const keyTypeString = getTypeString(type.vKeyType);
    const valueTypeString = getTypeString(type.vValueType);
    return `mapping(${keyTypeString} => ${valueTypeString})`;
  }

  if (type instanceof UserDefinedTypeName) {
    if (type.vReferencedDeclaration instanceof StructDefinition) {
      return `${type.typeString} storage ref`;
    }
  }
  return type.typeString;
}
