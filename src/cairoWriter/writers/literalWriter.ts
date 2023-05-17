import { ASTWriter, Literal, LiteralKind, SrcDesc } from 'solc-typed-ast';
import { TranspileFailedError } from '../../utils/errors';
import { primitiveTypeToCairo, isCairoPrimitiveIntType } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { CairoUint256, divmod } from '../../export';

export class LiteralWriter extends CairoASTNodeWriter {
  writeInner(node: Literal, _: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        const numberType = primitiveTypeToCairo(node.typeString);
        if (isCairoPrimitiveIntType(numberType)) {
          if (numberType === CairoUint256.toString()) {
            const [high, low] = divmod(BigInt(node.value), BigInt(Math.pow(2, 128)));
            return [`u256_from_felts( ${low}, ${high} )`];
          }
          return [`${node.value}_${numberType}`];
        } else if (numberType === 'ContractAddress') {
          return [`starknet::contract_address_const::<${node.value}>()`];
        } else if (numberType === 'felt252') {
          return [node.value];
        } else {
          throw new TranspileFailedError(`Attempted to write unexpected cairo type: ${numberType}`);
        }
      case LiteralKind.Bool:
        return [node.value];
      case LiteralKind.String:
      case LiteralKind.UnicodeString: {
        if (
          node.value.length === node.hexValue.length / 2 &&
          node.value.length < 32 &&
          node.value.split('').every((v) => v.charCodeAt(0) < 127)
        ) {
          return [`'${node.value}'`];
        }
        return [`0x${node.hexValue}`];
      }
      case LiteralKind.HexString:
        const hexType = primitiveTypeToCairo(node.typeString);
        if (isCairoPrimitiveIntType(hexType)) {
          if (hexType === CairoUint256.toString()) {
            return [
              `u256_from_felts( ${node.hexValue.slice(32, 64)}, ${node.hexValue.slice(0, 32)} )`,
            ];
          }
          return [`0x${node.hexValue}_${hexType}`];
        } else if (hexType === 'ContractAddress') {
          return [`starknet::contract_address_const::<${node.hexValue}>()`];
        } else if (hexType === 'felt252') {
          return [`0x${node.hexValue}`];
        } else {
          throw new TranspileFailedError('Attempted to write unexpected cairo type');
        }
    }
  }
}
