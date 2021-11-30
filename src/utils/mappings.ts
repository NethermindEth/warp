import { Mapping, TypeName } from 'solc-typed-ast';

export function getMappingTypes(v: Mapping): TypeName[] {
  let types = [];
  types.push(v.vKeyType);
  if (v.vValueType instanceof Mapping) {
    types = getMappingTypes(v.vValueType);
  } else {
    types.push(v.vValueType);
  }
  return types;
}
