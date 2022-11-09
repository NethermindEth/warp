import { ASTMapper } from '../ast/mapper';
import { AST } from '../ast/ast';
import { createExpressionStatement, createIdentifier, createTuple } from '../utils/nodeTemplates';

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
    const blockRefs: [number, ASTNode][] = [...assemblyRoot.context!.map].filter(([id, _]) =>
      blockRefIds.includes(id),
    );
    this.vars = Object.fromEntries(
      blockRefs.map(([id, ref]) => [(ref as Identifier).name, ref as VariableDeclaration]),
    );
  }

  run(node: YulNode): ASTNode {
    if (!(node.nodeType in this))
      throw new WillNotSupportError(`${node.nodeType} is not supported`, this.assemblyRoot, false);
    const method = this[node.nodeType as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node);
  }

  YulIdentifier(node: YulNode): Identifier {
    return createIdentifier(this.vars[node.name], this.ast);
  }

  YulFunctionCall(node: YulNode): BinaryOperation {
    const binary_ops: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };
    if (Object.keys(binary_ops).includes(node.functionName.name)) {
      const leftExpr = this.run(node.arguments[0]) as Expression;
      const rightExpr = this.run(node.arguments[1]) as Expression;
      return new BinaryOperation(
        this.ast.reserveId(),
        node.src,
        leftExpr.typeString,
        binary_ops[node.functionName.name],
        leftExpr,
        rightExpr,
        node,
      );
    }
    throw 'Only binary operations are supported';
  }

  YulAssignment(node: YulNode): ExpressionStatement {
    let vars: Expression;
    const value = this.run(node.value) as Expression;
    if (value.typeString === 'tuple()') {
      vars = createTuple(
        this.ast,
        node.variableNames.map((i: YulNode) => this.YulIdentifier(i)),
      );
    } else {
      assert(
        node.variableNames.length === 1,
        'Type mismatch. Tried to assign non-tuple expression to multiple identifiers',
      );
      vars = this.YulIdentifier(node.variableNames[0]);
    }

    const assignment = new Assignment(
      this.ast.reserveId(),
      node.src,
      vars.typeString,
      '=',
      vars,
      value,
      node,
    );
    return createExpressionStatement(this.ast, assignment);
  }
}

export class InlineAssemblyTransformer extends ASTMapper {
  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    let transformer = new YulTransformer(ast, node);
    const statements = node.yul!.statements.map((yul: YulNode) => {
      let astNode = transformer.run(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    let block: Block = new UncheckedBlock(ast.reserveId(), node.yul!.src, statements);

    ast.replaceNode(node, block);

    return this.visitStatement(node, ast);
  }
}
