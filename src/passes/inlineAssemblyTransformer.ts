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
  Statement,
} from 'solc-typed-ast';
import assert from 'assert';
import { WillNotSupportError } from '../utils/errors';

class YulTransformer {
  vars: Map<string, VariableDeclaration>;
  assemblyRoot: InlineAssembly;
  ast: AST;

  constructor(ast: AST, assemblyRoot: InlineAssembly) {
    this.ast = ast;
    this.assemblyRoot = assemblyRoot;
    const blockRefIds = assemblyRoot.externalReferences.map((ref) => ref.declaration);
    const blockRefs = [...assemblyRoot.context!.map].filter(([id, _]) =>
      blockRefIds.includes(id),
    ) as [number, VariableDeclaration][];
    this.vars = new Map(blockRefs.map(([id, ref]) => [ref.name, ref]));
  }

  transformStatement(node: YulNode): Statement {
    return this.transformNode(node);
  }

  transformNode(node: YulNode, ...args: unknown[]): ASTNode {
    const methodName = `create${node.nodeType}`;
    if (!(methodName in this))
      throw new WillNotSupportError(`${node.nodeType} is not supported`, this.assemblyRoot, false);
    const method = this[methodName as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node, ...(args as []));
  }

  createYulLiteral(node: YulNode): Literal {
    return createNumberLiteral(node.value, this.ast);
  }

  createYulIdentifier(node: YulNode): Identifier {
    const variableDeclaration = this.vars.get(node.name);
    assert(variableDeclaration != undefined, `Variable ${node.name} not found.`);
    return createIdentifier(variableDeclaration, this.ast);
  }

  createYulFunctionCall(node: YulNode, typeString: string): BinaryOperation {
    const binaryOps: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };
    if (binaryOps[node.functionName.name] != undefined) {
      const leftExpr = this.transformNode(node.arguments[0]) as Expression;
      const rightExpr = this.transformNode(node.arguments[1]) as Expression;
      return new BinaryOperation(
        this.ast.reserveId(),
        node.src,
        typeString,
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
    if (node.variableNames.length === 1) {
      lhs = this.createYulIdentifier(node.variableNames[0]);
    } else {
      lhs = createTuple(
        this.ast,
        node.variableNames.map((i: YulNode) => this.createYulIdentifier(i)),
      );
    }
    const rhs = this.transformNode(node.value, lhs.typeString) as Expression;

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
    assert(node.yul != undefined, 'Attribute yul of the InlineAssembly node is undefined');

    const transformer = new YulTransformer(ast, node);
    const statements = node.yul.statements.map((yul: YulNode) => {
      const astNode = transformer.transformStatement(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    const block: Block = new UncheckedBlock(ast.reserveId(), node.yul!.src, statements);

    ast.replaceNode(node, block);

    return this.visitStatement(node, ast);
  }
}
