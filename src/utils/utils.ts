import assert = require('assert');
import {
  AddressType,
  ArrayType,
  ArrayTypeName,
  BoolType,
  CompileFailedError,
  DataLocation,
  ElementaryTypeName,
  EtherUnit,
  Expression,
  FixedBytesType,
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  IdentifierPath,
  IntLiteralType,
  IntType,
  Literal,
  LiteralKind,
  Mapping,
  MappingType,
  Mutability,
  PointerType,
  StateVariableVisibility,
  StringLiteralType,
  StringType,
  StructDefinition,
  TimeUnit,
  TupleExpression,
  TypeName,
  TypeNode,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { isSane } from './astChecking';
import { printTypeNode } from './astPrinter';
import { logError, NotSupportedYetError, TranspileFailedError } from './errors';
import { Class } from './typeConstructs';

export function divmod(x: bigint, y: bigint): [BigInt, BigInt] {
  const div: BigInt = BigInt(x / y);
  const rem: BigInt = BigInt(x % y);
  return [div, rem];
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
      throw new NotSupportedYetError('Fixed types not implemented');
    default:
      return 'felt';
  }
}

export function union<T>(setA: Set<T>, setB: Set<T>) {
  const _union = new Set(setA);
  for (const elem of setB) {
    _union.add(elem);
  }
  return _union;
}

export function sizeOfType(type: TypeNode): number {
  if (type instanceof IntType) return type.nBits;
  // We do not respect size of address type
  else if (type instanceof AddressType) return 251;
  else if (type instanceof BoolType) return 8;
  // We only support short-strings for now.
  // That is why all strings are just felts.
  else if (type instanceof StringLiteralType) return 251;
  else if (type instanceof StringType) return 251;

  throw new NotSupportedYetError(`Don't know the size of ${printTypeNode(type)}`);
}

export function compareTypeSize(typeA: TypeNode, typeB: TypeNode): number {
  if (typeA.pp() === typeB.pp()) return 0;

  // TODO handle or rule out implicit conversions involving pointers
  if (typeA instanceof PointerType && typeB instanceof PointerType) {
    if (
      typeA.location === typeB.location &&
      compareTypeSize(typeA.to, typeB.to) === 0 &&
      typeA.kind === typeB.kind
    ) {
      return 0;
    }
    console.log(
      `WARNING: Assuming ${typeA.pp()} and ${typeB.pp()} do not have an implicit conversion`,
    );
    return 0;
  }

  // Literals always need to be cast to match the other type
  if (typeA instanceof IntLiteralType) {
    if (typeB instanceof IntLiteralType) {
      return 0;
    } else {
      return -1;
    }
  } else if (typeB instanceof IntLiteralType) {
    return 1;
  }

  if (typeA instanceof UserDefinedType && typeB instanceof UserDefinedType) {
    console.log('WARNING: comparing sizes of user defined types');
    return 0;
  }
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
      throw new TranspileFailedError('Encountered unknown unit');
  }
}

export function runSanityCheck(ast: AST, printResult: boolean): boolean {
  if (printResult) console.log('Running sanity check');
  if (isSane(ast)) {
    if (printResult) console.log('AST passed sanity check');
    return true;
  }
  if (printResult) console.log('AST failed sanity check');
  return false;
}

// Returns whether x is of type T but not any subclass of T
export function exactInstanceOf<T extends object>(x: unknown, typeName: Class<T>): x is T {
  return x instanceof typeName && !(Object.getPrototypeOf(x) instanceof typeName);
}

export function extractProperty(propName: string, obj: object): unknown {
  return extractDeepProperty(propName, obj, 0);
}

const MaxSearchDepth = 100;

function extractDeepProperty(propName: string, obj: object, currentDepth: number): unknown {
  // No non-adversarially created object should ever reach this, but since prototype loops are technically possible
  if (currentDepth > MaxSearchDepth) {
    return undefined;
  }
  const entry = Object.entries(obj).find(([name]) => name === propName);
  if (entry === undefined) {
    const prototype = Object.getPrototypeOf(obj);
    if (prototype !== null) {
      return extractDeepProperty(propName, Object.getPrototypeOf(obj), currentDepth + 1);
    } else {
      return undefined;
    }
  }
  return entry[1];
}

export function printCompileErrors(e: CompileFailedError): void {
  logError('---Compile Failed---');
  e.failures.forEach((failure) => {
    logError(`Compiler version ${failure.compilerVersion} reported errors:`);
    failure.errors.forEach((error, index) => {
      logError(`    --${index + 1}--`);
      const errorLines = error.split('\n');
      errorLines.forEach((line) => logError(`    ${line}`));
    });
  });
}

export function mapRange<T>(n: number, func: (n: number) => T): T[] {
  return [...Array(n).keys()].map(func);
}

