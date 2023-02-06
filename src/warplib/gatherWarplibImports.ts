import path from 'path';
import fs from 'fs';
import { Implicits } from '../utils/implicits';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';

export const warplibImportInfo = readAllCairoScripts('warplib', 'warplib').reduce(
  (warplibMap, [pathToFile, importPath]) => {
    console.log('parsing', pathToFile, importPath);
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });

    let fileMap: Map<string, Implicits[]>;
    if (warplibMap.has(importPath)) {
      fileMap = warplibMap.get(importPath)!;
    } else {
      fileMap = new Map<string, Implicits[]>();
      warplibMap.set(importPath, fileMap);
    }

    parseMultipleRawCairoFunctions(rawCairoCode).forEach((cairoFunc) =>
      fileMap.set(cairoFunc.name, cairoFunc.implicits),
    );

    return warplibMap;
  },
  new Map<string, Map<string, Implicits[]>>(),
);

function readAllCairoScripts(dirPath: string, importPath: string): [string, string][] {
  return fs.readdirSync(dirPath).reduce((filesInfo, file) => {
    const fullPathName = path.join(dirPath, file);

    console.log('Analyzing', fullPathName, fs.statSync(fullPathName).isDirectory());
    if (fs.statSync(fullPathName).isDirectory()) {
      const newFilesInfo = readAllCairoScripts(fullPathName, `${importPath}.${file}`);
      return [...filesInfo, ...newFilesInfo];
    }
    if (file.endsWith('.cairo')) {
      return [
        ...filesInfo,
        [fullPathName, `${importPath}.${file.slice(0, file.length - '.cairo'.length)}`],
      ];
    }

    return filesInfo;
  }, new Array<[string, string]>());
}
