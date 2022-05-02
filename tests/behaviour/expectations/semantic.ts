import { readFileSync } from 'fs';
import AbiCoder from 'web3-eth-abi';
import {
  AddressType,
  ArrayType,
  BoolType,
  BuiltinStructType,
  BuiltinType,
  BytesType,
  FixedBytesType,
  FunctionType,
  IntType,
  MappingType,
  PointerType,
  StringType,
  TypeNode,
  UserDefinedType,
  ContractDefinition,
  FunctionDefinition,
  VariableDeclaration,
  compileSol,
  resolveAny,
  getNodeType,
  CompileResult,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import * as path from 'path';
import tests from '../test_calldata';
import { InvalidTestError, NotYetSuportedTestCaseError } from '../errors';

import whiteList from './semantic_whitelist';

import { NotSupportedYetError } from '../../../src/utils/errors';
import { compileSolFile } from '../../../src/solCompile';
import { printTypeNode } from '../../../src/utils/astPrinter';
import { bigintToTwosComplement, divmod } from '../../../src/utils/utils';
import { AsyncTest, Expect } from './types';
import { error } from '../../../src/utils/formatting';
import { notNull } from '../../../src/utils/typeConstructs';
import assert from 'assert';

// this format will cause problems with overloading
export interface Parameter {
  type: string;
  name: string;
  components?: Parameter[];
}

interface FunABI {
  name: string;
  inputs: Parameter[];
  outputs: Parameter[];
}

export interface ITestCalldata {
  callData: string;
  expectations: string;
  failure: boolean;
  signature: string;
  expectedSideEffects?: string[];
}

type SolValue = string | SolValue[] | { [key: string]: SolValue };

//@ts-ignore: web3-eth-abi has their exports wrong
const abiCoder: AbiCoder = new AbiCoder.constructor();
const uint128 = BigInt('0x100000000000000000000000000000000');
const uint8 = BigInt('0x100');

// ----------------------- Gather all the tests ------------------------------
// This could benefit from some parallelism
function isValidTestName(testFileName: string) {
  let file = testFileName;
  while (file !== '.' && file !== '/') {
    if (whiteList.includes(file)) return true;
    file = path.dirname(file);
  }
  return false;
}
// This needs to be a reduce instead of filter because of the type system
const validTests = Object.entries(tests).reduce(
  (tests: [string, ITestCalldata[]][], [f, v]) =>
    v !== null && isValidTestName(f) ? tests.concat([[f, v]]) : tests,
  [],
);

// ------------------------ Export the tests ---------------------------------

// solc-typed-ast downloads compilers on demand, running a single compilation fully
// before the others ensures that the compiler is set up properly before being used
// asynchronously
const initialRun: Promise<CompileResult> =
  validTests.length > 0
    ? compileSol(validTests[0][0], 'auto', [])
    : Promise.resolve({ data: null, files: new Map(), inferredRemappings: new Map() });

export const expectations: AsyncTest[] = validTests.map(([file, tests]): AsyncTest => {
  // The solidity test dsl assumes the last contract defined in the file is
  // the target of the function calls. solc-typed-ast sorts the contracts
  // so we need to do a dumb regex to find the right contract
  const contractNames = [...readFileSync(file, 'utf-8').matchAll(/contract (\w+)/g)].map(
    ([_, name]) => name,
  );
  const lastContract = contractNames[contractNames.length - 1];
  const truncatedFileName = file.substring(0, file.length - '.sol'.length);
  return new AsyncTest(
    truncatedFileName,
    lastContract,
    [],
    transcodeTests(file, tests, lastContract, initialRun),
  );
});

// ------------------------ Transcode the tests ------------------------------

async function transcodeTests(
  file: string,
  expectations: ITestCalldata[],
  lastContract: string,
  initialRun: Promise<CompileResult>,
): Promise<Expect[]> {
  await initialRun;
  // Get the abi of the contract for web3
  const source = await compileSol(file, 'auto', []);
  const contracts: { [key: string]: { abi: FunABI[] } } = source.data.contracts[file];
  const abi = contracts[lastContract].abi;

  // Get the ast itself so we can resolve the types for our type conversion
  // later
  const ast = compileSolFile(file, false);
  const astRoot = ast.roots[ast.roots.length - 1];
  const [contractDef] = astRoot
    .getChildrenByType(ContractDefinition, true)
    .filter((contract) => contract.name === lastContract);

  const compilerVersion = ast.compilerVersion;
  // Transcode each test
  return expectations
    .map((test) => {
      try {
        return transcodeTest(abi, contractDef, test, compilerVersion);
      } catch (e) {
        console.log(error(`Failed to transcode ${test.signature}: ${e}`));
        return null;
      }
    })
    .filter(notNull);
}

function transcodeTest(
  abi: FunABI[],
  contractDef: ContractDefinition,
  { signature, callData, expectations, failure }: ITestCalldata,
  compilerVersion: string,
): Expect {
  if (signature === '' || signature === '()') {
    throw new InvalidTestError('Fallback functions are not supported');
  }
  if (signature === 'constructor()') {
    throw new NotYetSuportedTestCaseError('Constructors not supported in tests yet');
  }

  const [functionName] = signature.split('(');

  // Find the function definition in the ast
  const defs = Array.from(resolveAny(functionName, contractDef, compilerVersion, true)).filter(
    (def) => {
      if (def instanceof FunctionDefinition) {
        return def.canonicalSignature(ABIEncoderVersion.V2) === signature;
      } else if (def instanceof VariableDeclaration) {
        return def.getterCanonicalSignature(ABIEncoderVersion.V2) === signature;
      }
      return false;
    },
  ) as (FunctionDefinition | VariableDeclaration)[];
  if (defs.length === 0) {
    throw new InvalidTestError(
      `No function definition found for test case ${signature} in the ast.\n` +
        `Defined functions:\n` +
        `\t${defs.map((d) => {
          if (d instanceof FunctionDefinition) {
            return d.canonicalSignature(ABIEncoderVersion.V2);
          }
          if (d instanceof VariableDeclaration) {
            return d.getterCanonicalSignature(ABIEncoderVersion.V2);
          }
          return `Unknown def ${d}`;
        })}`,
    );
  }
  if (defs.length > 1) {
    throw new InvalidTestError(
      `Multiple function definitions found for test case ${signature} in the ast.` +
        `Defined functions:\n` +
        `\t${defs}`,
    );
  }

  // Find the function definition in the abi
  const funcAbis = abi.filter((funAbi) => getSignature(funAbi) === signature);
  if (funcAbis.length === 0) {
    throw new InvalidTestError(
      `No function definition found for test case ${signature} in web3 abi\n` +
        `Defined functions:\n` +
        `\t${abi.map((v) => getSignature(v))}`,
    );
  }
  if (funcAbis.length > 1) {
    throw new InvalidTestError(
      `Multiple function definitions found for test case ${signature}\n` +
        `Defined functions:\n` +
        `\t${abi.map((v) => getSignature(v))}`,
    );
  }

  const [funcDef] = defs;
  const [funcAbi] = funcAbis;

  const inputTypeNodes =
    funcDef instanceof FunctionDefinition
      ? funcDef.vParameters.vParameters.map((cd) => getNodeType(cd, compilerVersion))
      : funcDef.getterFunType().parameters;
  const outputTypeNodes =
    funcDef instanceof FunctionDefinition
      ? funcDef.vReturnParameters.vParameters.map((cd) => getNodeType(cd, compilerVersion))
      : funcDef.getterFunType().returns;

  const input = encode(funcAbi.inputs, inputTypeNodes, '0x' + callData.substr(10));
  const output = failure ? null : encode(funcAbi.outputs, outputTypeNodes, expectations);

  const functionHash =
    funcDef instanceof FunctionDefinition
      ? funcDef.canonicalSignatureHash(ABIEncoderVersion.V2)
      : funcDef.getterCanonicalSignatureHash(ABIEncoderVersion.V2);

  return Expect.Simple(`${functionName}_${functionHash}`, input, output);
}

function encode(abi: Parameter[], typeNodes: TypeNode[], encodedData: string): string[] {
  const inputs_ = abiCoder.decodeParameters(abi, encodedData);
  return (
    Object.entries(inputs_)
      // output of parameter decodes encodes parameters in an object with
      // each enty duplicated, one with their parameter name the other as a
      // simple index into the parameter list. Here we filter for those indexes
      .filter(([key, _]) => !isNaN(parseInt(key)))
      // borked types from import, see above
      .map(([_, val]) => val as SolValue)
      .flatMap((v: SolValue, i) => encodeValue(typeNodes[i], v))
  );
}

// ------------------- Encode solidity values as cairo values ----------------

export function encodeValue(tp: TypeNode, value: SolValue): string[] {
  if (tp instanceof IntType) {
    if (!(value instanceof String || typeof value === 'string')) {
      throw new Error(`Can't encode ${value} as inttype`);
    }
    let val: bigint;
    try {
      val = bigintToTwosComplement(BigInt(value.toString()), tp.nBits);
    } catch {
      throw new Error(`Can't encode ${value} as intType`);
    }
    if (tp.nBits > 251) {
      const [high, low] = divmod(val, uint128);
      return [low.toString(), high.toString()];
    } else {
      return [val.toString()];
    }
  } else if (tp instanceof ArrayType) {
    if (!(value instanceof Array)) {
      throw new Error(`Can't encode ${value} as arrayType`);
    }
    return [value.length.toString(), ...value.flatMap((v) => encodeValue(tp.elementT, v))];
  } else if (tp instanceof BoolType) {
    if (typeof value !== 'boolean') {
      throw new Error(`Can't encode ${value} as boolType`);
    }
    return [value ? '1' : '0'];
  } else if (tp instanceof BytesType) {
    if (typeof value !== 'string') {
      throw new Error(`Can't encode ${value} as bytesType`);
    }
    // removing 0x
    value = value.substring(2);
    const length = value.length / 2;
    assert(length === Math.floor(length), 'bytes must be even');

    const cairoBytes: string[] = [];
    for (let index = 0; index < value.length; index += 2) {
      const byte = value.substring(index, index + 2);
      cairoBytes.push(BigInt('0x' + byte).toString());
    }
    return [length.toString(), cairoBytes].flat();
  } else if (tp instanceof FixedBytesType) {
    let val: bigint;
    try {
      val = bigintToTwosComplement(BigInt(value.toString()), tp.size * 8);
    } catch {
      throw new Error(`Can't encode ${value} as fixedBytesType`);
    }
    if (tp.size > 31) {
      const [high, low] = divmod(val, uint128);
      return [low.toString(), high.toString()];
    } else {
      return [val.toString()];
    }
  } else if (tp instanceof StringType) {
    if (typeof value !== 'string') {
      throw new Error(`Can't encode ${value} as stringType`);
    }
    const valueEncoded: number[] = Buffer.from(value).toJSON().data;

    const byteString: string[] = [];
    valueEncoded.forEach((val) => byteString.push(val.toString()));

    return [byteString.length.toString()].concat(byteString);
  } else if (tp instanceof AddressType) {
    if (!(value instanceof String || typeof value === 'string')) {
      throw new Error(`Can't encode ${value} as addressType`);
    }
    let val: bigint;
    try {
      val = BigInt(value.toString());
    } catch {
      throw new Error(`Can't encode ${value} as intType`);
    }
    return [val.toString()];
  } else if (tp instanceof BuiltinType) {
    throw new NotSupportedYetError('Serialising BuiltinType not supported yet');
  } else if (tp instanceof BuiltinStructType) {
    throw new NotSupportedYetError('Serialising BuiltinStructType not supported yet');
  } else if (tp instanceof MappingType) {
    throw new Error('Mappings cannot be serialised as external function paramenters');
  } else if (tp instanceof UserDefinedType) {
    throw new NotSupportedYetError('Serialising UserDefinedType not supported yet');
  } else if (tp instanceof FunctionType) {
    throw new NotSupportedYetError('Serialising FunctionType not supported yet');
  } else if (tp instanceof PointerType) {
    throw new Error('PointerTypes cannot be serialised as external function paramenters');
  }
  throw new Error(`Don't know how to convert type ${printTypeNode(tp)}`);
}

// ------------------------------ utils --------------------------------------

function getSignature(abi: FunABI): string {
  return `${abi.name || 'constructor'}(${abi.inputs.map(formatSigType).join(',')})`;
}

function formatSigType(type: Parameter): string {
  return type.components === undefined
    ? type.type
    : type.type.replace('tuple', '(' + type.components.map(formatSigType).join(',') + ')');
}
