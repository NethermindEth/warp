import {
  BinaryOperation,
  FunctionCallKind,
  getNodeType,
  Identifier,
  UncheckedBlock,
  FunctionCall,
} from 'solc-typed-ast';
import { BuiltinMapper } from '../../ast/builtinMapper';
import { compareTypeSize, primitiveTypeToCairo } from '../../utils/utils';
import { AST, Imports } from '../../ast/ast';
import { TranspileFailedError } from '../../utils/errors';

// TODO remake this to respect bit-widths
export class BinaryOperations extends BuiltinMapper {
  builtinDefs = {
    binaryopFelt: this.createBuiltInDef(
      'binaryopFelt',
      [
        ['arg1', 'felt'],
        ['arg2', 'felt'],
      ],
      [['ret', 'felt']],
      // Include both currently because some operations require them
      // This should be made more accurate when BinaryOperations is remade
      ['bitwise_ptr', 'range_check_ptr'],
    ),
    binaryopUint256: this.createBuiltInDef(
      'binaryopUint256',
      [
        ['arg1', 'uint256'],
        ['arg2', 'uint256'],
      ],
      [['ret', 'uint256']],
      ['bitwise_ptr', 'range_check_ptr'],
    ),
  };

  // Unchecked blocks cannot be nested so we only need a boolean
  inUncheckedBlock: boolean;

  constructor() {
    super();
    this.inUncheckedBlock = false;
  }

  visitUncheckedBlock(node: UncheckedBlock, ast: AST): void {
    this.inUncheckedBlock = true;
    this.commonVisit(node, ast);
    this.inUncheckedBlock = false;
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);
    const biggerType =
      compareTypeSize(
        getNodeType(node.vLeftExpression, ast.compilerVersion),
        getNodeType(node.vRightExpression, ast.compilerVersion),
      ) <= 0
        ? node.vRightExpression.typeString
        : node.vLeftExpression.typeString;
    const cairoType = primitiveTypeToCairo(biggerType);
    const isFelt = cairoType === 'felt';
    switch (node.operator) {
      case '+':
      case '-':
      case '*':
      case '=':
        if (isFelt) return;
      //falls through
      case '!=':
      case '==':
      case '/':
      case '>':
      case '<':
      case '>=':
      case '<=':
      case '&&':
      case '||':
      case '^':
      case '>>':
      case '<<':
      case '&':
      case '|': {
        const [replacement, imports] = this.generateCallForOperator(node, cairoType, ast);
        ast.replaceNode(node, replacement);
        ast.addImports(imports);
        return;
      }
      default:
        console.log(`WARNING: Found unexpected operator ${node.operator}`);
        return;
    }
  }

  // Called after having already recursed through this BinaryOperation and back
  generateCallForOperator(
    node: BinaryOperation,
    cairoType: string,
    ast: AST,
  ): [FunctionCall, Imports] {
    const [operation, imports] = this.binaryOperationBasedOnType(cairoType, node.operator);

    return [
      new FunctionCall(
        ast.reserveId(),
        node.src,
        'FunctionCall',
        node.typeString,
        FunctionCallKind.FunctionCall,
        new Identifier(
          ast.reserveId(),
          node.src,
          'Identifier',
          node.typeString,
          operation,
          this.functionDefReferenceBasedOnType(node.typeString, ast),
          node.raw,
        ),
        [node.vLeftExpression, node.vRightExpression],
      ),
      imports,
    ];
  }

  binaryOperationBasedOnType(typeString: string, operator: string): [string, Imports] {
    const inner = () => {
      const call = infixOperatorToCall.get(operator);
      if (call === undefined) {
        throw new TranspileFailedError(`Found unexpected operator ${operator}`);
      }
      switch (typeString) {
        case 'Uint256':
          return `u256_${call}`;
        default:
          return `${typeString}_${call}`;
      }
    };
    const operatorFunc = this.inUncheckedBlock ? `unsafe_${inner()}` : inner();
    let imports = {};
    if (typeString === 'Uint256') {
      imports = { 'warplib.math.uint256': new Set([operatorFunc]) };
    } else if (typeString === 'felt') {
      imports = { 'warplib.math.logic': new Set([operatorFunc]) };
    }
    return [operatorFunc, imports];
  }

  functionDefReferenceBasedOnType(typeString: string, ast: AST) {
    switch (typeString) {
      case 'int':
      case 'uint':
      case 'uint256':
      case 'int256':
        return this.getDefId('binaryopUint256', ast);
      default:
        return this.getDefId('binaryopFelt', ast);
    }
  }
}

const infixOperatorToCall = new Map([
  ['+', 'add'],
  ['-', 'sub'],
  ['*', 'mul'],
  ['/', 'div'],
  ['==', 'eq'],
  ['!=', 'neq'],
  ['=', '='],
  ['<', 'lt'],
  ['>', 'gt'],
  ['<=', 'lte'],
  ['>=', 'gte'],
  ['&&', 'and'],
  ['||', 'or'],
  ['^', 'xor'],
  ['>>', 'shr'],
  ['<<', 'shl'],
  ['&', 'bitwise_and'],
  ['|', 'bitwise_or'],
]);
