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
import { getErrorMessage, WillNotSupportError } from '../utils/errors';

const binaryOps: { [name: string]: string } = { add: '+', mul: '*', div: '/', sub: '-' };

function generateTransformerName(nodeType: string) {
  return `transform${nodeType}`;
}

class YulVerifier {
  errors: string[] = [];

  verifyNode(node: YulNode) {
    const methodName = generateTransformerName(node.nodeType);
    if (!(methodName in YulTransformer.prototype))
      this.errors.push(`${node.nodeType} is not supported`);
    const method = this[methodName as keyof YulVerifier] as (node: YulNode) => void;
    if (method !== undefined) return method.bind(this)(node);
  }
  createYulAssignment(node: YulNode) {
    this.verifyNode(node.value);
  }

  createYulFunctionCall(node: YulNode) {
    if (binaryOps[node.functionName.name] === undefined)
      this.errors.push(`${node.functionName.name} is not supported`);
    node.arguments.forEach((arg: YulNode) => this.verifyNode(arg));
  }
}

class YulTransformer {
  vars: Map<string, VariableDeclaration>;
  ast: AST;

  constructor(ast: AST, assemblyRoot: InlineAssembly) {
    this.ast = ast;
    const blockRefIds = assemblyRoot.externalReferences.map((ref) => ref.declaration);
    assert(assemblyRoot.context !== undefined, `Assembly root context not found.`);
    const blockRefs = [...assemblyRoot.context.map].filter(([id, _]) =>
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
    const methodName = generateTransformerName(node.nodeType);
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
  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    assert(node.yul !== undefined, 'Attribute yul of the InlineAssembly node is undefined');
    const verifier = new YulVerifier();
    node.yul.statements.map((node: YulNode) => verifier.verifyNode(node));

    if (verifier.errors.length > 0) {
      const unsupportedPerSource = new Map<string, [string, InlineAssembly][]>();
      const errorsWithNode: [string, InlineAssembly][] = verifier.errors.map((msg) => [msg, node]);
      unsupportedPerSource.set(ast.getContainingRoot(node).absolutePath, errorsWithNode);
      const errorMsg = getErrorMessage(
        unsupportedPerSource,
        `Detected ${verifier.errors.length} Unsupported Features:`,
      );
      throw new WillNotSupportError(errorMsg, undefined, false);
    }

    const transformer = new YulTransformer(ast, node);
    const statements = node.yul.statements.map((yul: YulNode) => {
      const astNode = transformer.toSolidityStatement(yul);
      ast.setContextRecursive(astNode);
      return astNode;
    });
    const block: Block = new UncheckedBlock(ast.reserveId(), node.yul.src, statements);

    ast.replaceNode(node, block);

    return this.visitStatement(node, ast);
  }
}
