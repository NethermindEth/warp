import assert from 'assert';
import * as fs from 'fs';
import {
  BinaryOperation,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  IntType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { mapRange, typeNameFromTypeNode } from '../utils/utils';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import path from 'path';
import { WARPLIB_MATHS } from '../utils/importPaths';

export const PATH_TO_WARPLIB = path.join('.', 'warplib', 'src');

export type WarplibFunctionInfo = {
  fileName: string;
  imports: string[];
  functions: string[];
};

export function forAllWidths<T>(funcGen: (width: number) => T): T[] {
  return mapRange(32, (n) => 8 * (n + 1)).map(funcGen);
}

export function pow2(n: number): bigint {
  return 2n ** BigInt(n);
}

export function uint256(n: bigint | number): string {
  if (typeof n === 'number') {
    n = BigInt(n);
  }
  const low = n % 2n ** 128n;
  const high = (n - low) / 2n ** 128n;
  return `Uint256(0x${low.toString(16)}, 0x${high.toString(16)})`;
}

export function bound(width: number): string {
  return `0x${pow2(width).toString(16)}`;
}

export function mask(width: number): string {
  return `0x${(pow2(width) - 1n).toString(16)}`;
}

export function msb(width: number): string {
  return `0x${pow2(width - 1).toString(16)}`;
}

export function msbAndNext(width: number): string {
  return `0x${(pow2(width) + pow2(width - 1)).toString(16)}`;
}

// This is used along with the commented out code in generateFile to enable cairo-formatting
// const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', '..', 'warp_venv', 'bin')}:$PATH`;

export function generateFile(warpFunc: WarplibFunctionInfo): void {
  const pathToFile = path.join(PATH_TO_WARPLIB, 'maths', `${warpFunc.fileName}.cairo`);

  fs.writeFileSync(
    pathToFile,
    `//AUTO-GENERATED\n${warpFunc.imports.join('\n')}\n\n${warpFunc.functions.join('\n')}\n`,
  );
  // Disable cairo-formatting for now, as it has a bug that breaks the generated code
  // execSync(`${warpVenvPrefix} cairo-format -i ./warplib/maths/${name}.cairo`);
}

export function IntxIntFunction(
  node: BinaryOperation,
  name: string,
  appendWidth: 'always' | 'only256' | 'signedOrWide',
  separateSigned: boolean,
  unsafe: boolean,
  ast: AST,
) {
  const lhsType = typeNameFromTypeNode(safeGetNodeType(node.vLeftExpression, ast.inference), ast);
  const rhsType = typeNameFromTypeNode(safeGetNodeType(node.vRightExpression, ast.inference), ast);
  const retType = safeGetNodeType(node, ast.inference);
  assert(
    retType instanceof IntType || retType instanceof FixedBytesType,
    `${printNode(node)} has type ${printTypeNode(retType)}, which is not compatible with ${name}`,
  );
  const width = getIntOrFixedByteBitWidth(retType);
  const signed = retType instanceof IntType && retType.signed;
  const shouldAppendWidth =
    appendWidth === 'always' || (appendWidth === 'signedOrWide' && signed) || width === 256;
  const fullName = [
    'warp_',
    name,
    signed && separateSigned ? '_signed' : '',
    unsafe ? '_unsafe' : '',
    shouldAppendWidth ? `${width}` : '',
  ].join('');

  const importName = [
    ...WARPLIB_MATHS,
    `${name}${signed && separateSigned ? '_signed' : ''}${unsafe ? '_unsafe' : ''}`,
  ];

  const importedFunc = ast.registerImport(
    node,
    importName,
    fullName,
    [
      ['lhs', lhsType],
      ['rhs', rhsType],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
  );

  const call = new FunctionCall(
    ast.reserveId(),
    node.src,
    node.typeString,
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      `function (${node.typeString}, ${node.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
}

export function Comparison(
  node: BinaryOperation,
  name: string,
  appendWidth: 'only256' | 'signedOrWide',
  separateSigned: boolean,
  ast: AST,
): void {
  const lhsType = safeGetNodeType(node.vLeftExpression, ast.inference);
  const rhsType = safeGetNodeType(node.vLeftExpression, ast.inference);
  const retType = safeGetNodeType(node, ast.inference);
  const wide =
    (lhsType instanceof IntType || lhsType instanceof FixedBytesType) &&
    getIntOrFixedByteBitWidth(lhsType) === 256;
  const signed = lhsType instanceof IntType && lhsType.signed;
  const shouldAppendWidth = wide || (appendWidth === 'signedOrWide' && signed);
  const fullName = [
    'warp_',
    name,
    separateSigned && signed ? '_signed' : '',
    shouldAppendWidth ? `${getIntOrFixedByteBitWidth(lhsType)}` : '',
  ].join('');

  const importName = [...WARPLIB_MATHS, `${name}${signed && separateSigned ? '_signed' : ''}`];

  const importedFunc = ast.registerImport(
    node,
    importName,
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
  );

  const call = new FunctionCall(
    ast.reserveId(),
    node.src,
    node.typeString,
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      `function (${node.vLeftExpression.typeString}, ${node.vRightExpression.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
}

export function IntFunction(
  node: Expression,
  argument: Expression,
  name: string,
  fileName: string,
  ast: AST,
): void {
  const opType = safeGetNodeType(argument, ast.inference);
  const retType = safeGetNodeType(node, ast.inference);
  assert(
    retType instanceof IntType || retType instanceof FixedBytesType,
    `Expected IntType or FixedBytes for ${name}, got ${printTypeNode(retType)}`,
  );
  const width = getIntOrFixedByteBitWidth(retType);
  const fullName = `warp_${name}${width}`;

  const importedFunc = ast.registerImport(
    node,
    [...WARPLIB_MATHS, fileName],
    fullName,
    [['op', typeNameFromTypeNode(opType, ast)]],
    [['res', typeNameFromTypeNode(retType, ast)]],
  );

  const call = new FunctionCall(
    ast.reserveId(),
    node.src,
    node.typeString,
    FunctionCallKind.FunctionCall,
    new Identifier(
      ast.reserveId(),
      '',
      `function (${argument.typeString}) returns (${node.typeString})`,
      fullName,
      importedFunc.id,
    ),
    [argument],
  );

  ast.replaceNode(node, call);
}

export function getIntOrFixedByteBitWidth(type: TypeNode): number {
  if (type instanceof IntType) {
    return type.nBits;
  } else if (type instanceof FixedBytesType) {
    return type.size * 8;
  } else {
    assert(
      false,
      `Attempted to get width for non-int, non-fixed bytes type ${printTypeNode(type)}`,
    );
  }
}
