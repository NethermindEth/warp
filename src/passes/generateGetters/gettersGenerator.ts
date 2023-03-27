import assert from 'assert';
import { ASTMapper } from '../../ast/mapper';

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
  StateVariableVisibility,
  StructDefinition,
  TypeName,
  UserDefinedTypeName,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';

import { AST } from '../../ast/ast';
import { NotSupportedYetError, TranspileFailedError } from '../../utils/errors';
import { cloneASTNode } from '../../utils/cloning';
import {
  createBlock,
  createIdentifier,
  createParameterList,
  createReturn,
  createUint256TypeName,
} from '../../utils/nodeTemplates';
import { toSingleExpression } from '../../utils/utils';
import { isReferenceType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { locationIfComplexType } from '../../cairoUtilFuncGen/base';

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

        const getterBody = createBlock([], ast);

        const getter = new FunctionDefinition(
          funcDefID,
          '',
          node.id,
          FunctionKind.Function,
          v.name,
          false, // virtual
          FunctionVisibility.Public,
          FunctionStateMutability.View,
          false, // isConstructor
          fnParams,
          returnParameterList,
          [],
          undefined,
          getterBody,
        );

        node.appendChild(getter);

        genReturnBlock(0, getter, getterBody, v, stateVarType, ast);
        ast.setContextRecursive(getter);

        this.getterFunctions.set(v, getter);
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
      false, // constant
      false, // indexed
      '',
      funcDefID,
      false, // stateVariable
      dataLocation,
      StateVariableVisibility.Internal,
      Mutability.Mutable,
      type.typeString,
      undefined,
      cloneASTNode(type, ast),
    );
  };
  if (vType instanceof ElementaryTypeName) {
    if (isReferenceType(safeGetNodeType(vType, ast.inference))) {
      return [newVarDecl(vType, DataLocation.Memory)];
    } else {
      return [newVarDecl(vType)];
    }
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
        const memberTypeName = v.vType;
        assert(
          memberTypeName !== undefined,
          `Missing TypeName for ${v.name} when generating getter`,
        );
        returnVariables.push(
          newVarDecl(
            v.vType,
            isReferenceType(safeGetNodeType(memberTypeName, ast.inference))
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
    This function will return the list of parameters
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
        false, // constant
        false, // indexed
        `_i${varCount}`,
        funcDefID,
        false, // stateVariable
        DataLocation.Default,
        StateVariableVisibility.Internal,
        Mutability.Mutable,
        'uint256',
        undefined,
        createUint256TypeName(ast),
      ),
      ...genFunctionParams(varCount + 1, vType.vBaseType, funcDefID, ast),
    ];
  } else if (vType instanceof Mapping) {
    return [
      new VariableDeclaration(
        ast.reserveId(),
        '',
        false, // constant
        false, // indexed
        `_i${varCount}`,
        funcDefID,
        false, // stateVariable
        locationIfComplexType(safeGetNodeType(vType, ast.inference), DataLocation.Memory),
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

function genReturnBlock(
  idx: number,
  getter: FunctionDefinition,
  getterBody: Block,
  v: VariableDeclaration,
  vType: TypeName | undefined,
  ast: AST,
  baseExpression?: Expression,
): void {
  /*
    This is an recursive function to generate the return 
    Block for a getter function of a public state variable.

    For e.g 

    ```
      struct A{ 
        uint a;
        address b;
        mapping(int => int) c;
      }
      mapping(uint => mapping(address => A[])) public c;
    ```

    The return expression would be a tuple (c[i0][i1][i2].a , c[i0][i1][i2].b)

    `baseExpression`: is the expression that has been generated in 
    the previous call of genReturnBlock
      for e.g `c[i0][i1][i2]` in `c[i0][i1][i2].a`
  */
  if (!vType) {
    throw new TranspileFailedError(`Type of ${v.name} must be defined`);
  }
  if (vType instanceof ElementaryTypeName) {
    getterBody.appendChild(
      createReturn(baseExpression ?? createIdentifier(v, ast), getter.vReturnParameters.id, ast),
    );
  } else if (vType instanceof ArrayTypeName) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      getTypeStringTypeName(vType.vBaseType),
      baseExpression ? cloneASTNode(baseExpression, ast) : createIdentifier(v, ast),
      createIdentifier(getter.vParameters.vParameters[idx], ast),
    );
    return genReturnBlock(idx + 1, getter, getterBody, v, vType.vBaseType, ast, baseExp);
  } else if (vType instanceof Mapping) {
    const baseExp: IndexAccess = new IndexAccess(
      ast.reserveId(),
      '',
      getTypeStringTypeName(vType.vValueType),
      baseExpression ? cloneASTNode(baseExpression, ast) : createIdentifier(v, ast),
      createIdentifier(getter.vParameters.vParameters[idx], ast),
    );
    return genReturnBlock(idx + 1, getter, getterBody, v, vType.vValueType, ast, baseExp);
  } else if (vType instanceof UserDefinedTypeName) {
    if (vType.vReferencedDeclaration instanceof StructDefinition) {
      // list of return expressions for a struct output
      const returnExpressions: Expression[] = [];

      // In case of struct, an extra struct variable declaration is used

      /*
        struct A{uint a;uint b};
        A [] public a;
      `getter fn`:
        function a(uint _i0) ... return(...){
          A _temp = a[_i0];
          return (_temp.a, _temp.b)
        }
      */

      let tempCount = 0;

      const tempStructVarDeclaration = (type: TypeName, initialValue: Expression) => {
        const structVarDecl = new VariableDeclaration(
          ast.reserveId(),
          '',
          false, // constant
          false, // indexed
          `_temp${tempCount++}`,
          getter.id,
          false, // stateVariable
          DataLocation.Storage,
          StateVariableVisibility.Internal,
          Mutability.Mutable,
          type.typeString,
          undefined,
          cloneASTNode(type, ast),
        );

        ast.setContextRecursive(structVarDecl);

        const structDeclStmt = new VariableDeclarationStatement(
          ast.reserveId(),
          '',
          [structVarDecl.id],
          [structVarDecl],
          initialValue,
        );

        getterBody.appendChild(structDeclStmt);
        return structVarDecl;
      };
      const tempStructVarDecl = tempStructVarDeclaration(
        vType,
        baseExpression ? cloneASTNode(baseExpression, ast) : createIdentifier(v, ast),
      );
      vType.vReferencedDeclaration.vMembers.forEach((m) => {
        if (!m.vType) return;

        // struct public state variable getters don't return Mappings and Arrays
        if (m.vType instanceof Mapping || m.vType instanceof ArrayTypeName) {
          return;
        }

        const memberAccessExp: MemberAccess = new MemberAccess(
          ast.reserveId(),
          '',
          getTypeStringTypeName(m.vType),
          createIdentifier(tempStructVarDecl, ast),
          m.name,
          m.id,
        );

        if (
          m.vType instanceof UserDefinedTypeName &&
          m.vType.vReferencedDeclaration instanceof StructDefinition
        ) {
          const memberStructVarDeclaration = tempStructVarDeclaration(m.vType, memberAccessExp);
          returnExpressions.push(createIdentifier(memberStructVarDeclaration, ast));
        } else {
          returnExpressions.push(memberAccessExp);
        }
      });
      getterBody.appendChild(
        createReturn(toSingleExpression(returnExpressions, ast), getter.vReturnParameters.id, ast),
      );
    } else {
      getterBody.appendChild(
        createReturn(baseExpression ?? createIdentifier(v, ast), getter.vReturnParameters.id, ast),
      );
    }
  } else {
    throw new NotSupportedYetError(
      `Getter fn generation for ${vType?.type} typenames not implemented yet`,
    );
  }
}

function getTypeStringTypeName(type: TypeName | undefined): string {
  if (!type) return '';
  if (type instanceof ElementaryTypeName) {
    return type.typeString;
  }
  if (type instanceof ArrayTypeName) {
    const baseTypeString = getTypeStringTypeName(type.vBaseType);
    // extract the string after last '[' and before last ']'
    const lengthString = type.typeString.substring(
      type.typeString.lastIndexOf('[') + 1,
      type.typeString.lastIndexOf(']'),
    );
    return `${baseTypeString}[${lengthString}] storage ref`;
  }

  if (type instanceof Mapping) {
    const keyTypeString = getTypeStringTypeName(type.vKeyType);
    const valueTypeString = getTypeStringTypeName(type.vValueType);
    return `mapping(${keyTypeString} => ${valueTypeString})`;
  }

  if (type instanceof UserDefinedTypeName) {
    if (type.vReferencedDeclaration instanceof StructDefinition) {
      return `${type.typeString} storage ref`;
    }
  }
  return type.typeString;
}
