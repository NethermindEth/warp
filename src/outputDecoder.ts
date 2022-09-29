import { Result } from 'ethers/lib/utils';
import {
  AddressType,
  ArrayType,
  BoolType,
  BytesType,
  FixedBytesType,
  getNodeTypeInCtx,
  IntType,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { BigNumber, BigNumberish } from 'ethers';
import { isStruct } from './utils/nodeTypeProcessing';
import { parseSolAbi, selectSignature } from './passes/abiExtractor';
import { parse } from './utils/functionSignatureParser';

export async function decodeOutputs(
  filePath: string,
  func: string,
  rawOutputs?: string[],
): Promise<Result> {
  const solABI = parseSolAbi(filePath);
  const funcSignature = await selectSignature(solABI, func);
  const outputSignatures = returnSignatures(funcSignature);

  const outputNodes: TypeNode[] = outputSignatures.map((os) => parse(os) as TypeNode);
  const outputs: IterableIterator<string> = rawOutputs?.values() as IterableIterator<string>;

  return decode(outputNodes, outputs);
}

function returnSignatures(funcSignature: string): string[] {
  const outputs = funcSignature.split(':')[1];
  const outputSignatures = outputs.split(',');

  return outputSignatures;
}

export function decode(types: TypeNode[], outputs: IterableIterator<string>): Result {
  return types.map((ty) => {
    if (isPrimitiveNode(ty)) {
      return decodePrimitive(ty, outputs);
    } else {
      return decodeComplex(ty, outputs);
    }
  });
}

export function isPrimitiveNode(type: TypeNode): boolean {
  return !(type instanceof ArrayType || isStruct(type));
}

function decodePrimitive(
  typeNode: TypeNode,
  outputs: IterableIterator<string>,
): BigNumberish | boolean {
  if (typeNode instanceof IntType && !(typeNode as IntType).signed) {
    return decodeUint(
      typeNode.nBits.toString().length > 4 ? parseInt(typeNode.nBits.toString().slice(4), 10) : 256,
      outputs,
    );
  }
  if (typeNode instanceof IntType && (typeNode as IntType).signed) {
    return decodeInt(
      typeNode.nBits.toString().length > 3 ? parseInt(typeNode.nBits.toString().slice(3), 10) : 256,
      outputs,
    );
  }
  if (typeNode instanceof AddressType) {
    return readFelt(outputs);
  }
  if (typeNode instanceof BoolType) {
    return readFelt(outputs) === 0n ? false : true;
  }
  if (typeNode instanceof FixedBytesType) {
    throw new Error('Not Supported');
  }
  if (typeNode instanceof BytesType) {
    return typeNode.pp().length === 5
      ? decodeBytes(outputs)
      : decodeFixedBytes(outputs, parseInt(typeNode.pp().slice(5)));
  }
  return 1n;
}

function readFelt(outputs: IterableIterator<string>): bigint {
  return BigInt(outputs.next().value);
}

function useNumberIfSafe(n: bigint, width: number): BigNumber | number {
  return width <= 48 ? Number(n) : BigNumber.from(n);
}

function readUint(outputs: IterableIterator<string>): bigint {
  const low = BigInt(outputs.next().value);
  const high = BigInt(outputs.next().value);
  return (high << 128n) + low;
}

function decodeUint(nbits: number, outputs: IterableIterator<string>): BigNumber | number {
  return useNumberIfSafe(nbits < 256 ? readFelt(outputs) : readUint(outputs), nbits);
}

function decodeInt(nbits: number, outputs: IterableIterator<string>): BigNumber | number {
  return useNumberIfSafe(
    twosComplementToBigInt(nbits < 256 ? BigInt(readFelt(outputs)) : readUint(outputs), nbits),
    nbits,
  );
}

function decodeBytes(outputs: IterableIterator<string>): bigint {
  const len = readFelt(outputs);
  let result = 0n;
  for (let i = 0; i < len; i++) {
    result << 8n;
    result += BigInt(readFelt(outputs));
  }
  return result;
}

function decodeFixedBytes(outputs: IterableIterator<string>, length: number): BigNumber | number {
  return useNumberIfSafe(length < 32 ? readFelt(outputs) : readUint(outputs), length * 8);
}

export function twosComplementToBigInt(val: bigint, width: number): bigint {
  const mask = 2n ** BigInt(width) - 1n;
  const max = 2n ** BigInt(width - 1) - 1n;
  if (val > max) {
    // Negative number
    const pos = (val ^ mask) + 1n;
    return -pos;
  } else {
    // Positive numbers as are
    return val;
  }
}

export function decodeComplex(type: TypeNode, outputs: IterableIterator<string>) {
  if (type instanceof ArrayType) {
    // array type
    const length = Number(type.size) === -1 ? readFelt(outputs) : Number(type.size);
    const result: Result = [];
    for (let i = 0; i < length; ++i) {
      result.push(decode(type.getChildren(), outputs));
    }
    return result;
  } else if (isStruct(type)) {
    // struct type
    const indexedMembers = type.getChildren().map((m) => decode([m], outputs));
    const namedMembers: { [key: string]: any } = {};
    type.getChildren().forEach((member, i) => {
      namedMembers[(member as UserDefinedType).name] = indexedMembers[i];
    });

    return { ...namedMembers, ...indexedMembers } as Result;
  }
}
