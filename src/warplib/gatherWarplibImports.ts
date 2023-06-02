import fs from 'fs';
import { Implicits } from '../utils/utils';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { glob } from 'glob';
import path from 'path';
import assert from 'assert';

export const warplibImportInfo = glob
  .sync('warplib/src/**/*.cairo')
  .reduce((warplibMap, pathToFile) => {
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });

    const importPath = [
      'warplib',
      ...pathToFile.slice('warplib/src/'.length, -'.cairo'.length).split(path.sep),
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

// Functions that stored warp memory functions accordingly
function gatherWarpMemoryFuncs(
  rawCairoCode: string,
  importPath: string[],
  warplibMap: Map<string, Map<string, Implicits[]>>,
) {
  // Get the body for each trait
  const warpMemoryInfo: { traitName: string; body: string }[] = [];
  let currentTrait = '';
  let currentBody = '';
  rawCairoCode
    .split('\n')
    .filter((l) => !l.match('^[ ]*$'))
    .forEach((l) => {
      if (l.trim().startsWith('trait')) {
        if (currentTrait !== '') {
          warpMemoryInfo.push({ traitName: currentTrait, body: currentBody });
        }
        currentTrait = extractName('trait', l);
        currentBody = '';
        return;
      }
      if (l.trim().startsWith('impl')) {
        if (currentTrait !== '') {
          warpMemoryInfo.push({ traitName: currentTrait, body: currentBody });
        }
        currentTrait = '';
        currentBody = '';
        return;
      }
      currentBody += '\n' + l.trim();
    });

  // Store each trait import path with each function prefixed with "warp_memory."
  warpMemoryInfo.forEach(({ traitName, body }) => {
    const traitImportPath = [...importPath, traitName];
    const key = traitImportPath.join('/');

    const fileMap: Map<string, Implicits[]> = warplibMap.get(key) ?? new Map<string, Implicits[]>();
    if (!warplibMap.has(key)) {
      warplibMap.set(key, fileMap);
    }

    parseMultipleRawCairoFunctions(body).forEach((cairoFunc) =>
      fileMap.set(`warp_memory.${cairoFunc.name}`, ['warp_memory']),
    );
  });
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
