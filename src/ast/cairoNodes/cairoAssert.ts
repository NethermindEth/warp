import { ASTNode, Expression } from 'solc-typed-ast';

export class CairoAssert extends Expression {
  assertMessage: string | null;

  vExpression: Expression;

  constructor(
    id: number,
    src: string,
    expression: Expression,
    assertMessage: string | null = null,
    raw?: unknown,
  ) {
    super(id, src, 'tuple()', raw);
    this.vExpression = expression;
    this.assertMessage = assertMessage;

    this.acceptChildren();
  }

  get children(): readonly ASTNode[] {
    return this.pickNodes(this.vExpression);
  }
}
