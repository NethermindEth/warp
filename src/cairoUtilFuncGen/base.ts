import { AST } from '../ast/ast';

export type CairoFunction = {
  name: string;
  code: string;
};

export abstract class CairoUtilFuncGenBase {
  protected ast: AST;
  protected imports: Map<string, Set<string>> = new Map();

  constructor(ast: AST) {
    this.ast = ast;
  }

  // import file -> import symbols
  getImports(): Map<string, Set<string>> {
    return this.imports;
  }

  // Concatenate all the generated cairo code into a single string
  abstract getGeneratedCode(): string;

  protected requireImport(location: string, name: string): void {
    const existingImports = this.imports.get(location) ?? new Set<string>();
    existingImports.add(name);
    this.imports.set(location, existingImports);
  }
}

export function add(base: string, offset: number): string {
  return offset === 0 ? base : `${base} + ${offset}`;
}
