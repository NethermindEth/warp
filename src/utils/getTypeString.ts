import assert from 'assert';
import {
  AddressType,
  ArrayType,
  ASTNode,
  BoolType,
  BuiltinFunctionType,
  BuiltinStructType,
  BuiltinType,
  BytesType,
  ContractDefinition,
  ContractKind,
  DataLocation,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionDefinition,
  FunctionType,
  FunctionVisibility,
  generalizeType,
  ImportRefType,
  InferType,
  IntLiteralType,
  IntType,
  LiteralKind,
  MappingType,
  PointerType,
  specializeType,
  StringLiteralType,
  StringType,
  StructDefinition,
  TupleExpression,
  TupleType,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { RationalLiteral } from '../passes/literalExpressionEvaluator/rationalLiteral';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';
import { safeGetNodeType, safeGetNodeTypeInCtx } from './nodeTypeProcessing';

export function getDeclaredTypeString(declaration: VariableDeclarationStatement): string {
  if (declaration.assignments.length === 1) {
    return declaration.vDeclarations[0].typeString;
  }

  const assignmentTypes = declaration.assignments.map((id) => {
    if (id === null) return '';

    const variable = declaration.vDeclarations.find((n) => n.id === id);
    assert(
      variable !== undefined,
      `${printNode(declaration)} attempts to assign to id ${id}, which is not in its declarations`,
    );
    return variable.typeString;
  });

  return `tuple(${assignmentTypes.join(',')})`;
}

export function getContractTypeString(node: ContractDefinition): string {
  if (node.kind === ContractKind.Interface) {
    return `type(contract ${node.name})`;
  }
  return `type(${node.kind} ${node.name})`;
}

export function getStructTypeString(node: StructDefinition): string {
  return `struct ${node.name}`;
}

export function getEnumTypeString(node: EnumDefinition): string {
  return `enum ${node.name}`;
}

export function getFunctionTypeString(
  node: FunctionDefinition,
  inference: InferType,
  nodeInSourceUnit?: ASTNode,
): string {
  const inputs = node.vParameters.vParameters
    .map((decl) => {
      const baseType = safeGetNodeTypeInCtx(decl, inference, nodeInSourceUnit ?? decl);
      if (
        baseType instanceof ArrayType ||
        baseType instanceof BytesType ||
        baseType instanceof StringType ||
        (baseType instanceof UserDefinedType && baseType.definition instanceof StructDefinition)
      ) {
        if (decl.storageLocation === DataLocation.Default) {
          if (
            decl.vType instanceof UserDefinedTypeName &&
            (decl.vType.vReferencedDeclaration instanceof EnumDefinition ||
              decl.vType.vReferencedDeclaration instanceof ContractDefinition)
          ) {
            return `${baseType.pp()}`;
          }
          throw new NotSupportedYetError(
            `Default location ref parameter to string not supported yet: ${printTypeNode(
              baseType,
              true, // detail
            )} in ${node.name}`,
          );
        }
        return `${baseType.pp()} ${decl.storageLocation}`;
      }
      return baseType.pp();
    })
    .join(', ');
  const visibility =
    node.visibility === FunctionVisibility.Private || FunctionVisibility.Default
      ? ''
      : ` ${node.visibility}`;
  const outputs =
    node.vReturnParameters.vParameters.length === 0
      ? ''
      : `returns (${node.vReturnParameters.vParameters.map((decl) => decl.typeString).join(', ')})`;
  return `function (${inputs})${visibility} ${node.stateMutability} ${outputs}`;
}

export function getReturnTypeString(
  node: FunctionDefinition,
  ast: AST,
  nodeInSourceUnit?: ASTNode,
): string {
  const retParams = node.vReturnParameters.vParameters;
  const parametersTypeString = retParams
    .map((decl) => {
      const type = safeGetNodeTypeInCtx(decl, ast.inference, nodeInSourceUnit ?? decl);
      return type instanceof PointerType
        ? type
        : specializeType(generalizeType(type)[0], decl.storageLocation);
    })
    .map(generateExpressionTypeString)
    .join(', ');

  if (retParams.length === 1) {
    return parametersTypeString;
  } else {
    return `tuple(${parametersTypeString})`;
  }
}

export function generateLiteralTypeString(
  value: string,
  kind: LiteralKind = LiteralKind.Number,
): string {
  switch (kind) {
    case LiteralKind.Bool:
      return 'bool';
    case LiteralKind.String:
      return `literal_string "${value}"`;
    case LiteralKind.HexString:
      return `literal_string hex"${value}"`;
    case LiteralKind.UnicodeString: {
      const encodedData = Buffer.from(value).toJSON().data;
      const hex_string = encodedData.reduce(
        (acc, val) => acc + (val < 16 ? '0' : '') + val.toString(16),
        '',
      );
      return `literal_string hex"${hex_string}"`;
    }
    case LiteralKind.Number: {
      if (value.startsWith('0x')) {
        // Doesn't seem to have an effect on transpilation, but during tests "AST failed internal consistency check." is reported otherwise (eg. bitwise_shifting_constants_constantinople)
        value = BigInt(value).toString();
      }
      if (value.length > 32) {
        value = `${value.slice(0, 4)}...(${value.length - 8} digits omitted)...${value.slice(-4)}`;
      }
      return `int_const ${value}`;
    }
  }
}

function instanceOfNonRecursivePP(type: TypeNode): boolean {
  return (
    type instanceof AddressType ||
    type instanceof BoolType ||
    type instanceof BuiltinStructType ||
    type instanceof BuiltinType ||
    type instanceof BytesType ||
    type instanceof FixedBytesType ||
    type instanceof ImportRefType ||
    type instanceof IntLiteralType ||
    type instanceof IntType ||
    type instanceof RationalLiteral ||
    type instanceof StringLiteralType ||
    type instanceof StringType ||
    type instanceof UserDefinedType
  );
}

export function generateExpressionTypeStringForASTNode(
  node: Expression,
  type: TypeNode,
  inference: InferType,
): string {
  if (
    type instanceof IntLiteralType ||
    type instanceof StringLiteralType ||
    type instanceof BuiltinFunctionType
  ) {
    return node.typeString;
  }
  if (node instanceof TupleExpression) {
    if (node.isInlineArray === true) {
      const type = safeGetNodeType(node, inference);
      if (type instanceof TupleType) {
        return `${type.elements[0].getFields()[0]} memory`;
      } else if (type instanceof ArrayType || type instanceof PointerType) {
        return generateExpressionTypeString(type);
      }
    }
    if (node.vComponents.length === 0) {
      // E.g. `return abi.decode(data, (address, uint256));`
      assert(type instanceof TupleType);
      return `tuple(${type.elements
        .map((element) => generateExpressionTypeString(element))
        .join(',')})`;
    }
    return `tuple(${node.vComponents
      .map((element) =>
        generateExpressionTypeStringForASTNode(
          element,
          safeGetNodeType(element, inference),
          inference,
        ),
      )
      .join(',')})`;
  }
  return generateExpressionTypeString(type);
}

export function generateExpressionTypeString(type: TypeNode): string {
  if (type instanceof PointerType) {
    if (type.to instanceof MappingType) return generateExpressionTypeString(type.to);
    else
      return `${generateExpressionTypeString(type.to)} 
      ${type.location === DataLocation.Default ? '' : type.location}
      ${type.kind !== undefined ? ' ' + type.kind : ''}`;
  } else if (type instanceof FunctionType) {
    const mapper = (node: TypeNode) => generateExpressionTypeString(node);

    const argStr = type.parameters.map(mapper).join(',');

    let retStr = type.returns.map(mapper).join(',');

    retStr = retStr !== '' ? ` returns (${retStr})` : retStr;

    const visStr = type.visibility !== FunctionVisibility.Internal ? ` ` + type.visibility : '';
    const mutStr = type.mutability !== 'nonpayable' ? ' ' + type.mutability : '';

    return `function ${
      type.name !== undefined ? type.name : ''
    }(${argStr})${mutStr}${visStr}${retStr}`;
  } else if (type instanceof ArrayType) {
    return `${generateExpressionTypeString(type.elementT)}[${
      type.size !== undefined ? type.size : ''
    }]`;
  } else if (type instanceof MappingType) {
    return `mapping(${generateExpressionTypeString(type.keyType)} => ${generateExpressionTypeString(
      type.valueType,
    )})`;
  } else if (type instanceof TupleType) {
    return `tuple(${type.elements
      .map((element) => generateExpressionTypeString(element))
      .join(',')})`;
  } else if (type instanceof TypeNameType) {
    return `type(${generateExpressionTypeString(type.type)})`;
  } else if (instanceOfNonRecursivePP(type)) return type.pp();
  else
    throw new TranspileFailedError(
      `Unable to determine typestring for TypeNode #${type.id} ${type.pp()}`,
    );
}
