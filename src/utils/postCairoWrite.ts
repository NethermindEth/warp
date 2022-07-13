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
 *  @param declarationAddresses mapping of className => classHash
 */
export function setDeclaredAddresses(fileLoc: string, declarationAddresses: Map<string, string>) {
  const plainCairoCode = readFileSync(fileLoc, 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  let update = false;
  const newCairoCode = cairoCode.map((codeLine) => {
    const [constant, fullName, equal, _oldValue, ...other] = codeLine.split(new RegExp('[ ]+'));
    if (constant !== 'const') return;

    assert(other === []);

    const name = fullName.slice(0, fullName.length - HASH_SIZE - 1);
    const hash = fullName.slice(fullName.length - HASH_SIZE);

    const nameHash = createHash(HASH_OPTION).update(name).digest('hex');
    if (hash !== nameHash) return;

    const declaredAddress = declarationAddresses.get(name);
    assert(declaredAddress !== undefined, `Cannot find declared address for ${name}`);

    // Flag that there are changes that need to be safed
    update = true;
    const newLine = [constant, fullName, equal, declaredAddress].join('\n');
    return newLine;
  });

  if (!update) return;

  const plainNewCairoCode = newCairoCode.join('\n');
  writeFileSync(fileLoc, plainNewCairoCode);
}
