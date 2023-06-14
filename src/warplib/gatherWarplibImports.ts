import fs from 'fs';
import { Implicits } from '../utils/utils';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { glob } from 'glob';
import path from 'path';
import assert from 'assert';

import { WARP_ROOT } from '../config';

export const warplibImportInfo = glob
  .sync(path.join(WARP_ROOT, 'warplib/src/**/*.cairo'))
  .reduce((warplibMap, pathToFile) => {
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });

    const importPath = [
      'warplib',
      ...path
        .relative(WARP_ROOT, pathToFile)
        .slice('warplib/src/'.length, -'.cairo'.length)
        .split(path.sep),
    ];

    // Handle WarpMemory function gathering differently
    if (importPath.includes('warp_memory')) {
      // Hardcode WarpMemory struct
      if (pathToFile.endsWith('warp_memory.cairo')) {
        warplibMap.set(importPath.join('/'), new Map([['WarpMemory', []]]));
      }
      gatherWarpMemoryFuncs(rawCairoCode, importPath, warplibMap);
      return warplibMap;
    }

    if (importPath[importPath.length - 1] == 'integer') {
      console.log('Gather int conversion');
      gatherIntegerConversion(rawCairoCode, importPath, warplibMap);
      return warplibMap;
    }

    // TODO: Add encodePath here. Importing encodePath cause circular
    // dependency error. Suggested solution is to relocate all import
    // related scripts (including this, and the ones in src/utils)
    const key = importPath.join('/');
    const fileMap: Map<string, Implicits[]> = warplibMap.get(key) ?? new Map<string, Implicits[]>();
    if (!warplibMap.has(key)) {
      warplibMap.set(key, fileMap);
    }

    parseMultipleRawCairoFunctions(rawCairoCode).forEach((cairoFunc) =>
      fileMap.set(cairoFunc.name, cairoFunc.implicits),
    );
    return warplibMap;
  }, new Map<string, Map<string, Implicits[]>>());

function gatherIntegerConversion(
  rawCairoCode: string,
  importPath: string[],
  warplibMap: Map<string, Map<string, Implicits[]>>,
) {
  const integerTraitInfo = traitFunctionExtractor(rawCairoCode);
  console.log(integerTraitInfo);

  integerTraitInfo.forEach(({ trait, code }) => {
    const traitImportPath = [...importPath, trait];
    const key = traitImportPath.join('/');

    const fileMap: Map<string, Implicits[]> = warplibMap.get(key) ?? new Map<string, Implicits[]>();
    if (!warplibMap.has(key)) {
      warplibMap.set(key, fileMap);
    }

    parseMultipleRawCairoFunctions(code).forEach((cairoFunc) => fileMap.set(cairoFunc.name, []));
  });
}

// Functions that stored warp memory functions accordingly
function gatherWarpMemoryFuncs(
  rawCairoCode: string,
  importPath: string[],
  warplibMap: Map<string, Map<string, Implicits[]>>,
) {
  // Get the body for each trait
  const warpMemoryTraitInfo = traitFunctionExtractor(rawCairoCode);

  // Store each trait import path with each function prefixed with "warp_memory."
  warpMemoryTraitInfo.forEach(({ trait, code }) => {
    const traitImportPath = [...importPath, trait];
    const key = traitImportPath.join('/');

    const fileMap: Map<string, Implicits[]> = warplibMap.get(key) ?? new Map<string, Implicits[]>();
    if (!warplibMap.has(key)) {
      warplibMap.set(key, fileMap);
    }

    parseMultipleRawCairoFunctions(code).forEach((cairoFunc) =>
      fileMap.set(`warp_memory.${cairoFunc.name}`, ['warp_memory']),
    );
  });
}

type TraitInfo = { trait: string; code: string };
function traitFunctionExtractor(rawCairoCode: string): TraitInfo[] {
  const warpMemoryInfo: TraitInfo[] = [];
  let currentTrait = '';
  let currentBody = '';
  rawCairoCode
    .split('\n')
    .filter((l) => !l.match('^[ ]*$'))
    .forEach((l) => {
      if (l.trim().startsWith('trait')) {
        if (currentTrait !== '') {
          warpMemoryInfo.push({ trait: currentTrait, code: currentBody });
        }
        currentTrait = extractName('trait', l);
        currentBody = '';
        return;
      }
      if (l.trim().startsWith('impl')) {
        if (currentTrait !== '') {
          warpMemoryInfo.push({ trait: currentTrait, code: currentBody });
        }
        currentTrait = '';
        currentBody = '';
        return;
      }
      currentBody += '\n' + l.trim();
    });

  return warpMemoryInfo;
}

function extractName(keyword: string, line: string) {
  const regex = new RegExp(`${keyword}[ ]+(?<name>\\w+)`);
  const m = line.match(regex);
  assert(
    m !== null && m.groups !== undefined,
    `Error extracting name for ${keyword} in line:\n"${line}"`,
  );

  return m.groups.name;
}
