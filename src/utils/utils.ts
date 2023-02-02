import * as fs from 'fs';
import assert from 'assert';
import * as path from 'path';
import { execSync } from 'child_process';
import {
  AddressType,
  ArrayType,
  ArrayTypeName,
  Assignment,
  ASTNode,
  Block,
  BoolType,
  BytesType,
  CompileFailedError,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  EtherUnit,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  generalizeType,
  Identifier,
  IdentifierPath,
  IndexAccess,
  InferType,
  IntLiteralType,
  IntType,
  Literal,
  Mapping,
  MappingType,
  MemberAccess,
  Mutability,
  PointerType,
  Return,
  SourceLocation,
  SourceUnit,
  StateVariableVisibility,
  StringType,
  StructDefinition,
  TimeUnit,
  TupleExpression,
  TypeName,
  TypeNode,
  UncheckedBlock,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclaration,
} from 'solc-typed-ast';
import Web3 from 'web3';
import { AST } from '../ast/ast';
import { isSane } from './astChecking';
import { printNode, printTypeNode } from './astPrinter';
import {
  logError,
  NotSupportedYetError,
  TranspileFailedError,
  WillNotSupportError,
} from './errors';
import {
  createAddressTypeName,
  createBoolTypeName,
  createBytesTypeName,
  createNumberLiteral,
} from './nodeTemplates';
import { isDynamicArray, isDynamicCallDataArray, safeGetNodeType } from './nodeTypeProcessing';
import { Class } from './typeConstructs';
import { TranspilationOptions } from '../cli';

const uint128 = BigInt('0x100000000000000000000000000000000');

