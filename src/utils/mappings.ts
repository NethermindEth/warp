import { MappingType, TypeNode } from 'solc-typed-ast';

export function getMappingTypes(v: MappingType): TypeNode[] {
  const isMapping = v.valueType instanceof MappingType;
  return [v.keyType, ...(isMapping ? getMappingTypes(v.valueType) : [v.valueType])];
}
