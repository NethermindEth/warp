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
  ASTContext,
} from 'solc-typed-ast';
import assert from 'assert';
import { getErrorMessage, WillNotSupportError } from '../utils/errors';

const binaryOps: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };

class YulVerifier {
  errors: string[] = [];

  verifyNode(node: YulNode) {
    const methodName = `check${node.nodeType}`;
    if (!(methodName in YulTransformer.prototype))
      this.errors.push(`${node.nodeType} is not supported`);
    const method = this[methodName as keyof YulVerifier] as (node: YulNode) => void;
    if (method !== undefined) return method.bind(this)(node);
  }
  checkYulAssignment(node: YulNode) {
    this.verifyNode(node.value);
  }

  checkYulFunctionCall(node: YulNode) {
    if (binaryOps[node.functionName.name] === undefined)
      this.errors.push(`${node.functionName.name} is not supported`);
    node.arguments.forEach((arg: YulNode) => this.verifyNode(arg));
  }
}

class YulTransformer {
  vars: Map<string, VariableDeclaration>;
  ast: AST;

  constructor(ast: AST, externalReferences: any[], context: ASTContext) {
    this.ast = ast;
    const blockRefIds = externalReferences.map((ref) => ref.declaration);
    const blockRefs = [...context.map].filter(([id, _]) =>
      blockRefIds.includes(id),
    ) as [number, VariableDeclaration][];
    this.vars = new Map(blockRefs.map(([_, ref]) => [ref.name, ref]));
  }

  toSolidityStatement(node: YulNode): Statement {
    return this.toSolidityNode(node);
  }

  toSolidityExpr(node: YulNode, ...args: unknown[]): Expression {
    return this.toSolidityNode(node, ...args) as Expression;
  }

  toSolidityNode(node: YulNode, ...args: unknown[]): ASTNode {
    const methodName = `transform${node.nodeType}`;
    const method = this[methodName as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node, ...(args as []));
  }

  transformYulLiteral(node: YulNode): Literal {
    return createNumberLiteral(node.value, this.ast);
  }

  transformYulIdentifier(node: YulNode): Identifier {
    const variableDeclaration = this.vars.get(node.name);
    assert(variableDeclaration !== undefined, `Variable ${node.name} not found.`);
    return createIdentifier(variableDeclaration, this.ast);
  }

  transformYulFunctionCall(node: YulNode, typeString: string): BinaryOperation {
    const leftExpr = this.toSolidityExpr(node.arguments[0]);
    const rightExpr = this.toSolidityExpr(node.arguments[1]);
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

  transformYulAssignment(node: YulNode): ExpressionStatement {
    let lhs: Expression;
    if (node.variableNames.length === 1) {
      lhs = this.transformYulIdentifier(node.variableNames[0]);
    } else {
      lhs = createTuple(
        this.ast,
        node.variableNames.map((i: YulNode) => this.transformYulIdentifier(i)),
      );
    }
    const rhs = this.toSolidityExpr(node.value, lhs.typeString);

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
  yul(node: InlineAssembly): YulNode{
    assert(node.yul !== undefined, 'Attribute yul of the InlineAssembly node is undefined');
    return node.yul;
  }

  verify(node: InlineAssembly, ast: AST): void {
    const verifier = new YulVerifier();
    this.yul(node).statements.map((yul: YulNode) => verifier.verifyNode(yul));

    if (verifier.errors.length === 0)
      return;

    const unsupportedPerSource = new Map<string, [string, InlineAssembly][]>();
    const errorsWithNode: [string, InlineAssembly][] = verifier.errors.map((msg) => [msg, node]);
    unsupportedPerSource.set(ast.getContainingRoot(node).absolutePath, errorsWithNode);
    const errorMsg = getErrorMessage(
      unsupportedPerSource,
      `Detected ${verifier.errors.length} Unsupported Features:`,
    );
    throw new WillNotSupportError(errorMsg, undefined, false);
  }

  transform(node: InlineAssembly, ast: AST): void {
    assert(node.context !== undefined, `Assembly root context not found.`);
    const transformer = new YulTransformer(ast, node.externalReferences, node.context);
    const statements = this.yul(node).statements.map((yul: YulNode) => {
      const astNode = transformer.toSolidityStatement(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    const block: Block = new UncheckedBlock(ast.reserveId(),this.yul(node).src, statements);

    ast.replaceNode(node, block);
  }

  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    this.verify(node, ast);
    this.transform(node, ast);

    return this.visitStatement(node, ast);
  }
}
