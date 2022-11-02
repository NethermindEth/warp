import { ASTMapper } from '../ast/mapper';
import { AST } from '../ast/ast';

import {
  InlineAssembly,
  YulNode,
  Identifier,
  ASTNode,
  BinaryOperation,
  Assignment,
  Block,
  Expression,
  ExpressionStatement,
} from 'solc-typed-ast';

class YulTransformer {
  references: { [name: string]: number };
  ast: AST;

  constructor(ast: AST, externalReferences: any[], contextMap: Map<number, ASTNode>) {
    this.ast = ast;
    const blockRefIds = externalReferences.map((ref) => ref.declaration);
    const blockRefs: [number, ASTNode][] = [...contextMap].filter(([id, _]) =>
      blockRefIds.includes(id),
    );
    this.references = Object.fromEntries(
      blockRefs.map(([id, ref]) => [(ref as Identifier).name, id]),
    );
  }

  run(node: YulNode): ASTNode {
    const method = this[node.nodeType as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node);
  }

  YulIdentifier(node: YulNode): Identifier {
    return new Identifier(
      this.ast.reserveId(),
      node.src,
      'uint256',
      node.name,
      this.references[node.name],
      node.raw,
    );
  }

  YulFunctionCall(node: YulNode): BinaryOperation {
    const binary_ops: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };
    const identifier: Identifier = this.YulIdentifier(node.functionName);
    if (Object.keys(binary_ops).includes(identifier.name)) {
      const leftExpr = this.run(node.arguments[0]) as Expression;
      const rightExpr = this.run(node.arguments[1]) as Expression;
      return new BinaryOperation(
        this.ast.reserveId(),
        node.src,
        'uint256',
        binary_ops[identifier.name],
        leftExpr,
        rightExpr,
        node,
      );
    }
    throw 'Only binary operations are supported';
  }

  YulAssignment(node: YulNode): ExpressionStatement {
    const vars = node.variableNames.map((i: YulNode) => this.YulIdentifier(i));
    const value = this.run(node.value) as Expression;
    const assignment = new Assignment(
      this.ast.reserveId(),
      node.src,
      'uint256',
      '=',
      vars,
      value,
      node,
    );
    return new ExpressionStatement(
      this.ast.reserveId(),
      node.src,
      assignment as Expression,
      undefined,
      node,
    );
  }
}

export class InlineAssemblyTransformer extends ASTMapper {
  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    let transformer = new YulTransformer(ast, node.externalReferences, node.context!.map);
    const statements = node.yul!.statements.map((yul: YulNode) => {
      let astNode = transformer.run(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    let block: Block = new Block(node.id, node.yul!.src, statements);

    ast.replaceNode(node, block);

    return this.visitStatement(node, ast);
  }
}
