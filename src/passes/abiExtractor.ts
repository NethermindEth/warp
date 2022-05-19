import { readFileSync } from 'fs';
import prompts from 'prompts';
import { SourceUnit } from 'solc-typed-ast';
import Web3 from 'web3';
import { ICallOrInvokeProps } from '..';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { CLIError } from '../utils/errors';
import { parse } from '../utils/functionSignatureParser';

type Input = (string | number | Input)[];

export class ABIExtractor extends ASTMapper {
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vFunctions.forEach((fd) =>
      // @ts-ignore
      addSignature(node, ast, fd.canonicalSignature('ABIEncoderV2')),
    );
    node.vContracts.forEach((cd) =>
      cd.vFunctions.forEach((fd) =>
        // @ts-ignore
        addSignature(node, ast, fd.canonicalSignature('ABIEncoderV2')),
      ),
    );
  }
}

function addSignature(node: SourceUnit, ast: AST, signature: string) {
  const abi = ast.abi.get(node.id);
  if (abi === undefined) {
    ast.abi.set(node.id, new Set([signature]));
  } else {
    abi.add(signature);
  }
}

export function dumpABI(node: SourceUnit, ast: AST): string {
  return JSON.stringify([...(ast.abi.get(node.id) || new Set()).keys()]);
}

export function transcodeCalldata(funcSignature: string, inputs: Input): bigint[] {
  return parse(funcSignature)(inputs);
}

export async function encodeInputs(
  filePath: string,
  options: ICallOrInvokeProps,
): Promise<[string, string]> {
  if (options.useCairoABI) {
    const inputs = options.inputs ? `--inputs ${options.inputs.split(',').join(' ')}` : '';
    return [options.function, inputs];
  }

  const solABI = parseSolAbi(filePath);
  const funcSignature = await selectSignature(solABI, options.function);
  const selector = new Web3().utils.keccak256(funcSignature).substring(2, 10);

  const funcName = `${options.function}_${selector}`;
  const inputs = options.inputs
    ? `--inputs ${transcodeCalldata(funcSignature, parseInputs(options.inputs))
        .map((i) => i.toString())
        .join(' ')}`
    : '';

  console.log(options.inputs);
  return [funcName, inputs];
}

function parseInputs(input: string): Input {
  try {
    const parsedInput = JSON.parse(`[${input}]`);
    validateInput(parsedInput);
    return parsedInput;
  } catch {
    throw new CLIError('Input must be a comma seperated list of numbers, strings and lists');
  }
}

function validateInput(input: any) {
  if (input instanceof Array) {
    input.map(validateInput);
    return;
  }
  if (input instanceof String) return;
  if (input instanceof Number) return;
  if (typeof input === 'string') return;
  if (typeof input === 'number') return;
  throw new CLIError('Input invalid');
}

function parseSolAbi(filePath: string): string[] {
  const re = /# SolABI: (?<abi>[\w\(\)\]\[, "]*)/;
  const abiString = readFileSync(filePath, 'utf-8');
  const matches = abiString.match(re);
  if (matches === null || matches.groups === undefined) {
    throw new CLIError(
      "Couldn't find solidity abi in file, please include one in the form '# SolABI: [func1(type1,type2),...]",
    );
  }
  const solAbi = JSON.parse(matches.groups.abi);
  validateSolAbi(solAbi);
  return solAbi;
}

function validateSolAbi(solABI: any) {
  if (solABI instanceof Array) {
    if (!solABI.every((v) => v instanceof String || typeof v === 'string'))
      throw new CLIError('Solidity abi in file is not a list of function signatures');
  } else {
    throw new CLIError('Solidity abi in file is not a list of function signatures.');
  }
}

export async function selectSignature(abi: string[], funcName: string): Promise<string> {
  const matches = abi.filter((fs) => fs.startsWith(funcName));
  if (!matches.length) {
    throw new CLIError(`No function in abi with name ${funcName}`);
  }

  if (matches.length === 1) return matches[0];

  const choice = await prompts({
    type: 'select',
    name: 'func',
    message: `Multiple function definitions found for ${funcName}. Please select one now:`,
    choices: matches.map((func) => ({ title: func, value: func })),
  });

  return choice.func;
}
