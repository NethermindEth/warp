import assert from 'assert';
import { Implicits } from './implicits';

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
  const functions = [...rawFunctions.matchAll(/fn (\w+)/gis)];

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
    rawFunction.match(/fn (?<name>\w+)/);

  assert(
    funcSignature !== null && funcSignature.groups !== undefined,
    `Invalid parsing of raw string function:\n${rawFunction}`,
  );

  const name = funcSignature.groups.name;

  const implicits =
    funcSignature.groups.implicits !== undefined ? ['warp_memory' as Implicits] : [];

  return { name, implicits };
}