export function typeNameFromTypeNode(node: TypeNode, ast: AST): TypeName {
  let result: TypeName | null = null;
  if (node instanceof AddressType) {
    result = new ElementaryTypeName(
      ast.reserveId(),
      '',
      node.pp(),
      node.pp(),
      node.payable ? 'payable' : 'nonpayable',
    );
  } else if (node instanceof ArrayType) {
    result = new ArrayTypeName(
      ast.reserveId(),
      '',
      node.pp(),
      typeNameFromTypeNode(node.elementT, ast),
      node.size === undefined
        ? undefined
        : new Literal(
            ast.reserveId(),
            '',
            `int_const ${node.size.toString()}`,
            LiteralKind.Number,
            toHexString(node.size.toString()),
            node.size.toString(),
          ),
    );
  } else if (node instanceof BoolType) {
    result = new ElementaryTypeName(ast.reserveId(), '', 'bool', 'bool');
  } else if (node instanceof FixedBytesType) {
    result = new ElementaryTypeName(ast.reserveId(), '', node.pp(), node.pp());
  } else if (node instanceof IntLiteralType) {
    console.log(`WARNING: assigning int248 type to int literal ${node.pp()}`);
    return new ElementaryTypeName(ast.reserveId(), '', 'int248', 'int248');
  } else if (node instanceof IntType) {
    result = new ElementaryTypeName(ast.reserveId(), '', node.pp(), node.pp());
  } else if (node instanceof PointerType) {
    result = typeNameFromTypeNode(node.to, ast);
  } else if (node instanceof MappingType) {
    const key = typeNameFromTypeNode(node.keyType, ast);
    const value = typeNameFromTypeNode(node.valueType, ast);
    result = new Mapping(
      ast.reserveId(),
      '',
      `mapping(${key.typeString} => ${value.typeString})`,
      key,
      value,
    );
  } else if (node instanceof UserDefinedType) {
    return new UserDefinedTypeName(
      ast.reserveId(),
      '',
      node.pp(),
      node.definition.name,
      node.definition.id,
      new IdentifierPath(ast.reserveId(), '', node.definition.name, node.definition.id),
    );
  } else if (node instanceof StringType) {
    return new ElementaryTypeName(ast.reserveId(), '', 'string', 'string', 'nonpayable');
  }

  if (result === null) {
    throw new NotSupportedYetError(`${printTypeNode(node)} to typename not implemented yet`);
  }

  ast.setContextRecursive(result);
  return result;
}

export function dereferenceType(typeNode: TypeNode): TypeNode {
  while (typeNode instanceof PointerType) {
    typeNode = typeNode.to;
  }
  return typeNode;
}

export function mergeImports(...maps: Map<string, Set<string>>[]): Map<string, Set<string>> {
  return maps.reduce((acc, curr) => {
    curr.forEach((importedSymbols, location) => {
      const accSet = acc.get(location) ?? new Set<string>();
      importedSymbols.forEach((s) => accSet.add(s));
      acc.set(location, accSet);
    });
    return acc;
  }, new Map<string, Set<string>>());
}

export function groupBy<V, K>(arr: V[], groupFunc: (arg: V) => K): Map<K, Set<V>> {
  const grouped = new Map<K, Set<V>>();
  arr.forEach((v) => {
    const key = groupFunc(v);
    const s = grouped.get(key) ?? new Set([]);
    grouped.set(key, new Set([...s, v]));
  });
  return grouped;
}

export function countNestedMapItems(map: Map<unknown, Map<unknown, unknown>>): number {
  return [...map.values()].reduce((acc, curr) => acc + curr.size, 0);
}

export function bigintToTwosComplement(val: bigint, width: number): bigint {
  if (val >= 0n) {
    // Non-negative values just need to be truncated to the given bitWidth
    const bits = val.toString(2);
    return BigInt(`0b${bits.slice(-width)}`);
  } else {
    // Negative values need to be converted to two's complement
    // This is done by flipping the bits, adding one, and truncating
    const absBits = (-val).toString(2);
    const allBits = `${'0'.repeat(Math.max(width - absBits.length, 0))}${absBits}`;
    const inverted = `0b${[...allBits].map((c) => (c === '0' ? '1' : '0')).join('')}`;
    const twosComplement = (BigInt(inverted) + 1n).toString(2).slice(-width);
    return BigInt(`0b${twosComplement}`);
  }
}

export function narrowBigInt(n: bigint): number | null {
  const narrowed = parseInt(n.toString());
  if (BigInt(narrowed) !== n) return null;
  return narrowed;
}

export function isCairoConstant(node: VariableDeclaration): boolean {
  if (node.mutability === Mutability.Constant && node.vValue instanceof Literal) {
    if (node.vType instanceof ElementaryTypeName) {
      return primitiveTypeToCairo(node.vType.name) === 'felt';
    }
  }
  return false;
}

export function isExternallyVisible(node: FunctionDefinition): boolean {
  return (
    node.visibility === FunctionVisibility.External || node.visibility === FunctionVisibility.Public
  );
}

export function toSingleExpression(expressions: Expression[], ast: AST): Expression {
  if (expressions.length === 1) return expressions[0];

  return new TupleExpression(
    ast.reserveId(),
    '',
    `tuple(${expressions.map((e) => e.typeString).join(',')})`,
    false,
    expressions,
  );
}

export function isNameless(node: FunctionDefinition) {
  return [FunctionKind.Constructor, FunctionKind.Fallback, FunctionKind.Receive].includes(
    node.kind,
  );
}

export function splitDarray(
  scope: number,
  dArrayVarDecl: VariableDeclaration,
  ast: AST,
): [arrayLen: VariableDeclaration, dArrayVarDecl: VariableDeclaration] {
  assert(dArrayVarDecl.vType !== undefined);
  const arrayLen = new VariableDeclaration(
    ast.reserveId(),
    '',
    true,
    false,
    dArrayVarDecl.name + '_len',
    scope,
    false,
    DataLocation.CallData,
    StateVariableVisibility.Internal,
    Mutability.Immutable,
    'uint248',
    undefined,
    new ElementaryTypeName(ast.reserveId(), '', 'uint248', 'uint248'),
    undefined,
  );

  return [arrayLen, dArrayVarDecl];
}

export function isReferenceType(type: TypeNode): boolean {
  return (
    type instanceof ArrayType ||
    type instanceof MappingType ||
    (type instanceof UserDefinedType && type.definition instanceof StructDefinition) ||
    (type instanceof PointerType && isReferenceType(type.to))
  );
}

export function isValueType(type: TypeNode): boolean {
  return !isReferenceType(type);
}
