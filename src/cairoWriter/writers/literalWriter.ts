import { ASTWriter, Literal, LiteralKind, SrcDesc } from 'solc-typed-ast';
import { TranspileFailedError } from '../../utils/errors';
import { primitiveTypeToCairo } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';

export class LiteralWriter extends CairoASTNodeWriter {
  writeInner(node: Literal, _: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256': {
            return [`u256_from_felt(${node.value})`];
          }
          case 'felt':
            return [node.value];
          default:
            throw new TranspileFailedError('Attempted to write unexpected cairo type');
        }
      case LiteralKind.Bool:
        return [node.value === 'true' ? '1' : '0'];
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
        switch (primitiveTypeToCairo(node.typeString)) {
          case 'Uint256': {
            return [`u256_from_felt(0x${node.hexValue})`];
          }
          case 'felt':
            return [`0x${node.hexValue}`];
          default:
            throw new TranspileFailedError('Attempted to write unexpected cairo type');
        }
    }
  }
}
