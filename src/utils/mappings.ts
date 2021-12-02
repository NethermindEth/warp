import { MappingType, TypeName } from 'solc-typed-ast';

export function getMappingTypes(v: MappingType): TypeName[] {
  let types = [];
  types.push(v.keyType);
  if (v.valueType instanceof MappingType) {
    types = getMappingTypes(v.valueType);
  } else {
    types.push(v.valueType);
  }
  return types;
}
