import { ASTNode, Expression } from 'solc-typed-ast';
import CairoASTNode from './cairoASTNode';

export default class CairoAssert extends CairoASTNode {
  name: string;

  leftHandSide: Expression;

  rightHandSide: Expression;

  assertEq: boolean;

  constructor(id, src, type, leftHandSide: Expression, rightHandSide: Expression, assertEq = true) {
    super(id, src, type);
    this.name = 'assert';
    this.leftHandSide = leftHandSide;
    this.rightHandSide = rightHandSide;
    this.assertEq = assertEq;
  }

  get children(): readonly ASTNode[] {
    return this.pickNodes(this.leftHandSide, this.rightHandSide);
  }
}