export function divmod(x: bigint, y: bigint): [bigint, bigint] {
  const div = BigInt(x / y);
  const rem = BigInt(x % y);
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

export function* counterGenerator(start = 0): Generator<number, number, unknown> {
  let count = start;
  while (true) {
    yield count;
    count++;
  }
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

export function runSanityCheck(ast: AST, options: TranspilationOptions, passName: string): boolean {
  const printResult = options.checkTrees ?? false;
  if (printResult) console.log(`Running sanity check after ${passName}`);
  if (isSane(ast, options.dev)) {
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
  node = generalizeType(node)[0];
  let result: TypeName | null = null;
  if (node instanceof AddressType) {
    result = createAddressTypeName(node.payable, ast);
  } else if (node instanceof ArrayType) {
    result = new ArrayTypeName(
      ast.reserveId(),
      '',
      node.pp(),
      typeNameFromTypeNode(node.elementT, ast),
      node.size === undefined ? undefined : createNumberLiteral(node.size, ast),
    );
  } else if (node instanceof BytesType) {
    result = createBytesTypeName(ast);
  } else if (node instanceof BoolType) {
    result = createBoolTypeName(ast);
  } else if (node instanceof FixedBytesType) {
    result = new ElementaryTypeName(ast.reserveId(), '', node.pp(), node.pp());
  } else if (node instanceof IntLiteralType) {
    throw new TranspileFailedError(`Attempted to create typename for int literal`);
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

export function narrowBigIntSafe(n: bigint, errorMessage?: string): number {
  const narrowed = narrowBigInt(n);
  if (narrowed === null) {
    throw new WillNotSupportError(errorMessage ?? `Unable to accurately parse ${n.toString()}`);
  }
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
    false, // isInlineArray
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
    true, // constant
    false, // indexed
    dArrayVarDecl.name + '_len',
    scope,
    false, // isInlineArray
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

export function toUintOrFelt(value: bigint, nBits: number): bigint[] {
  const val = bigintToTwosComplement(BigInt(value.toString()), nBits);
  if (nBits > 251) {
    const [high, low] = divmod(val, uint128);
    return [low, high];
  } else {
    return [val];
  }
}

export function expressionHasSideEffects(node: Expression): boolean {
  return (
    (node instanceof FunctionCall && functionAffectsState(node)) ||
    node instanceof Assignment ||
    node.children.some((child) => child instanceof Expression && expressionHasSideEffects(child))
  );
}

export function functionAffectsState(node: FunctionCall): boolean {
  const funcDef = node.vReferencedDeclaration;
  if (funcDef instanceof FunctionDefinition) {
    return (
      funcDef.stateMutability !== FunctionStateMutability.Pure &&
      funcDef.stateMutability !== FunctionStateMutability.View
    );
  }
  return true;
}

export function mangleStructName(structDef: StructDefinition): string {
  return `${structDef.name}_${Web3.utils.sha3(structDef.canonicalName)?.slice(2, 10)}`;
}

export function mangleOwnContractInterface(contractOrName: ContractDefinition | string): string {
  const name = typeof contractOrName === 'string' ? contractOrName : contractOrName.name;
  return `${name}_interface`;
}

export function isBlock(node: ASTNode): node is Block | UncheckedBlock {
  return node instanceof Block || node instanceof UncheckedBlock;
}

export function isExternalCall(node: FunctionCall): boolean {
  return (
    node.vReferencedDeclaration instanceof FunctionDefinition &&
    isExternallyVisible(node.vReferencedDeclaration)
  );
}

// Detects when an identifier represents a memory dynamic arrays that's being treated as calldata
// (which only occurs when the memory dynamic array is the output of a cross contract call function)
export function isExternalMemoryDynArray(node: Identifier, inference: InferType): boolean {
  const declaration = node.vReferencedDeclaration;
  if (
    !(declaration instanceof VariableDeclaration) ||
    node.parent instanceof IndexAccess ||
    node.parent instanceof MemberAccess
  )
    return false;

  const declarationLocation = declaration.storageLocation;
  const [nodeType, typeLocation] = generalizeType(safeGetNodeType(node, inference));

  return (
    isDynamicArray(nodeType) &&
    declarationLocation === DataLocation.CallData &&
    typeLocation === DataLocation.Memory
  );
}

// Detects when an identifier represents a calldata dynamic array in solidity
export function isCalldataDynArrayStruct(node: Identifier, inference: InferType): boolean {
  return (
    isDynamicCallDataArray(safeGetNodeType(node, inference)) &&
    ((node.getClosestParentByType(Return) !== undefined &&
      node.getClosestParentByType(IndexAccess) === undefined &&
      node.getClosestParentByType(FunctionDefinition)?.visibility === FunctionVisibility.External &&
      node.getClosestParentByType(IndexAccess) === undefined &&
      node.getClosestParentByType(MemberAccess) === undefined) ||
      (node.parent instanceof FunctionCall &&
        // 'string_hash' function can not be user defined, due to mangling identifiers
        (isExternalCall(node.parent) || node.parent.vFunctionName === 'string_hash')))
  );
}

/**
 * Given a source file and some nodes, prints them
 * @param source solidity path to file
 * @param locations nodes source locations
 * @param highlightFunc function that highlight the nodes text locations
 * @param surroundingLines lines surrounding highlighted lines
 * @returns text with highlights
 */
export function getSourceFromLocations(
  source: string,
  locations: SourceLocation[],
  highlightFunc: (text: string) => string,
  surroundingLines = 2,
): string {
  // Sort locations
  locations.sort((s1, s2) => s1.offset - s2.offset);

  let textWalked = 0;
  let locIndex = 0;
  const lines = source.split('\n').reduce((lines, currentLine, lineNum) => {
    const maxWalk = textWalked + currentLine.length + 1;
    let marked = false;
    let newLine = `${lineNum}\t`;
    while (locIndex < locations.length && maxWalk >= locations[locIndex].offset) {
      // Mark the line as a highlited line
      marked = true;
      const currentLocation = locations[locIndex];
      if (currentLocation.offset + currentLocation.length > maxWalk) {
        // Case when node source spans accross multiple lines
        newLine =
          newLine +
          source.substring(textWalked, currentLocation.offset) +
          highlightFunc(source.substring(currentLocation.offset, maxWalk));
        currentLocation.length = currentLocation.length - (maxWalk - currentLocation.offset);
        currentLocation.offset = maxWalk;
        textWalked = maxWalk;
        break;
      } else {
        // Case when node source is a substring of a line
        newLine =
          newLine +
          source.substring(textWalked, currentLocation.offset) +
          highlightFunc(
            source.substring(
              currentLocation.offset,
              currentLocation.offset + currentLocation.length,
            ),
          );
        locIndex += 1;
        textWalked = currentLocation.offset + currentLocation.length;
      }
    }

    newLine = newLine + source.substring(textWalked, maxWalk);
    textWalked = maxWalk;
    lines.push([newLine, marked]);
    return lines;
  }, new Array<[string, boolean]>());

  let lastLineMarked = 0;
  const filteredLines: string[] = [];
  for (let index = 0; index < lines.length; index++) {
    const [, marked] = lines[index];
    if (!marked) continue;

    if (index - (lastLineMarked + surroundingLines) > surroundingLines) {
      filteredLines.push('\t................\n');
    }
    lastLineMarked = index;

    filteredLines.push(
      ...lines
        .slice(
          index - surroundingLines > 0 ? index - surroundingLines : 0,
          index + surroundingLines,
        )
        .map((l) => l[0])
        .filter((l) => !filteredLines.includes(l)),
    );
  }

  return filteredLines.join('');
}

export function runStarkNetClassHash(filePath: string): string {
  const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', '..', 'warp_venv', 'bin')}:$PATH`;

  const classHash = execSync(`${warpVenvPrefix} starknet-class-hash ${filePath}`).toString().trim();
  if (classHash === undefined) {
    throw new Error(`starknet-class-hash failed`);
  }
  return classHash;
}

export function getContainingFunction(node: ASTNode): FunctionDefinition {
  const func = node.getClosestParentByType(FunctionDefinition);
  assert(func !== undefined, `Unable to find containing function for ${printNode(node)}`);
  return func;
}

export function getContainingSourceUnit(node: ASTNode): SourceUnit {
  const root = node.getClosestParentByType(SourceUnit);
  assert(root !== undefined, `Unable to find root source unit for ${printNode(node)}`);
  return root;
}

export const NODE_MODULES_MARKER = ['node_modules'];

function markerExists(files: string[], markers: string[]) {
  return markers.some((marker) => {
    return files.some((file) => {
      return file === marker;
    });
  });
}

export function traverseParent(
  directory: string,
  levels: number,
  markers: string[],
): string | null {
  const files = fs.readdirSync(directory);
  if (levels === 0) {
    return null;
  } else if (markerExists(files, markers)) {
    return directory;
  } else {
    return traverseParent(path.resolve(directory, '..'), levels - 1, markers);
  }
}

export function traverseChildren(
  directory: string,
  levels: number,
  markers: string[],
): string | null {
  const files = fs.readdirSync(directory);
  if (levels === 0) {
    return null;
  } else if (markerExists(files, markers)) {
    return directory;
  } else {
    for (const file of files) {
      const child = path.join(directory, file);

      if (fs.statSync(child).isDirectory()) {
        const result = traverseChildren(child, levels - 1, markers);
        if (result !== null) {
          return result;
        }
      }
    }
    return null;
  }
}

export function defaultBasePathAndIncludePath() {
  const currentDirectory = process.cwd();

  const parentNodeModules = traverseParent(currentDirectory, 4, NODE_MODULES_MARKER);
  if (parentNodeModules !== null) {
    return [currentDirectory, path.resolve(parentNodeModules, 'node_modules')];
  }

  const childNodeModules = traverseChildren(currentDirectory, 4, NODE_MODULES_MARKER);
  if (childNodeModules !== null) {
    return [currentDirectory, path.resolve(childNodeModules, 'node_modules')];
  }

  return [null, null];
}
