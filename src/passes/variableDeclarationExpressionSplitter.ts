import {
  ASTNode,
  FunctionCall,
  TupleExpression,
  VariableDeclarationStatement,
  Block,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class VariableDeclarationExpressionSplitter extends ASTMapper {
  visitBlock(node: Block): ASTNode {
    const statements = node.vStatements
      .map((value) =>
        value instanceof VariableDeclarationStatement ? splitDeclaration(value) : value,
      )
      .flat();
    return new Block(this.genId(), node.src, node.type, statements, node.documentation, node.raw);
  }
}
function splitDeclaration(node: VariableDeclarationStatement): VariableDeclarationStatement[] {
  if (node.vDeclarations.length === 1) {
    return [node];
  }

  switch (node.vInitialValue.constructor) {
    case FunctionCall:
      return [node];
    case TupleExpression:
      return node.vDeclarations.map(
        (v, i) =>
          new VariableDeclarationStatement(
            v.id,
            v.src,
            v.type,
            [v.id],
            [v],
            (node.vInitialValue as TupleExpression).vComponents[i],
            node.documentation,
            node.raw,
          ),
      );
    default:
      throw new Error(`Don't know how to destructure ${node.type}`);
  }
}
