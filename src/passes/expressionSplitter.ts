import assert = require('assert');
import {
  ASTNode,
  FunctionDefinition,
  Expression,
  Block,
  FunctionCall,
  VariableDeclarationStatement,
  StateVariableVisibility,
  Mutability,
  VariableDeclaration,
  DataLocation,
  Identifier,
  ExpressionStatement,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { counterGenerator } from '../utils/utils';

function* expressionGenerator(prefix: string): Generator<string, string, unknown> {
  const count = counterGenerator();
  while (true) {
    yield `${prefix}_${count.next().value}`;
  }
}
export class ExpressionSplitter extends ASTMapper {
  eGen = expressionGenerator('__warp_se');
  expressionLifts = [];
  visitBlock(node: Block): ASTNode {
    const oldExpressionLifts = this.expressionLifts;
    const statements = node.vStatements.map((v) => {
      this.expressionLifts = [];
      const v_ = this.visit(v);
      return [...this.expressionLifts, v_];
    });
    this.expressionLifts = oldExpressionLifts;
    return new Block(
      this.genId(),
      node.src,
      node.type,
      statements.flat(),
      node.documentation,
      node.raw,
    );
  }

  visitFunctionCall(node: FunctionCall): ASTNode {
    node.context;
    if (!(node.vReferencedDeclaration instanceof FunctionDefinition)) {
      // @ts-ignore
      return node;
    }
    const args = node.vArguments.map((v) => this.visit(v) as Expression);
    const replacedFunc = new FunctionCall(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      node.kind,
      node.vExpression,
      args,
      node.fieldNames,
      node.raw,
    );
    if (node.parent instanceof ExpressionStatement) {
      return replacedFunc;
    } else {
      const returnTypes = node.vReferencedDeclaration.vReturnParameters.vParameters;
      assert(returnTypes.length === 1);

      const returnType = returnTypes[0].vType;

      const name = this.eGen.next().value;
      const declaration = new VariableDeclarationStatement(
        this.genId(),
        node.src,
        'VariableDeclarationStatement',
        [node.id],
        [
          new VariableDeclaration(
            this.genId(),
            node.src,
            'VariableDeclaration',
            false,
            false,
            name,
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Default,
            Mutability.Mutable,
            node.typeString,
            undefined,
            returnType,
          ),
        ],
        replacedFunc,
      );
      const identifier = new Identifier(
        this.genId(),
        node.src,
        'Identifier',
        node.typeString,
        name,
        declaration.vDeclarations[0].id,
        node.raw,
      );
      this.expressionLifts.push(declaration);
      return identifier;
    }
  }
}
