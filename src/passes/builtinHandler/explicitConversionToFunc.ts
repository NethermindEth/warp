import assert = require('assert');
import {
  AddressType,
  ASTNode,
  BinaryOperation,
  BytesType,
  DataLocation,
  ElementaryTypeNameExpression,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  getNodeType,
  Identifier,
  IntType,
  Literal,
  LiteralKind,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  TypeNameType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { BuiltinMapper } from '../../ast/builtinMapper';

export class ExplicitConversionToFunc extends BuiltinMapper {
  builtinDefs = {
    felt_to_uint256: () =>
      new FunctionDefinition(
        this.genId(),
        '',
        'FunctionDefinition',
        -1,
        FunctionKind.Function,
        'felt_to_uint256',
        false,
        FunctionVisibility.Default,
        FunctionStateMutability.Pure,
        false,
        new ParameterList(this.genId(), '', 'ParameterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'in',
            -1,
            false,
            DataLocation.Default,
            StateVariableVisibility.Default,
            Mutability.Mutable,
            'uint*',
          ),
        ]),
        new ParameterList(this.genId(), '', 'ParamterList', [
          new VariableDeclaration(
            this.genId(),
            '',
            'VariableDeclaration',
            false,
            false,
            'out',
            -1,
            false,
            DataLocation.Default,
            StateVariableVisibility.Default,
            Mutability.Mutable,
            'uint256',
          ),
        ]),
        [],
      ),
  };
  visitFunctionCall(node: FunctionCall): ASTNode {
    if (node.kind !== FunctionCallKind.TypeConversion) return node;
    assert(
      node.vExpression instanceof ElementaryTypeNameExpression,
      `Unexpected node type ${node.vExpression.type}`,
    );
    assert(node.vArguments.length === 1, `Expecting typeconversion to have one child`);

    const arg = this.visit(node.vArguments[0]) as Expression;

    // Since we are only considering type conversions typeTo will always be a TypeNameType
    const typeTo = (getNodeType(node.vExpression, this.compilerVersion) as TypeNameType).type;
    const argType = getNodeType(arg, this.compilerVersion);

    if (typeTo instanceof BytesType && argType instanceof BytesType) {
      // TODO: Implement bytes to bytes conversion
      return node;
    }

    if (typeTo instanceof IntType && argType instanceof IntType) {
      const argTypeSize = argType.nBits;

      const typeToSize = typeTo.nBits;

      if (argTypeSize <= typeToSize) {
        // We don't need to do anything for upcasting if its not being casted to a uint256
        if (typeToSize !== 256) return arg;
        else {
          this.addImport({ utils: new Set(['felt_to_uint256']) });
          return new FunctionCall(
            this.genId(),
            node.src,
            'FunctionCall',
            typeTo.pp(),
            FunctionCallKind.FunctionCall,
            new Identifier(
              this.genId(),
              node.src,
              'Identifier',
              typeTo.pp(),
              'felt_to_uint256',
              this.getDefId('felt_to_uint256'),
            ),
            [arg],
          );
        }
      }

      const maskSize = '0x'.concat('f'.repeat(typeToSize / 4));

      const maskSizeLiteral = new Literal(
        this.genId(),
        node.src,
        'Literal',
        arg.typeString,
        LiteralKind.Number,
        maskSize,
        maskSize,
      );

      const ret = new BinaryOperation(
        this.genId(),
        node.src,
        'BinaryOperation',
        typeTo.pp(),
        '&&',
        arg,
        maskSizeLiteral,
      );

      return ret;
    }
    return node;
  }
}
