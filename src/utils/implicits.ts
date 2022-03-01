import { ASTNode } from 'solc-typed-ast';
import { AST } from '../ast/ast';

export type Implicits =
  | 'bitwise_ptr'
  | 'pedersen_ptr'
  | 'range_check_ptr'
  | 'syscall_ptr'
  | 'warp_memory';
export type CairoBuiltin = 'bitwise' | 'pedersen' | 'range_check';

const implicitsOrder = {
  syscall_ptr: 0,
  pedersen_ptr: 1,
  range_check_ptr: 2,
  bitwise_ptr: 3,
  warp_memory: 4,
};

export function implicitOrdering(a: Implicits, b: Implicits): number {
  return implicitsOrder[a] - implicitsOrder[b];
}

export const implicitTypes: { [key in Implicits]: string } = {
  bitwise_ptr: 'BitwiseBuiltin*',
  pedersen_ptr: 'HashBuiltin*',
  range_check_ptr: 'felt',
  syscall_ptr: 'felt*',
  warp_memory: 'MemCell*',
};

export function registerImportsForImplicit(ast: AST, node: ASTNode, implicit: Implicits) {
  switch (implicit) {
    case 'bitwise_ptr':
      ast.registerImport(node, 'starkware.cairo.common.cairo_builtins', 'BitwiseBuiltin');
      break;
    case 'pedersen_ptr':
      ast.registerImport(node, 'starkware.cairo.common.cairo_builtins', 'HashBuiltin');
      break;
    case 'warp_memory':
      ast.registerImport(node, 'warplib.memory', 'MemCell');
      ast.registerImport(node, 'warplib.memory', 'warp_memory_init');
      break;
  }
}

export const requiredBuiltin: { [key in Implicits]: CairoBuiltin | null } = {
  bitwise_ptr: 'bitwise',
  pedersen_ptr: 'pedersen',
  range_check_ptr: 'range_check',
  syscall_ptr: null,
  warp_memory: null,
};

export function writeImplicits(implicits: Set<Implicits>): string {
  return [...implicits]
    .sort(implicitOrdering)
    .map((implicit) => `${implicit} : ${implicitTypes[implicit]}`)
    .join(', ');
}
