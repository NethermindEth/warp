import { ASTNode, Block, ForStatement } from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class ForLoopSimplifier extends ASTMapper {
  visitForStatement(node: ForStatement): ASTNode {
    return new Block(
      this.genId(),
      node.src,
      'Block',
      [
        node?.vInitializationExpression,
        new ForStatement(
          this.genId(),
          node.src,
          node.type,
          new Block(this.genId(), node.src, 'Block', [node.vBody, node.vLoopExpression]),
          null,
          node.vCondition,
        ),
      ],
      node?.documentation,
      node?.raw,
    );
  }

  getPassName(): string {
    return 'For Loop Simplifier';
  }
}
