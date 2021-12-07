import {
  UserDefinedType,
  IntType,
  ArrayType,
  BoolType,
  BytesType,
  StringType,
  AddressType,
  BuiltinType,
  MappingType,
  FunctionType,
  TypeNode,
  BuiltinStructType,
  getNodeType,
  Expression,
  VariableDeclaration,
  PointerType,
  EnumDefinition,
  ContractDefinition,
} from 'solc-typed-ast';
import {canonicalMangler} from './utils/utils';

export function getCairoType(node: Expression | VariableDeclaration, compilerVersion: string) {
  return cairoType(getNodeType(node, compilerVersion));
}
export function cairoType(tp: TypeNode): string {
  if (tp instanceof IntType) {
    return tp.nBits > 251 ? "Uint256" : "felt";
  } else if (tp instanceof ArrayType) {
    return `${cairoType(tp.elementT)}*`;
  } else if (tp instanceof BoolType) {
    return `felt`;
  } else if (tp instanceof BytesType) {
    return `felt*`;
  } else if (tp instanceof StringType) {
    return `felt`;
  } else if (tp instanceof AddressType) {
    return `felt`;
  } else if (tp instanceof BuiltinType) {
    return canonicalMangler(tp.name);
  } else if (tp instanceof BuiltinStructType) {
    return canonicalMangler(tp.name);
  } else if (tp instanceof MappingType) {
    return `${cairoType(tp.keyType)} => ${cairoType(tp.valueType)}`;
  } else if (tp instanceof UserDefinedType) {
    if (tp.definition instanceof EnumDefinition) {
      return "felt";
    }
    if (tp.definition instanceof ContractDefinition) {
      // This should be an address
      return `felt`;
    }
    return canonicalMangler(tp.name);
  } else if (tp instanceof FunctionType) {
    return `felt*`;
  } else if (tp instanceof PointerType) {
    return cairoType(tp.to)
  } else {
    console.log(tp)
    throw new Error(`Don't know how to convert type ${JSON.stringify(tp.constructor.name)}`)
  }
}
