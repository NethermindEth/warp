import {
  Assignment,
  ASTNode,
  BinaryOperation,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { compareTypeSize } from '../utils/utils';

export class ImplicitConversionToExplicit extends ASTMapper {
  generateExplicitConversion(typeTo: string, expression: Expression): FunctionCall {
    return new FunctionCall(
      this.genId(),
      expression.src,
      'FunctionCall',
      typeTo,
      FunctionCallKind.TypeConversion,
      new ElementaryTypeNameExpression(
        this.genId(),
        expression.src,
        'ElementaryTypeNameExpression',
        `type(${typeTo})`,
        new ElementaryTypeName(this.genId(), expression.src, 'ElementaryTypeName', typeTo, typeTo),
      ),
      [expression],
    );
  }

  visitBinaryOperation(node: BinaryOperation): ASTNode {
    const args = [
      this.visit(node.vLeftExpression),
      this.visit(node.vRightExpression),
    ] as Expression[];

    const argTypes = args.map((v) => getNodeType(v, this.compilerVersion));
    const res = compareTypeSize(argTypes[0], argTypes[1]);

    if (res === -1) {
      args[0] = this.generateExplicitConversion(argTypes[1].pp(), args[0] as Expression);
    } else if (res === 1) {
      args[1] = this.generateExplicitConversion(argTypes[0].pp(), args[1] as Expression);
    }

    const ret = new BinaryOperation(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      node.operator,
      args[0],
      args[1],
      node.raw,
    );
    return ret;
  }

  visitAssignment(node: Assignment): ASTNode {
    const children = [
      this.visit(node.vLeftHandSide),
      this.visit(node.vRightHandSide),
    ] as Expression[];

    const childrenTypes = children.map((v) => getNodeType(v, this.compilerVersion));
    const res = compareTypeSize(childrenTypes[0], childrenTypes[1]);

    return new Assignment(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      node.operator,
      children[0],
      res === 0 ? children[1] : this.generateExplicitConversion(childrenTypes[0].pp(), children[1]),
    );
  }

  visitVariableDeclarationStatement(node: VariableDeclarationStatement): ASTNode {
    // Assuming all variable declaratoins are split and have an initial value
    const visitedValue = this.visit(node.vInitialValue) as Expression;
    const childrenTypes = [
      getNodeType(node.vDeclarations[0], this.compilerVersion),
      getNodeType(visitedValue, this.compilerVersion),
    ];
    const res = compareTypeSize(childrenTypes[0], childrenTypes[1]);

    return new VariableDeclarationStatement(
      this.genId(),
      node.src,
      node.type,
      node.assignments,
      this.visitList(node.vDeclarations) as VariableDeclaration[],
      res === 0
        ? visitedValue
        : this.generateExplicitConversion(childrenTypes[0].pp(), visitedValue),
    );
  }
}
