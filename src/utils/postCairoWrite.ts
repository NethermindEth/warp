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

/**
 * Produce a dependency graph among Cairo files. Due to cairo rules this graph is
 * more specifically a Directed Acyclic Graph (DAG)
 * A file A is said to be dependant from a file B if file A needs the class hash
 * of file B.
 * @param root file to explore for dependencies
 * @param pathPrefix filepath may be different during transpilation and after transpilation. This parameter is appended at the beggining to make them equal
 * @returns a map from string to list of strings, where the key is a file and the value are all the dependencies
 */
export function getDependencyGraph(root: string, pathPrefix: string): Map<string, string[]> {
  const filesToDeclare = extractContractsToDeclared(root, pathPrefix);
  const graph = new Map<string, string[]>([[root, filesToDeclare]]);

  const pending = [...filesToDeclare];
  let count = 0;
  while (count < pending.length) {
    const fileSource = pending[count];
    if (graph.has(fileSource)) {
      count++;
      continue;
    }
    const newFilesToDeclare = extractContractsToDeclared(fileSource, pathPrefix);
    graph.set(fileSource, newFilesToDeclare);
    pending.push(...newFilesToDeclare);
    count++;
  }

  return graph;
}

/**
 * Read a cairo file and parse all instructions of the form:
 * \@declare `location`. All `location` are gathered and then returned
 * @param fileLoc cairo file path to read
 * @param pathPrefix filepath may be different during transpilation and after transpilation. This parameter is appended at the beggining to make them equal
 * @returns list of locations
 */
function extractContractsToDeclared(fileLoc: string, pathPrefix: string): string[] {
  const plainCairoCode = readFileSync(fileLoc, 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  const contractsToDeclare = cairoCode
    .map((line) => {
      const [comment, declare, location, ...other] = line.split(new RegExp('[ ]+'));
      if (comment !== '#' || declare !== '@declare') return '';

      assert(other.length === 0, `Parsing failure, unexpected extra tokens: ${other.join(' ')}`);

      return join(pathPrefix, location);
    })
    .filter((val) => val !== '');

  return contractsToDeclare;
}

/**
 * Hash function used during transpilation and postlinking so same hash
 * given same input is produced during both phases
 * @param filename filesystem path
 * @returns hashed value
 */
export function hashFilename(filename: string): string {
  return createHash(HASH_OPTION).update(filename).digest('hex').slice(0, HASH_SIZE);
}

/**
 * Utility function to remove a prefix from a path
 *
 * Example:
 * full path = A/B/C/D
 * ignore path = A/B
 * reduced path = C/D
 * @param fullPath path to reduce
 * @param ignorePath prefix to remove
 * @returns reduced path
 */
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
