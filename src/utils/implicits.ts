import { Imports } from '../ast/visitor';

export type Implicits =
  | 'bitwise_ptr'
  | 'dict_ptr'
  | 'pedersen_ptr'
  | 'range_check_ptr'
  | 'syscall_ptr';

export const implicitTypes: { [key in Implicits]: string } = {
  bitwise_ptr: 'BitwiseBuiltin*',
  dict_ptr: 'DictAccess*',
  pedersen_ptr: 'HashBuiltin*',
  range_check_ptr: 'felt',
  syscall_ptr: 'felt*',
};

export const implicitImports: { [key in Implicits]: Imports } = {
  bitwise_ptr: { HashBuiltin: new Set(['starkware.cairo.common.cairo_builtins']) },
  dict_ptr: { DictAccess: new Set(['starkware.cairo.common.dict_access']) },
  pedersen_ptr: { HashBuiltin: new Set(['starkware.cairo.common.cairo_builtins']) },
  range_check_ptr: {},
  syscall_ptr: {},
};

export function writeImplicits(implicits: Set<Implicits>): string {
  return [...implicits]
    .sort()
    .map((implicit) => `${implicit} : ${implicitTypes[implicit]}`)
    .join(', ');
}
