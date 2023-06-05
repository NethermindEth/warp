import assert from 'assert';
import { Implicits } from './utils';

export type RawCairoFunctionInfo = {
  name: string;
  implicits: Implicits[];
};

/**
 * Given several Cairo function represented in plain text extracts information from it
 *  @param rawFunctions Multiple cairo functions in a single text
 *  @returns A list of each function information
 */
export function parseMultipleRawCairoFunctions(rawFunctions: string): RawCairoFunctionInfo[] {
  const functions = [...rawFunctions.matchAll(/#\[implicit\((.+)\)\](\s+)fn (\w+)|^fn (\w+)/gims)];

  return [...functions].map((func) => getRawCairoFunctionInfo(func[0]));
}

/**
 * Given a Cairo function represented in plain text extracts information from it
 *  @param rawFunction Cairo code
 *  @returns The function implicits and it's name
 */
export function getRawCairoFunctionInfo(rawFunction: string): RawCairoFunctionInfo {
  const funcSignature =
    rawFunction.match(/#\[implicit\((?<implicits>.+)\)\](\s+)fn (?<name>\w+)/) ??
    rawFunction.match(/^fn (?<name>\w+)/m);

  assert(
    funcSignature !== null && funcSignature.groups !== undefined,
    `Invalid parsing of raw string function:\n${rawFunction}`,
  );

  const name = funcSignature.groups.name;

  const implicits =
    funcSignature.groups.implicits !== undefined ? ['warp_memory' as Implicits] : [];

  return { name, implicits };
}

/**
 * Given Cairo code represented in plain text extracts information of traits and structs from it
 *  @param rawFunctions Multiple cairo code lines in a single text
 *  @returns The name of traits and structs defined
 */
export function parseCairoTraitsAndStructs(rawCode: string): string[] {
  const traitsAndStructs = [...rawCode.matchAll(/struct (\w+)|trait (\w+)/gis)];

  return [...traitsAndStructs].map((func) => getRawCairoTraitsAndStructsName(func[0]));
}

/**
 * Given a Cairo function represented in plain text extracts the names of traits and structs from it
 *  @param rawFunction Cairo code
 *  @returns The function implicits and it's name
 */
export function getRawCairoTraitsAndStructsName(rawCode: string): string {
  const traitsAndStructsSignature =
    rawCode.match(/struct (?<name>\w+)/) ?? rawCode.match(/trait (?<name>\w+)/);

  assert(
    traitsAndStructsSignature !== null && traitsAndStructsSignature.groups !== undefined,
    `Invalid parsing of raw string function:\n${traitsAndStructsSignature}`,
  );

  const name = traitsAndStructsSignature.groups.name;
  return name;
}
