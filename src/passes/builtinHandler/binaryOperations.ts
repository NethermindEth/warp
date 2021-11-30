import {
  ASTNode,
  BinaryOperation,
  Expression,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  UncheckedBlock,
} from 'solc-typed-ast';
import { BuiltinMapper } from '../../ast/builtinMapper';
import { primitiveTypeToCairo } from '../../utils/utils';

export class BinaryOperations extends BuiltinMapper {
  builtinDefs = {
    "binaryopFelt": {name: "binaryopFelt", src: "binaryop", args: [
      {name: "arg1", typeString: "felt"},
      {name: "arg2", typeString: "felt"}
    ], returns: [
      {name: "ret", typeString: "felt"},
    ]},
    "binaryopUint256": {name: "binaryopUint256", src: "binaryop", args: [
      {name: "arg1", typeString: "uint256"},
      {name: "arg2", typeString: "uint256"}
    ], returns: [
      {name: "ret", typeString: "uint256"},
    ]},
  }
  inUncheckedBlock: boolean;
  constructor() {
    super();
    this.inUncheckedBlock = false;
  }

  visitUncheckedBlock(node: UncheckedBlock): ASTNode {
    this.inUncheckedBlock = true;
    const block = new UncheckedBlock(
      this.genId(),
      node.src,
      node.type,
      this.visitList(node.vStatements),
      node.documentation,
      node.raw,
    );
    this.inUncheckedBlock = false;
    return block;
  }
  visitBinaryOperation(node: BinaryOperation): ASTNode {

    const cairoType = primitiveTypeToCairo(node.vRightExpression.typeString);
    const isFelt = cairoType === "felt";

    switch (node.operator) {
      case '+':
      case '-':
      case '!=':
      case '==':
      case '=':
        if (isFelt) return node;
      case '/':
      case '>':
      case '<':
      case '>=':
      case '<=':
      case '&&':
      case '||':
      case '^':
        return this.generateCallForOperator(node, cairoType);
      default:
        return node;
    }
  }

  generateCallForOperator(node: BinaryOperation, cairoType: string) {
    const operation = this.binaryOperationBasedOnType(cairoType, node.operator);
    this.addImport({
        [`math.${cairoType.toLowerCase()}`]: new Set([`${operation}`]),
    });

    const args = [node.vLeftExpression, node.vRightExpression].map(v => this.visit(v)) as Expression[];
    const iden = new Identifier(this.genId(), node.src, node.type, node.typeString, operation, this.functionDefReferenceBasedOnType(node.typeString), node.raw);

    return new FunctionCall(this.genId(), node.src, node.type, node.typeString, FunctionCallKind.FunctionCall, iden, args, null, null);
  }

  binaryOperationBasedOnType(typeString: string, operator: string): string {
    const inner = () => {
      const call = infixOperatorToCall[operator];
      switch (typeString) {
        case 'Uint256':
          return `uint256_${call}`;
        case 'felt':
          return call;
        default:
          return `${typeString}_${call}`;
      }
    };
    return this.inUncheckedBlock ? `unsafe_${inner()}` : inner();
  }

  functionDefReferenceBasedOnType(typeString: string) {
    switch(typeString) {
      case "int":
      case "uint":
      case "uint256":
      case "int256":
        return this.getDefId("binaryopUint256");
      default:
        return this.getDefId("binaryopFelt");
    }
  }
}

const infixOperatorToCall = {
  '+': 'add',
  '-': 'sub',
  '/': 'div',
  '==': 'eq',
  '=': '=',
  '<': 'is_lt',
  '>': 'is_gt',
  '<=': 'is_lte',
  '>=': 'is_gte',
  '&&': 'and',
  '||': 'or',
  '^': 'xor',
};
