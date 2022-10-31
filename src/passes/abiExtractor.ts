import assert from 'assert';
import { readFileSync } from 'fs';
import prompts from 'prompts';
import {
  ArrayType,
  ArrayTypeName,
  FunctionDefinition,
  generalizeType,
  Literal,
  SourceUnit,
  StateVariableVisibility,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import Web3 from 'web3';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { CLIError } from '../utils/errors';
import { parse } from '../utils/functionSignatureParser';
import { generateLiteralTypeString } from '../utils/getTypeString';
import { createDefaultConstructor, createNumberLiteral } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { isExternallyVisible } from '../utils/utils';

type Input = (string | number | Input)[];

export class ABIExtractor extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);
    node.vFunctions.forEach((fd) =>
      addSignature(node, ast, fd.canonicalSignature(ABIEncoderVersion.V2), returnSignature(fd)),
    );
    node.vContracts
      .flatMap((cd) => cd.vLinearizedBaseContracts)
      .forEach((cd) => {
        if (!cd.abstract) {
          // We do this to trick the canonicalSignature method into giving us a result
          const fakeConstructor =
            cd.vConstructor !== undefined
              ? cloneASTNode(cd.vConstructor, ast)
              : createDefaultConstructor(cd, ast);
          fakeConstructor.isConstructor = false;
          fakeConstructor.name = 'constructor';
          addSignature(
            node,
            ast,
            fakeConstructor.canonicalSignature(ABIEncoderVersion.V2),
            returnSignature(fakeConstructor),
          );
        }
        cd.vFunctions.forEach((fd) => {
          if (isExternallyVisible(fd)) {
            addSignature(
              node,
              ast,
              fd.canonicalSignature(ABIEncoderVersion.V2),
              returnSignature(fd),
            );
          }
        });
        cd.vStateVariables.forEach((vd) => {
          if (vd.visibility === StateVariableVisibility.Public) {
            addSignature(node, ast, vd.getterCanonicalSignature(ABIEncoderVersion.V2));
          }
        });
      });
  }

  // The CanonicalSignature fails for ArrayTypeNames with non-literal, non-undefined length
  // This replaces such cases with literals
  visitArrayTypeName(node: ArrayTypeName, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vLength !== undefined && !(node.vLength instanceof Literal)) {
      const type = generalizeType(safeGetNodeType(node, ast.compilerVersion))[0];
      assert(
        type instanceof ArrayType,
        `${printNode(node)} ${node.typeString} has non-array type ${printTypeNode(type, true)}`,
      );
      assert(type.size !== undefined, `Static array ${printNode(node)} ${node.typeString}`);
      const literal = createNumberLiteral(
        type.size,
        ast,
        generateLiteralTypeString(type.size.toString()),
      );
      node.vLength = literal;
      ast.registerChild(node.vLength, node);
    }
  }
}

function addSignature(node: SourceUnit, ast: AST, signature: string, returns: string = '') {
  const abi = ast.abi.get(node.id);
  const signature_with_return: [string, string] = [signature, returns];
  if (abi === undefined) {
    ast.abi.set(node.id, new Set([signature_with_return]));
  } else {
    abi.add(signature_with_return);
  }
}

function returnSignature(funcDef: FunctionDefinition): string {
  const return_params = funcDef.vReturnParameters.vParameters
    .map((vd) => vd.canonicalSignatureType(ABIEncoderVersion.V2))
    .join(',');

  return `${return_params}`;
}

export function dumpABI(node: SourceUnit, ast: AST): string {
  return JSON.stringify([...(ast.abi.get(node.id) || new Set()).keys()]);
}

export function transcodeCalldata(funcSignature: string, inputs: Input): bigint[] {
  return parse(funcSignature)(inputs);
}

export async function encodeInputs(
  filePath: string,
  func: string,
  useCairoABI: boolean,
  rawInputs?: string[],
): Promise<[string, string]> {
  if (useCairoABI) {
    const inputs = rawInputs ? `--inputs ${rawInputs.join(' ').split(',').join(' ')}` : '';
    return [func, inputs];
  }

  const solABI = parseSolAbi(filePath);
  const [funcSignature, _] = await selectSignature(solABI, func);
  const selector = new Web3().utils.keccak256(funcSignature).substring(2, 10);

  const funcName = `${func}_${selector}`;
  const inputs = rawInputs
    ? `--inputs ${transcodeCalldata(funcSignature, parseInputs(rawInputs.join(' ')))
        .map((i) => i.toString())
        .join(' ')}`
    : '';

  return [funcName, inputs];
}

function parseInputs(input: string): Input {
  try {
    const parsedInput = JSON.parse(`[${input}]`.replaceAll(/\b0x[0-9a-fA-F]+/g, (s) => `"${s}"`));
    validateInput(parsedInput);
    return parsedInput;
  } catch (e: unknown) {
    throw new CLIError('Input must be a comma separated list of numbers, strings and lists');
  }
}

function validateInput(input: unknown) {
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

export function parseSolAbi(filePath: string): string[] {
  const re = /\/\/ Original solidity abi: (?<abi>[\w()\][, "]*)/;
  const abiString = readFileSync(filePath, 'utf-8');
  const matches = abiString.match(re);
  if (matches === null || matches.groups === undefined) {
    throw new CLIError(
      "Couldn't find Solidity ABI in file, please include one in the form '// Original solidity abi: [func1(type1,type2,...)]",
    );
  }
  const solAbi = JSON.parse(matches.groups.abi);
  validateSolAbi(solAbi);
  return solAbi;
}

function validateSolAbi(solABI: unknown) {
  if (solABI instanceof Array) {
    if (
      !solABI.every(
        (v) => v instanceof Array && typeof v[0] === 'string' && typeof v[1] === 'string',
      )
    )
      throw new CLIError('Solidity abi in file is not a list of function signatures');
  } else {
    throw new CLIError('Solidity abi in file is not a list of function signatures.');
  }
}

export async function selectSignature(abi: string[], funcName: string): Promise<string> {
  const matches = abi.filter(([fs, _]) => fs.startsWith(funcName));
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
