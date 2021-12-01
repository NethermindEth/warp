import { AddressType, BoolType, IntType, TypeNode, EtherUnit, TimeUnit } from 'solc-typed-ast';
import { Imports } from '../ast/visitor';

export function divmod(x: number, y: number): [number, number] {
  return [Math.floor(x / y), x % y];
}

export function primitiveTypeToCairo(typeString: string): 'Uint256' | 'felt' {
  switch (typeString) {
    case 'uint':
    case 'uint256':
    case 'int':
    case 'int256':
      return 'Uint256';
    case 'fixed':
    case 'ufixed':
      throw new Error('Fixed types not implemented');
    default:
      return 'felt';
  }
}

function union<T>(setA: Set<T>, setB: Set<T>) {
  let _union = new Set(setA);
  for (let elem of setB) {
    _union.add(elem);
  }
  return _union;
}

export function mergeImports(importsA: Imports, importsB: Imports): Imports {
  if (!importsA) return importsB;
  if (!importsB) return importsA;

  Object.entries(importsB).forEach(([mod, imports]) => {
    const currentImports = importsA[mod];
    importsA[mod] = currentImports ? union(currentImports, imports) : imports;
  });

  return importsA;
}

export function importsWriter(imports: Imports): string {
  if (!imports) return '';
  return Object.entries(imports)
    .map(([file, vals]) => `from ${file} import ${[...vals].join(', ')}`)
    .join('\n');
}

export function sizeOfType(type: TypeNode): number {
  if (type instanceof IntType) return type.nBits;
  // We do not respect size of address type
  else if (type instanceof AddressType) return 251;
  else if (type instanceof BoolType) return 8;
  throw new Error(`Don't know the size of ${type.pp()}`);
}

export function compareTypeSize(typeA: TypeNode, typeB: TypeNode): number {
  const sizeOfTypeA = sizeOfType(typeA);
  const sizeOfTypeB = sizeOfType(typeB);
  return Math.sign(sizeOfTypeA - sizeOfTypeB);
}

export function* counterGenerator(start = 0): Generator<number, number, unknown> {
  let count = start;
  while (true) {
    yield count;
    count++;
  }
}

export function canonicalMangler(name: string) {
  return name.replaceAll('_', '__').replaceAll('.', '_');
}

export function toHexString(stringValue: string): string {
  return stringValue
    .split('')
    .map((c: string) => {
      // All expected characters have 2digit ascii hex codes,
      // so no need to set to fixed length
      return c.charCodeAt(0).toString(16);
    })
    .join('');
}

export function unitValue(unit?: EtherUnit | TimeUnit): number {
  if (unit === undefined) {
    return 1;
  }

  switch (unit) {
    case EtherUnit.Wei:
      return 1;
    case EtherUnit.GWei:
      return 10 ** 9;
    case EtherUnit.Szabo:
      return 10 ** 12;
    case EtherUnit.Finney:
      return 10 ** 15;
    case EtherUnit.Ether:
      return 10 ** 18;
    case TimeUnit.Seconds:
      return 1;
    case TimeUnit.Minutes:
      return 60;
    case TimeUnit.Hours:
      return 60 * 60;
    case TimeUnit.Days:
      return 24 * 60 * 60;
    case TimeUnit.Weeks:
      return 7 * 24 * 60 * 60;
    case TimeUnit.Years: // Removed since solidity 0.5.0, handled for completeness
      return 365 * 24 * 60 * 60;
    default:
      throw new Error('Encountered unknown unit');
  }
}
