import {
  ASTNode,
  BinaryOperation,
  Expression,
  FunctionCallKind,
  getNodeType,
  Identifier,
  UncheckedBlock,
  ElementaryTypeName,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  FunctionStateMutability,
  ParameterList,
  VariableDeclaration,
  DataLocation,
  StateVariableVisibility,
  Mutability,
} from 'solc-typed-ast';
import { BuiltinMapper } from '../../ast/builtinMapper';
import { compareTypeSize, primitiveTypeToCairo } from '../../utils/utils';
import { CairoFunctionCall } from '../../ast/cairoNodes';

export class BinaryOperations extends BuiltinMapper {
  feltTypeName = () =>
    new ElementaryTypeName(
      this.genId(),
      '',
      'TypeName',
      'felt',
      'felt',
      undefined,
      'BINARY_BUILTIN',
    );
  uintTypeName = () =>
    new ElementaryTypeName(
      this.genId(),
      '',
      'TypeName',
      'uint256',
      'uint',
      undefined,
      'BINARY_BUILTIN',
    );
  builtinDefs = {
    binaryopFelt: () =>
      new FunctionDefinition(
        this.genId(),
        '',
        'FunctionDefinition',
        -1,
        FunctionKind.Function,
        'binaryopFelt',
        false,
        FunctionVisibility.Internal,
        FunctionStateMutability.NonPayable,
        false,
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'arg1',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'felt',
            undefined,
            this.feltTypeName(),
          ),
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'arg1',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'felt',
            undefined,
            this.feltTypeName(),
          ),
        ]),
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'ret',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'felt',
            undefined,
            this.feltTypeName(),
          ),
        ]),
        [],
      ),
    binaryopUint256: () =>
      new FunctionDefinition(
        this.genId(),
        '',
        'FunctionDefinition',
        -1,
        FunctionKind.Function,
        'binaryopUint256',
        false,
        FunctionVisibility.Internal,
        FunctionStateMutability.NonPayable,
        false,
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'arg1',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'uint256',
            undefined,
            this.uintTypeName(),
          ),
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'arg1',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'uint256',
            undefined,
            this.uintTypeName(),
          ),
        ]),
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'ret',
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            'uint256',
            undefined,
            this.uintTypeName(),
          ),
        ]),
        [],
      ),
  };

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

  visitBinaryOperation(n: BinaryOperation): ASTNode {
    const node = new BinaryOperation(
      this.genId(),
      n.src,
      n.type,
      n.typeString,
      n.operator,
      this.visit(n.vLeftExpression) as Expression,
      this.visit(n.vRightExpression) as Expression,
      n.raw,
    );
    const biggerType =
      compareTypeSize(
        getNodeType(node.vLeftExpression, this.compilerVersion),
        getNodeType(node.vRightExpression, this.compilerVersion),
      ) <= 0
        ? node.vRightExpression.typeString
        : node.vLeftExpression.typeString;
    const cairoType = primitiveTypeToCairo(biggerType);
    const isFelt = cairoType === 'felt';
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
      case '>>':
      case '<<':
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

    const args = [node.vLeftExpression, node.vRightExpression].map((v) =>
      this.visit(v),
    ) as Expression[];
    const iden = new Identifier(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      operation,
      this.functionDefReferenceBasedOnType(node.typeString),
      node.raw,
    );

    return new CairoFunctionCall(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      FunctionCallKind.FunctionCall,
      iden,
      args,
      undefined,
      undefined,
      ['range_check_ptr'],
    );
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
    switch (typeString) {
      case 'int':
      case 'uint':
      case 'uint256':
      case 'int256':
        return this.getDefId('binaryopUint256');
      default:
        return this.getDefId('binaryopFelt');
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
  '>>': 'shr',
  '<<': 'shl',
};
