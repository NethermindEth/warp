import {
  ArrayType,
  FixedBytesType,
  IntType,
  PointerType,
  TupleType,
  FunctionType,
  MappingType,
  TypeNameType,
  TypeNode,
  BytesType,
  StringType,
} from 'solc-typed-ast';

export function replaceBytesType(type: TypeNode): TypeNode {
  if (type instanceof ArrayType) {
    return new ArrayType(replaceBytesType(type.elementT), type.size, type.src);
  } else if (type instanceof FixedBytesType) {
    return new IntType(type.size * 8, false, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(replaceBytesType),
      type.returns.map(replaceBytesType),
      type.visibility,
      type.mutability,
      type.implicitFirstArg,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(
      replaceBytesType(type.keyType),
      replaceBytesType(type.valueType),
      type.src,
    );
  } else if (type instanceof PointerType) {
    return new PointerType(replaceBytesType(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(replaceBytesType), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(replaceBytesType(type.type), type.src);
  } else if (type instanceof BytesType) {
    return new ArrayType(new IntType(8, false, type.src), undefined, type.src);
  } else if (type instanceof StringType) {
    return new ArrayType(new IntType(8, false, type.src), undefined, type.src);
  } else {
    return type;
  }
}
