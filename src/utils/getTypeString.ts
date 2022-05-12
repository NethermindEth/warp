import assert from 'assert';
import {
  AddressType,
  ArrayType,
  BoolType,
  BuiltinStructType,
  BuiltinType,
  BytesType,
  ContractDefinition,
  ContractKind,
  DataLocation,
  EnumDefinition,
  enumToIntType,
  FixedBytesType,
  FunctionDefinition,
  FunctionType,
  FunctionVisibility,
  getNodeType,
  ImportRefType,
  IntLiteralType,
  IntType,
  LiteralKind,
  MappingType,
  ModuleType,
  PointerType,
  StringLiteralType,
  StringType,
  StructDefinition,
  TupleType,
  TypeName,
  typeNameToTypeNode,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { RationalLiteral } from '../passes/literalExpressionEvaluator/rationalLiteral';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';

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

export function getFunctionTypeString(node: FunctionDefinition, compilerVersion: string): string {
  const inputs = node.vParameters.vParameters
    .map((decl) => {
      const baseType = getNodeType(decl, compilerVersion);
      if (
        baseType instanceof ArrayType ||
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
              true,
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

export function getReturnTypeString(node: FunctionDefinition): string {
  const returns = node.vReturnParameters.vParameters;
  if (returns.length === 0) return 'tuple()';
  if (returns.length === 1)
    return `${returns[0].typeString}${
      returns[0].storageLocation === DataLocation.Default ? '' : ` ${returns[0].storageLocation}`
    }`;
  return `tuple(${returns
    .map(
      (decl) =>
        `${decl.typeString}${
          decl.storageLocation === DataLocation.Default ? '' : ` ${decl.storageLocation}`
        }`,
    )
    .join(',')})`;
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
      if (value.length > 32) {
        value = `${value.slice(4)}...(${value.length - 8} digits omitted)...${value.slice(-4)}`;
      }
      return `int_const ${value}`;
    }
  }
}

function instanceOfNonRecursivePP(type: TypeNode): boolean {
  if (
    type instanceof AddressType ||
    type instanceof BoolType ||
    type instanceof BuiltinStructType ||
    type instanceof BuiltinType ||
    type instanceof BytesType ||
    type instanceof FixedBytesType ||
    type instanceof ImportRefType ||
    type instanceof IntLiteralType ||
    type instanceof IntType ||
    type instanceof ModuleType ||
    type instanceof RationalLiteral ||
    type instanceof StringLiteralType ||
    type instanceof StringType
  )
    return true;
  return false;
}

export function generateExpressionTypeString(type: TypeNode): string {
  if (type instanceof PointerType) {
    if (type.to instanceof MappingType) return generateExpressionTypeString(type.to);
    else
      return `${generateExpressionTypeString(type.to)} ${type.location}${
        type.kind !== undefined ? ' ' + type.kind : ''
      }`;
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
  } else if (type instanceof UserDefinedType) {
    if (type.definition instanceof UserDefinedValueTypeDefinition)
      return type.definition.underlyingType.typeString;
    if (type.definition instanceof EnumDefinition) return enumToIntType(type.definition).pp();
    return type.pp();
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
  else throw new TranspileFailedError('Unable to determine typestring');
}

export function generateVariableDeclarationTypeString(tName: TypeName): string {
  const tNode = typeNameToTypeNode(tName);
  return tNode.pp();
}
