import assert from 'assert';
import { createHash } from 'crypto';
import { readFileSync, writeFileSync } from 'fs';

export const HASH_SIZE = 16;
export const HASH_OPTION = 'sha256';

/**
 *  Read a cairo file and for each constant of the form `const name = value`
 *  if `name` is of the form   `<contractName>_<contractNameHash>` then it corresponds
 *  to a placeholder waiting to be filled with the corresponding contract class hash
 *  @param fileLoc location of cairo file
 *  @param declarationAddresses mapping of: (placeholder hash) => (starknet class hash)
 */
export function setDeclaredAddresses(fileLoc: string, declarationAddresses: Map<string, string>) {
  const plainCairoCode = readFileSync(fileLoc, 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  let update = false;
  const newCairoCode = cairoCode.map((codeLine) => {
    const [constant, fullName, equal, _oldValue, ...other] = codeLine.split(new RegExp('[ ]+'));
    if (constant !== 'const') return codeLine;

    assert(other === []);

    const name = fullName.slice(0, -HASH_SIZE - 1);
    const hash = fullName.slice(-HASH_SIZE);
    // const parsedFileName = reducePath(fileLoc, ignoreLoc).join('_');
    // const parsedFileNameHash = hashFilename(parsedFileName);
    // if (hash !== parsedFileNameHash) return codeLine;

    const declaredAddress = declarationAddresses.get(hash);
    assert(declaredAddress !== undefined, `Cannot find declared address for ${name}`);

    // Flag that there are changes that need to be rewritten
    update = true;
    const newLine = [constant, fullName, equal, declaredAddress].join(' ');
    return newLine;
  });

  if (!update) return;

  const plainNewCairoCode = newCairoCode.join('\n');
  writeFileSync(fileLoc, plainNewCairoCode);
}

export function hashFilename(filename: string): string {
  return createHash(HASH_OPTION).update(filename).digest('hex').slice(HASH_SIZE);
}

export function reducePath(fullPath: string, ignorePath: string) {
  const pathSplitter = new RegExp('/+|\\\\+');

  const ignore = ignorePath.split(pathSplitter);
  const full = fullPath.split(pathSplitter);

  assert(ignore.length < full.length);
  let ignoreTill = 0;
  for (const i in ignore) {
    if (ignore[i] !== full[i]) break;
    ignoreTill += 1;
  }
  return full.slice(ignoreTill);
}
