import assert from 'assert';
import { createHash } from 'crypto';
import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';

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
    const [constant, fullName, equal, ...other] = codeLine.split(new RegExp('[ ]+'));
    if (constant !== 'const') return codeLine;

    assert(other.length === 1, `Parsing failure, unexpected extra tokens: ${other.join(' ')}`);

    const name = fullName.slice(0, -HASH_SIZE - 1);
    const hash = fullName.slice(-HASH_SIZE);

    const declaredAddress = declarationAddresses.get(hash);
    assert(
      declaredAddress !== undefined,
      `Cannot find declared address for ${name} with hash ${hash}`,
    );

    // Flag that there are changes that need to be rewritten
    update = true;
    const newLine = [constant, fullName, equal, declaredAddress].join(' ');
    return newLine;
  });

  if (!update) return;

  const plainNewCairoCode = newCairoCode.join('\n');
  writeFileSync(fileLoc, plainNewCairoCode);
}

export function extractContractsToDeclared(fileLoc: string, append: string) {
  const plainCairoCode = readFileSync(fileLoc, 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  const contractsToDeclare = cairoCode
    .map((line) => {
      const [comment, declare, location, ...other] = line.split(new RegExp('[ ]+'));
      if (comment !== '#' || declare !== '@declare') return '';

      assert(other.length === 0, `Parsing failure, unexpected extra tokens: ${other.join(' ')}`);

      return append !== '' ? join(append, location) : location;
    })
    .filter((val) => val !== '');

  return contractsToDeclare;
}

export function hashFilename(filename: string): string {
  return createHash(HASH_OPTION).update(filename).digest('hex').slice(0, HASH_SIZE);
}

export function reducePath(fullPath: string, ignorePath: string) {
  const pathSplitter = new RegExp('/+|\\\\+');

  const ignore = ignorePath.split(pathSplitter);
  const full = fullPath.split(pathSplitter);

  assert(
    ignore.length < full.length,
    `Path to ignore should be lesser than actual path. Ignore path size is ${ignore.length} and actual path size is ${full.length}`,
  );
  let ignoreTill = 0;
  for (const i in ignore) {
    if (ignore[i] !== full[i]) break;
    ignoreTill += 1;
  }
  return join(...full.slice(ignoreTill));
}
