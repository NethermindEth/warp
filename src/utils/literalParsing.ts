// Numbers in solidity:
// (+-)decimal, optional (e[integer])
// underscores allowed but ignored

export class LiteralValue {
  coefficient: bigint;
  exponent: bigint;

  constructor(coefficient: bigint, exponent: bigint) {
    this.coefficient = coefficient;
    this.exponent = exponent;
  }

  toString(): string {
    if (this.exponent === 0n) {
      return this.coefficient.toString();
    } else {
      return `${this.coefficient}e${this.exponent}`;
    }
  }

  toCairoLiteral(): string {
    let result = this.coefficient.toString();
    if (this.exponent > BigInt(Number.MAX_SAFE_INTEGER)) {
      throw new Error('Unable to print extremely large number as non-scientific string');
    } else if (this.exponent > 0n) {
      return `${result}${'0'.repeat(Number(this.exponent))}`;
    } else if (this.exponent < 0n) {
      if (!result.endsWith('0'.repeat(-Number(this.exponent)))) {
        console.log('WARNING: truncating rational literal');
      }
      if (result.length <= -Number(this.exponent)) {
        return '0';
      }
      return result.slice(0, Number(this.exponent));
    } else {
      return result;
    }
  }
}

export function stringToLiteralValue(value: string): LiteralValue {
  const tidiedValue = value
    .split('')
    .filter((c) => c !== '_')
    .join('');

  if (tidiedValue.startsWith('0x')) {
    return intToLiteral(value);
  } else if (tidiedValue.includes('e')) {
    return scientificNotationToLiteral(value);
  } else if (tidiedValue.includes('.')) {
    return decimalToLiteral(value);
  } else {
    return intToLiteral(value);
  }
}

function intToLiteral(value: string): LiteralValue {
  return new LiteralValue(BigInt(value), 0n);
}

function decimalToLiteral(value: string): LiteralValue {
  const parts = value.split('.', 2);
  //Remove leading zeros, but keep 1 if the int part is 0
  const intPart = parts[0].replace('/^0+/', '');
  //Remove trailing zeros
  const decimalPart = parts[1].replace('/0+$', '');

  if (intPart === '' && decimalPart === '') {
    return new LiteralValue(0n, 0n);
  } else {
    return new LiteralValue(BigInt(`${intPart}${decimalPart}`), BigInt(-decimalPart.length));
  }
}

function scientificNotationToLiteral(value: string): LiteralValue {
  const parts = value.split('e', 2);
  const coefficient: LiteralValue = parts[0].includes('.')
    ? decimalToLiteral(parts[0])
    : intToLiteral(parts[0]);
  const exponent: bigint = BigInt(parts[1]);
  coefficient.exponent += exponent;
  return coefficient;
}
