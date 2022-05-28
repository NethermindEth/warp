import assert from 'assert';
import * as path from 'path';
import { execSync } from 'child_process';
import * as fs from 'fs';
import {
  BinaryOperation,
  BoolType,
  Expression,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  IntType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { createCairoFunctionStub } from '../utils/functionGeneration';
import { Implicits } from '../utils/implicits';
import { mapRange, typeNameFromTypeNode } from '../utils/utils';

export function forAllWidths(funcGen: (width: number) => string[]): string[] {
  return mapRange(32, (n) => 8 * (n + 1)).flatMap(funcGen);
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

const warpVenvPrefix = `PATH=${path.resolve('..', '..', 'warp_venv', 'bin')}:$PATH`;

export function generateFile(name: string, imports: string[], functions: string[]): void {
  fs.writeFileSync(
    `./warplib/maths/${name}.cairo`,
    `#AUTO-GENERATED\n${imports.join('\n')}\n\n${functions.join('\n')}\n`,
  );
  execSync(`${warpVenvPrefix} cairo-format -i ./warplib/maths/${name}.cairo`);
}

export function IntxIntFunction(
  node: BinaryOperation,
  name: string,
  appendWidth: 'always' | 'only256' | 'signedOrWide',
  separateSigned: boolean,
  unsafe: boolean,
  implicits: (width: number, signed: boolean) => Implicits[],
  ast: AST,
) {
  const lhsType = typeNameFromTypeNode(getNodeType(node.vLeftExpression, ast.compilerVersion), ast);
  const rhsType = typeNameFromTypeNode(
    getNodeType(node.vRightExpression, ast.compilerVersion),
    ast,
  );
  const retType = getNodeType(node, ast.compilerVersion);
  assert(
    retType instanceof IntType,
    `${printNode(node)} has type ${printTypeNode(retType)}, which is not compatible with ${name}`,
  );
  const shouldAppendWidth =
    appendWidth === 'always' ||
    (appendWidth === 'signedOrWide' && retType.signed) ||
    retType.nBits === 256;
  const fullName = [
    'warp_',
    name,
    retType.signed && separateSigned ? '_signed' : '',
    unsafe ? '_unsafe' : '',

    shouldAppendWidth ? `${retType.nBits}` : '',
  ].join('');

  const importName = [
    'warplib.maths.',
    name,
    retType.signed && separateSigned ? '_signed' : '',
    unsafe ? '_unsafe' : '',
  ].join('');

  const stub = createCairoFunctionStub(
    fullName,
    [
      ['lhs', lhsType],
      ['rhs', rhsType],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
    implicits(retType.nBits, retType.signed),
    ast,
    node,
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
      stub.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, importName, fullName);
}

export function Comparison(
  node: BinaryOperation,
  name: string,
  appendWidth: 'only256' | 'signedOrWide',
  separateSigned: boolean,
  implicits: (wide: boolean, signed: boolean) => Implicits[],
  ast: AST,
): void {
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const rhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);
  const wide = lhsType instanceof IntType && lhsType.nBits === 256;
  const signed = lhsType instanceof IntType && lhsType.signed;
  const shouldAppendWidth = wide || (appendWidth === 'signedOrWide' && signed);
  const fullName = [
    'warp_',
    name,
    separateSigned && signed ? '_signed' : '',
    shouldAppendWidth ? `${lhsType.nBits}` : '',
  ].join('');

  const importName = `warplib.maths.${name}${signed && separateSigned ? '_signed' : ''}`;

  const stub = createCairoFunctionStub(
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
    implicits(wide, signed),
    ast,
    node,
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
      stub.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, importName, fullName);
}

export function IntFunction(
  node: Expression,
  argument: Expression,
  name: string,
  fileName: string,
  implicits: (wide: boolean) => Implicits[],
  ast: AST,
): void {
  const opType = getNodeType(argument, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);
  assert(retType instanceof IntType, `Expected IntType for ${name}, got ${printTypeNode(retType)}`);
  const fullName = `warp_${name}${retType.nBits}`;
  const stub = createCairoFunctionStub(
    fullName,
    [['op', typeNameFromTypeNode(opType, ast)]],
    [['res', typeNameFromTypeNode(retType, ast)]],
    implicits(retType.nBits === 256),
    ast,
    node,
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
      stub.id,
    ),
    [argument],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, `warplib.maths.${fileName}`, fullName);
}

export function BoolxBoolFunction(node: BinaryOperation, name: string, ast: AST): void {
  const lhsType = getNodeType(node.vLeftExpression, ast.compilerVersion);
  const rhsType = getNodeType(node.vRightExpression, ast.compilerVersion);
  const retType = getNodeType(node, ast.compilerVersion);

  assert(
    lhsType instanceof BoolType,
    `Expected BoolType for ${name} left argument, got ${printTypeNode(lhsType)}`,
  );
  assert(
    rhsType instanceof BoolType,
    `Expected BoolType for ${name} right argument, got ${printTypeNode(rhsType)}`,
  );
  assert(
    retType instanceof BoolType,
    `Expected BoolType for ${name} return type, got ${printTypeNode(retType)}`,
  );

  const fullName = `warp_${name}`;
  const stub = createCairoFunctionStub(
    fullName,
    [
      ['lhs', typeNameFromTypeNode(lhsType, ast)],
      ['rhs', typeNameFromTypeNode(rhsType, ast)],
    ],
    [['res', typeNameFromTypeNode(retType, ast)]],
    [],
    ast,
    node,
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
      stub.id,
    ),
    [node.vLeftExpression, node.vRightExpression],
  );

  ast.replaceNode(node, call);
  ast.registerImport(call, `warplib.maths.${name}`, fullName);
}
