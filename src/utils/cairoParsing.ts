import assert from 'assert';
import { TranspileFailedError } from './errors';
import { Implicits, implicitTypes } from './implicits';

export type RawCairoFunctionInfo = {
  name: string;
  implicits: Implicits[];
};

export function parseMultipleRawCairoFunctions(rawFunctions: string): RawCairoFunctionInfo[] {
  const functions = rawFunctions.matchAll(/func \w+\s*[{].*?[}]\s*[(].*?[)]\s*[{].*?[}]/gis);

  // console.log(rawFunctions);
  // console.log([...functions]);

  return [...functions].map((func) => getRawCairoFunctionInfo(func[0]));
}

/**
 * Given a Cairo function represented in plain text extracts information from it
 *  @param rawFunction Cairo code
 *  @returns The function implicits and it's name
 */
export function getRawCairoFunctionInfo(rawFunction: string): RawCairoFunctionInfo {
  const funcSignature = rawFunction.match(/func (?<name>.+)\{(?<implicits>.+)\}/);
  assert(
    funcSignature !== null && funcSignature.groups !== undefined,
    `Invalid parsing of raw string function:\n${rawFunction}`,
  );

  const name = funcSignature.groups.name;
  try {
    console.log('parsing implicits of', name);
    const implicits = parseImplicits(funcSignature.groups.implicits);

    return { name, implicits };
  } catch (err) {
    throw new Error(`Error in implicits for:\n${rawFunction}`);
  }
}

/**
 *  @param rawImplicits implicits in string form ?\{ impl1, impl2:type2, ... ?\}
 *  @returns a list of each Implicit after checking it's valid
 */
export function parseImplicits(rawImplicits: string): Implicits[] {
  console.log('rawImplicits: ', rawImplicits);
  const matchedImplicits =
    rawImplicits.match(/[{](?<implicits>[a-zA-Z0-9:,_* ]*)[}]/) ??
    rawImplicits.match(/(?<implicits>[a-zA-Z0-9:,_* ]*)/);

  assert(
    matchedImplicits !== null && matchedImplicits.groups !== undefined,
    `Failure to parse implicits: '${rawImplicits}'`,
  );

  // implicits -> impl1 : type1, impl2, ..., impln : typen
  const implicits = matchedImplicits.groups.implicits;

  console.log('matchedImplicits: ', implicits);

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
