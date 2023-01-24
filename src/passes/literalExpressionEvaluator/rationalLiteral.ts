import { TranspileFailedError } from '../../utils/errors';
import { gcdBigint } from '@algorithm.ts/gcd';

export class RationalLiteral {
  private numerator: bigint;
  private denominator: bigint;

  constructor(numerator: bigint, denominator: bigint) {
    if (denominator === 0n) {
      throw new TranspileFailedError('Attempted rational division by 0');
    }

    const gcd = gcdBigint(numerator, denominator);
    this.numerator = numerator / gcd;
    this.denominator = denominator / gcd;

    if (denominator < 0n) {
      this.numerator *= -1n;
      this.denominator *= -1n;
    }
  }

  equalValueOf(other: RationalLiteral): boolean {
    return this.numerator * other.denominator === other.numerator * this.denominator;
  }

  greaterThan(other: RationalLiteral): boolean {
    return this.numerator * other.denominator > other.numerator * this.denominator;
  }

  add(other: RationalLiteral): RationalLiteral {
    if (this.denominator === other.denominator) {
      return new RationalLiteral(this.numerator + other.numerator, this.denominator);
    } else if (this.denominator % other.denominator === 0n) {
      // 6 % 3 === 0
      // 5/6 + 2/3 === 5+(2*6/3)/6
      return new RationalLiteral(
        this.numerator + (other.numerator * this.denominator) / other.denominator,
        this.denominator,
      );
    } else if (other.denominator % this.denominator === 0n) {
      return new RationalLiteral(
        other.numerator + (this.numerator * other.denominator) / this.denominator,
        other.denominator,
      );
    } else {
      return new RationalLiteral(
        this.numerator * other.denominator + other.numerator * this.denominator,
        this.denominator * other.denominator,
      );
    }
  }

  subtract(other: RationalLiteral): RationalLiteral {
    return this.add(new RationalLiteral(-other.numerator, other.denominator));
  }

  multiply(other: RationalLiteral): RationalLiteral {
    return new RationalLiteral(
      this.numerator * other.numerator,
      this.denominator * other.denominator,
    );
  }

  divideBy(other: RationalLiteral): RationalLiteral {
    // Division by 0 will cause the constructor to throw an error
    return new RationalLiteral(
      this.numerator * other.denominator,
      this.denominator * other.numerator,
    );
  }

  exp(other: RationalLiteral): RationalLiteral | null {
    const op = other.toInteger();
    if (op === null) {
      return null;
    }

    if (op >= 0n) {
      return new RationalLiteral(this.numerator ** op, this.denominator ** op);
    } else {
      return new RationalLiteral(this.denominator ** -op, this.numerator ** -op);
    }
  }

  mod(other: RationalLiteral): RationalLiteral {
    return new RationalLiteral(
      (this.numerator * other.denominator) % (other.numerator * this.denominator),
      this.denominator * other.denominator,
    );
  }

  shiftLeft(other: RationalLiteral): RationalLiteral | null {
    if (this.denominator !== 1n) {
      throw new TranspileFailedError('Attempted shift to non-integer value');
    }

    const op = other.toInteger();
    if (op === null) {
      return null;
    }

    return new RationalLiteral(this.numerator << op, this.denominator);
  }

  shiftRight(other: RationalLiteral): RationalLiteral | null {
    if (this.denominator !== 1n) {
      throw new TranspileFailedError('Attempted shift to non-integer value');
    }

    const op = other.toInteger();
    if (op === null) {
      return null;
    }

    return new RationalLiteral(this.numerator >> op, this.denominator);
  }

  bitwiseNegate(): RationalLiteral | null {
    const intValue = this.toInteger();
    if (intValue === null) {
      return null;
    }

    // -x = ~x + 1 in two's complement
    return new RationalLiteral(-intValue - 1n, 1n);
  }

  toInteger(): bigint | null {
    if (this.numerator % this.denominator === 0n) {
      return this.numerator / this.denominator;
    } else {
      return null;
    }
  }

  toString(): string {
    return `${this.numerator}/${this.denominator}`;
  }

  bitwiseAnd(other: RationalLiteral): RationalLiteral {
    return new RationalLiteral(
      this.numerator & other.numerator,
      this.denominator & other.denominator,
    );
  }
  bitwiseOr(other: RationalLiteral): RationalLiteral {
    return new RationalLiteral(
      this.numerator | other.numerator,
      this.denominator | other.denominator,
    );
  }
  bitwiseXor(other: RationalLiteral): RationalLiteral {
    return new RationalLiteral(
      this.numerator ^ other.numerator,
      this.denominator ^ other.denominator,
    );
  }
}

export function stringToLiteralValue(value: string): RationalLiteral {
  const tidiedValue = value
    .split('')
    .filter((c) => c !== '_')
    .join('');

  if (tidiedValue.startsWith('0x')) {
    return intToLiteral(tidiedValue);
  } else if (tidiedValue.includes('e') || tidiedValue.includes('E')) {
    return scientificNotationToLiteral(tidiedValue);
  } else if (tidiedValue.includes('.')) {
    return decimalToLiteral(tidiedValue);
  } else {
    return intToLiteral(tidiedValue);
  }
}

function intToLiteral(value: string): RationalLiteral {
  return new RationalLiteral(BigInt(value), 1n);
}

function decimalToLiteral(value: string): RationalLiteral {
  const parts = value.split('.', 2);
  //Remove leading zeros, but keep 1 if the int part is 0
  const intPart = parts[0].replace('/^0+/', '');
  //Remove trailing zeros
  const decimalPart = parts[1].replace('/0+$', '');

  if (intPart === '' && decimalPart === '') {
    return new RationalLiteral(0n, 1n);
  } else {
    return new RationalLiteral(
      BigInt(`${intPart}${decimalPart}`),
      BigInt(10n ** BigInt(decimalPart.length)),
    );
  }
}

function scientificNotationToLiteral(value: string): RationalLiteral {
  const parts = value.split(/e|E/, 2);
  const coefficient: RationalLiteral = parts[0].includes('.')
    ? decimalToLiteral(parts[0])
    : intToLiteral(parts[0]);
  const exponent = BigInt(parts[1]);
  const rationalExponentFactor = new RationalLiteral(10n, 1n).exp(
    new RationalLiteral(exponent, 1n),
  );
  if (rationalExponentFactor === null) {
    throw new TranspileFailedError('Exponentiation failed when parsing scientific notation');
  }
  return coefficient.multiply(rationalExponentFactor);
}
