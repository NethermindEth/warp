import { ASTNode } from 'solc-typed-ast';

export default class CairoASTNode extends ASTNode {
  constructor(id: number, src: string, type: string) {
    super(id, src, type);
  }
}
