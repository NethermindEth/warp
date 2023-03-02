import assert from 'assert';
import { TranspileFailedError } from './errors';
import { Implicits, implicitTypes } from './implicits';

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
  const functions = rawFunctions.matchAll(/func (\w+)\s*[{]?.*?[}]?\s*[(].*?[)]/gis);

  return [...functions].map((func) => getRawCairoFunctionInfo(func[0]));
}

/**
 * Given a Cairo function represented in plain text extracts information from it
 *  @param rawFunction Cairo code
 *  @returns The function implicits and it's name
 */
export function getRawCairoFunctionInfo(rawFunction: string): RawCairoFunctionInfo {
  // Todo: Update match so implicit can be empty and there is a version of them without keys
  const funcSignature =
    rawFunction.match(/func (?<name>\w+)\s*[{](?<implicits>.+)[}]/is) ??
    rawFunction.match(/func (?<name>\w+)\s*/);

  assert(
    funcSignature !== null && funcSignature.groups !== undefined,
    `Invalid parsing of raw string function:\n${rawFunction}`,
  );

  const name = funcSignature.groups.name;
  const implicits =
    funcSignature.groups.implicits !== undefined
      ? parseImplicits(funcSignature.groups.implicits)
      : [];

  return { name, implicits };
}

/**
 *  @param rawImplicits implicits in string form ?\{ impl1, impl2:type2, ... ?\}
 *  @returns a list of each Implicit after checking it's valid
 */
export function parseImplicits(rawImplicits: string): Implicits[] {
  const matchedImplicits =
    rawImplicits.match(/[{](?<implicits>[a-zA-Z0-9:,_*\n ]*)[}]/) ??
    rawImplicits.match(/(?<implicits>[a-zA-Z0-9:,_*\n ]*)/);

  assert(
    matchedImplicits !== null && matchedImplicits.groups !== undefined,
    `Failure to parse implicits: '${rawImplicits}'`,
  );

  // implicits -> impl1 : type1, impl2, ..., impln : typen
  const implicits = matchedImplicits.groups.implicits;

  // implicitsList -> [impl1 : type1, impl2, ...., impln : typen]
  const implicitsList = [...implicits.matchAll(/[A-Za-z][A-Za-z_: 0-9]*/g)].map((w) => w[0]);

  // implicitsNameList -> [impl1, impl2, ..., impln]
  const implicitsNameList = implicitsList.map((i) => i.match(/[A-Za-z][A-Za-z_0-9]*/));

  assert(notContainsNull(implicitsNameList), 'Failure to parse implicits: Invalid implicit name');

  return implicitsNameList.map((i) => {
    const impl = i[0];
    if (!elementIsImplicit(impl)) {
      throw new TranspileFailedError(
        `Implicit '${impl}' defined on raw string is not known: '${rawImplicits}'`,
      );
    }
    return impl;
  });
}

function elementIsImplicit(e: string): e is Implicits {
  return Object.keys(implicitTypes).includes(e);
}

function notContainsNull<T>(l: (T | null)[]): l is T[] {
  return !l.some((e) => e === null);
}
