import assert = require('assert');
import { ASTReader, compileSol } from 'solc-typed-ast';
import { AST } from './ast/ast';

export function compileSolFile(file: string): AST[] {
  const result = compileSol(file, 'auto', []);
  const reader = new ASTReader();
  const sourceUnits = reader.read(result.data);
  const compilerVersion = result.compilerVersion;
  assert(compilerVersion !== undefined, 'compileSol should return a defined compiler version');
  // Reverse the list so that each AST can only depend on ASTs earlier in the list
  return sourceUnits.map((node) => new AST(node, compilerVersion)).reverse();
}
