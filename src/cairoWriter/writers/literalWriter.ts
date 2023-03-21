import { ASTWriter, Literal, LiteralKind, SrcDesc } from 'solc-typed-ast';
import { TranspileFailedError } from '../../utils/errors';
import { primitiveTypeToCairo, CairoPrimitiveIntType } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';

export class LiteralWriter extends CairoASTNodeWriter {
  writeInner(node: Literal, _: ASTWriter): SrcDesc {
    switch (node.kind) {
      case LiteralKind.Number:
        const type = primitiveTypeToCairo(node.typeString);
        if (type as CairoPrimitiveIntType) {
          return [`${node.value}_${type}`];
        } else if (type === 'felt') {
          return [node.value];
        } else {
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
        const hexType = primitiveTypeToCairo(node.typeString);
        if (hexType as CairoPrimitiveIntType) {
          return [`0x${node.hexValue}_${hexType}`];
        } else if (hexType === 'felt') {
          return [`0x${node.hexValue}`];
        } else {
          throw new TranspileFailedError('Attempted to write unexpected cairo type');
        }
    }
  }
}
