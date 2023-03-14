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
  FunctionCall,
  FunctionCallKind,
} from 'solc-typed-ast';
import assert from 'assert';
import { getErrorMessage, WillNotSupportError } from '../utils/errors';

/* 
TODO: Research the difference between div, sdiv, mod, smod, shr, sar
One scenario when the result is different:
int8 r;
int8 a = -1;
int8 b = 2;
assembly {
  r := div(a, b)
}

div returns -1 while sdiv returns 0 
*/
const binaryOps: { [name: string]: string } = {
  add: '+',
  mul: '*',
  div: '/',
  sub: '-',
  shr: '>>',
  shl: '<<',
  mod: '%',
  exp: '**',
};
// Consider grouping functions by number of arguments. They probably all use uint256 with the only difference being number of args.
const solidityEquivalents: { [name: string]: string } = {
  addmod: 'function (uint256,uint256,uint256) pure returns (uint256)',
  mulmod: 'function (uint256,uint256,uint256) pure returns (uint256)',
};

function generateTransformerName(nodeType: string) {
  return `transform${nodeType}`;
}

class YulVerifier {
  errors: string[] = [];

  verifyNode(node: YulNode) {
    const transformerName = generateTransformerName(node.nodeType);
    if (!(transformerName in YulTransformer.prototype))
      this.errors.push(`${node.nodeType} is not supported`);

    const verifierName = `check${node.nodeType}`;
    const method = this[verifierName as keyof YulVerifier] as (node: YulNode) => void;
    if (method !== undefined) return method.bind(this)(node);
  }
  checkYulAssignment(node: YulNode) {
    this.verifyNode(node.value);
  }

  checkYulFunctionCall(node: YulNode) {
    if (
      binaryOps[node.functionName.name] === undefined &&
      solidityEquivalents[node.functionName.name] === undefined
    )
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
    const blockRefs = [...context.map].filter(([id, _]) => blockRefIds.includes(id)) as [
      number,
      VariableDeclaration,
    ][];
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

  getBinaryOpsArgs(
    functionName: string,
    functionArguments: [Expression, Expression],
  ): [Expression, Expression] {
    if (functionName === 'shl' || functionName === 'shr') {
      const [right, left] = functionArguments;
      return [left, right];
    }
    return functionArguments;
  }

  transformYulFunctionCall(node: YulNode, typeString: string): BinaryOperation | FunctionCall {
    const args = node.arguments.map((argument: YulNode) =>
      this.toSolidityExpr(argument, typeString),
    );

    if (solidityEquivalents[node.functionName.name] !== undefined) {
      const func = new Identifier(
        this.ast.reserveId(),
        node.src,
        solidityEquivalents[node.functionName.name],
        node.functionName.name,
        -1,
      );
      return new FunctionCall(
        this.ast.reserveId(),
        node.src,
        typeString,
        FunctionCallKind.FunctionCall,
        func,
        args,
      );
    }
    const [leftExpr, rightExpr] = this.getBinaryOpsArgs(node.functionName.name, args);

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
  yul(node: InlineAssembly): YulNode {
    assert(node.yul !== undefined, 'Attribute yul of the InlineAssembly node is undefined');
    return node.yul;
  }

  verify(node: InlineAssembly, ast: AST): void {
    const verifier = new YulVerifier();
    this.yul(node).statements.map((yul: YulNode) => verifier.verifyNode(yul));

    if (verifier.errors.length === 0) return;

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
    const block: Block = new UncheckedBlock(ast.reserveId(), this.yul(node).src, statements);
    ast.replaceNode(node, block);
  }

  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    this.verify(node, ast);
    this.transform(node, ast);

    return this.visitStatement(node, ast);
  }
}
