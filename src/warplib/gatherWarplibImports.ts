import fs from 'fs';
import { Implicits } from '../utils/utils';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { glob } from 'glob';
import path from 'path';

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
