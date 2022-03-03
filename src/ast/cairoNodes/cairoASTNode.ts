import { ASTNode } from 'solc-typed-ast';

export default class CairoASTNode extends ASTNode {
  constructor(id: number, src: string, type: string, raw?: unknown) {
    super(id, src, type, raw);
  }
}
