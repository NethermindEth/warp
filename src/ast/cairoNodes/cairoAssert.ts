import { ASTNode, Expression } from 'solc-typed-ast';

/*
 Represents solidity asserts, requires, and reverts
 Does nothing if its child expression is true, aborts execution if not
 Transpiled as `assert vExpression = 1`
*/

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
