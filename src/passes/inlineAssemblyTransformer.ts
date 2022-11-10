import { ASTMapper } from '../ast/mapper';
import { AST } from '../ast/ast';
import {
  createExpressionStatement,
  createIdentifier,
  createNumberLiteral,
  createTuple,
} from '../utils/nodeTemplates';

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
  VariableDeclaration,
  UncheckedBlock,
  Literal,
} from 'solc-typed-ast';
import assert from 'assert';
import { WillNotSupportError } from '../export';

class YulTransformer {
  vars: { [name: string]: VariableDeclaration };
  assemblyRoot: InlineAssembly;
  ast: AST;

  constructor(ast: AST, assemblyRoot: InlineAssembly) {
    this.ast = ast;
    this.assemblyRoot = assemblyRoot;
    const blockRefIds = assemblyRoot.externalReferences.map((ref) => ref.declaration);
    const blockRefs = [...assemblyRoot.context!.map].filter(([id, _]) =>
      blockRefIds.includes(id),
    ) as [number, VariableDeclaration][];
    this.vars = Object.fromEntries(blockRefs.map(([id, ref]) => [ref.name, ref]));
  }

  run(node: YulNode): ASTNode {
    const methodName = `create${node.nodeType}`;
    if (!(methodName in this))
      throw new WillNotSupportError(`${node.nodeType} is not supported`, this.assemblyRoot, false);
    const method = this[methodName as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node);
  }

  createYulLiteral(node: YulNode): Literal {
    return createNumberLiteral(node.value, this.ast);
  }

  createYulIdentifier(node: YulNode): Identifier {
    return createIdentifier(this.vars[node.name], this.ast);
  }

  createYulFunctionCall(node: YulNode): BinaryOperation {
    const binaryOps: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };
    if (Object.keys(binaryOps).includes(node.functionName.name)) {
      const leftExpr = this.run(node.arguments[0]) as Expression;
      const rightExpr = this.run(node.arguments[1]) as Expression;
      return new BinaryOperation(
        this.ast.reserveId(),
        node.src,
        leftExpr.typeString,
        binaryOps[node.functionName.name],
        leftExpr,
        rightExpr,
        node,
      );
    }
    throw new WillNotSupportError(
      `${node.functionName.name} is not supported`,
      this.assemblyRoot,
      false,
    );
  }

  createYulAssignment(node: YulNode): ExpressionStatement {
    let lhs: Expression;
    const rhs = this.run(node.value) as Expression;
    if (rhs.typeString === 'tuple()') {
      lhs = createTuple(
        this.ast,
        node.variableNames.map((i: YulNode) => this.createYulIdentifier(i)),
      );
    } else {
      assert(
        node.variableNames.length === 1,
        'Type mismatch. Tried to assign non-tuple expression to multiple identifiers',
      );
      lhs = this.createYulIdentifier(node.variableNames[0]);
    }

    const assignment = new Assignment(
      this.ast.reserveId(),
      node.src,
      lhs.typeString,
      '=',
      lhs,
      rhs,
      node,
    );
    return createExpressionStatement(this.ast, assignment);
  }
}

export class InlineAssemblyTransformer extends ASTMapper {
  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    const transformer = new YulTransformer(ast, node);
    const statements = node.yul!.statements.map((yul: YulNode) => {
      const astNode = transformer.run(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    const block: Block = new UncheckedBlock(ast.reserveId(), node.yul!.src, statements);

    ast.replaceNode(node, block);

    return this.visitStatement(node, ast);
  }
}
