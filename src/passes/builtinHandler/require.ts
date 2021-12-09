import { ASTNode, Expression, FunctionCall, Literal, LiteralKind } from 'solc-typed-ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';

export class Require extends ASTMapper {
  visitFunctionCall(node: FunctionCall): ASTNode {
    if (node.vIdentifier !== 'require') return node;
    const arg = this.visit(node.vArguments[0]) as Expression;
    const true_ = new Literal(
      this.genId(),
      node.src,
      node.type,
      'bool',
      LiteralKind.Bool,
      '',
      'true',
    );
    return new CairoAssert(this.genId(), node.src, 'CairoAssert', arg, true_, node.raw);
  }
}
