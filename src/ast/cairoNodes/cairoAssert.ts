import { ASTNode, Expression } from 'solc-typed-ast';
import CairoASTNode from './cairoASTNode';

export class CairoAssert extends CairoASTNode {
  name: string;

  leftHandSide: Expression;

  rightHandSide: Expression;

  assertEq: boolean;

  constructor(
    id: number,
    src: string,
    type: string,
    leftHandSide: Expression,
    rightHandSide: Expression,
    assertEq = true,
  ) {
    super(id, src, type);
    this.name = 'assert';
    this.leftHandSide = leftHandSide;
    this.rightHandSide = rightHandSide;
    this.assertEq = assertEq;

    this.acceptChildren();
  }

  get children(): readonly ASTNode[] {
    return this.pickNodes(this.leftHandSide, this.rightHandSide);
  }
}
