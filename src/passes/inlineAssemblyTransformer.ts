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
// Consider grouping functions by number of arguments. They probbably all use uint256 with the only difference being number of args.
const solidityEquivalents: { [name: string]: string } = {
  addmod: 'function (uint256,uint256,uint256) pure returns (uint256)',
  mulmod: 'function (uint256,uint256,uint256) pure returns (uint256)',
};

function generateTransformerName({ nodeType }: { nodeType: string; }) {
  return `transform${nodeType}`;
}

class YulVerifier {
  errors: string[] = [];

  verifyNode({ node }: { node: YulNode; }) {
    const transformerName = generateTransformerName({ nodeType: node.nodeType });
    if (!(transformerName in YulTransformer.prototype))
      this.errors.push(`${node.nodeType} is not supported`);

    const verifierName = `check${node.nodeType}`;
    const method = this[verifierName as keyof YulVerifier] as (node: YulNode) => void;
    if (method !== undefined) return method.bind(this)(node);
  }
  checkYulAssignment({ node }: { node: YulNode; }) {
    this.verifyNode({ node: node.value });
  }

  checkYulFunctionCall({ node }: { node: YulNode; }) {
    if (
      binaryOps[node.functionName.name] === undefined &&
      solidityEquivalents[node.functionName.name] === undefined
    )
      this.errors.push(`${node.functionName.name} is not supported`);
    node.arguments.forEach((arg: YulNode) => this.verifyNode({ node: arg }));
  }
}

class YulTransformer {
  vars: Map<string, VariableDeclaration>;
  ast: AST;

  constructor({ ast, externalReferences, context }: { ast: AST; externalReferences: any[]; context: ASTContext; }) {
    this.ast = ast;
    const blockRefIds = externalReferences.map((ref) => ref.declaration);
    const blockRefs = [...context.map].filter(([id, _]) => blockRefIds.includes(id)) as [
      number,
      VariableDeclaration,
    ][];
    this.vars = new Map(blockRefs.map(([_, ref]) => [ref.name, ref]));
  }

  toSolidityStatement({ node }: { node: YulNode; }): Statement {
    return this.toSolidityNode({ node });
  }

  toSolidityExpr({ node, args = [] }: { node: YulNode; args?: unknown[]; }): Expression {
    return this.toSolidityNode({ node, args: [...args] }) as Expression;
  }

  toSolidityNode({ node, args = [] }: { node: YulNode; args?: unknown[]; }): ASTNode {
    const methodName = generateTransformerName({ nodeType: node.nodeType });
    const method = this[methodName as keyof YulTransformer] as (node: YulNode) => ASTNode;
    return method.bind(this)(node, ...(args as []));
  }

  transformYulLiteral({ node }: { node: YulNode; }): Literal {
    return createNumberLiteral(node.value, this.ast);
  }

  transformYulIdentifier({ node }: { node: YulNode; }): Identifier {
    const variableDeclaration = this.vars.get(node.name);
    assert(variableDeclaration !== undefined, `Variable ${node.name} not found.`);
    return createIdentifier(variableDeclaration, this.ast);
  }

  getBinaryOpsArgs(
{ functionName, functionArguments }: { functionName: string; functionArguments: [Expression, Expression]; },
  ): [Expression, Expression] {
    if (functionName === 'shl' || functionName === 'shr') {
      const [right, left] = functionArguments;
      return [left, right];
    }
    return functionArguments;
  }

  transformYulFunctionCall({ node, typeString }: { node: YulNode; typeString: string; }): BinaryOperation | FunctionCall {
    const args = node.arguments.map((argument: YulNode) =>
      this.toSolidityExpr({ node: argument, args: [typeString] }),
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
    const [leftExpr, rightExpr] = this.getBinaryOpsArgs({ functionName: node.functionName.name, functionArguments: args });

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

  transformYulAssignment({ node }: { node: YulNode; }): ExpressionStatement {
    let lhs: Expression;
    if (node.variableNames.length === 1) {
      lhs = this.transformYulIdentifier({ node: node.variableNames[0] });
    } else {
      lhs = createTuple(
        this.ast,
        node.variableNames.map((i: YulNode) => this.transformYulIdentifier({ node: i })),
      );
    }
    const rhs = this.toSolidityExpr({ node: node.value, args: [lhs.typeString] });

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
  yul({ node }: { node: InlineAssembly; }): YulNode {
    assert(node.yul !== undefined, 'Attribute yul of the InlineAssembly node is undefined');
    return node.yul;
  }

  verify({ node, ast }: { node: InlineAssembly; ast: AST; }): void {
    const verifier = new YulVerifier();
    this.yul({ node }).statements.map((yul: YulNode) => verifier.verifyNode({ node: yul }));

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

  transform({ node, ast }: { node: InlineAssembly; ast: AST; }): void {
    assert(node.context !== undefined, `Assembly root context not found.`);
    const transformer = new YulTransformer({ ast, externalReferences: node.externalReferences, context: node.context });

    const statements = this.yul({ node }).statements.map((yul: YulNode) => {
      const astNode = transformer.toSolidityStatement({ node: yul });
      ast.setContextRecursive(astNode);
      return astNode;
    });
    const block: Block = new UncheckedBlock(ast.reserveId(), this.yul({ node }).src, statements);
    ast.replaceNode(node, block);
  }

  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    this.verify({ node, ast });
    this.transform({ node, ast });

    return this.visitStatement(node, ast);
  }
}
