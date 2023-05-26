import fs from 'fs';
import { Implicits } from '../utils/implicits';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { glob } from 'glob';
import path from 'path';

import { WARP_ROOT } from '../config';


export const warplibImportInfo = glob
  .sync(path.join(WARP_ROOT, 'warplib/**/*.cairo'))
  .reduce((warplibMap, pathToFile) => {
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });

    const importPath = pathToFile
      .split('/')
      .join('.')
      .slice(0, pathToFile.length - '.cairo'.length);

    const fileMap: Map<string, Implicits[]> =
      warplibMap.get(importPath) ?? new Map<string, Implicits[]>();

    if (!warplibMap.has(importPath)) {
      warplibMap.set(importPath, fileMap);
    }

    parseMultipleRawCairoFunctions(rawCairoCode).forEach((cairoFunc) =>
      fileMap.set(cairoFunc.name, cairoFunc.implicits),
    );

    return warplibMap;
  }, new Map<string, Map<string, Implicits[]>>());
