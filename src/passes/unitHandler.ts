import { ASTNode, EtherUnit, Literal, LiteralKind, TimeUnit } from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { stringToLiteralValue } from '../utils/literalParsing';

function unitConversion(value: string, unit?: EtherUnit | TimeUnit): string {
  const processedValue = stringToLiteralValue(value);

  if (!unit) {
    // This ensures that both coefficient and exponent are integers
    // Makes things easier in CairoWriter
    return processedValue.toString();
  }

  // EtherUnit and TimeUnit are non-intersecting string unions,
  // so it's safe to switch over the union

  switch (unit) {
    case EtherUnit.Wei:
      break;
    case EtherUnit.GWei:
      processedValue.exponent += 9n;
      break;
    case EtherUnit.Szabo:
      processedValue.exponent += 12n;
      break;
    case EtherUnit.Finney:
      processedValue.exponent += 15n;
      break;
    case EtherUnit.Ether:
      processedValue.exponent += 18n;
      break;
    case TimeUnit.Seconds:
      break;
    case TimeUnit.Minutes:
      processedValue.coefficient *= 60n;
      break;
    case TimeUnit.Hours:
      processedValue.coefficient *= 60n * 60n;
      break;
    case TimeUnit.Days:
      processedValue.coefficient *= 24n * 60n * 60n;
      break;
    case TimeUnit.Weeks:
      processedValue.coefficient *= 7n * 24n * 60n * 60n;
      break;
    case TimeUnit.Years: // Removed since solidity 0.5.0, handled for completeness
      processedValue.coefficient *= 365n * 24n * 60n * 60n;
      break;
    default:
      throw new Error('Encountered unknown unit');
  }
  return processedValue.toString();
}

function toHexString(stringValue: string): string {
  return stringValue
    .split('')
    .map((c: string) => {
      // All expected characters have 2digit ascii hex codes,
      // so no need to set to fixed length
      return c.charCodeAt(0).toString(16);
    })
    .join('');
}

export class UnitHandler extends ASTMapper {
  visitLiteral(node: Literal): ASTNode {
    if (node.kind !== LiteralKind.Number) {
      return this.commonVisit(node);
    }
    const stringValue = unitConversion(node.value, node.subdenomination);
    const hexValue = toHexString(stringValue);
    return new Literal(
      this.genId(),
      node.src,
      node.type,
      node.typeString,
      node.kind,
      hexValue,
      stringValue,
      undefined, //literal is now unitless
      node.raw,
    );
  }
}
