import { Statement, StructuredDocumentation } from 'solc-typed-ast';

export class CairoTempVar extends Statement {
  constructor(
    id: number,
    src: string,
    public name: string,
    documentation?: string | StructuredDocumentation,
    raw?: unknown,
  ) {
    super(id, src, documentation, raw);
  }
}
