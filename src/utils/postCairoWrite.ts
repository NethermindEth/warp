import assert from 'assert';
import { createHash } from 'crypto';
import fs from 'fs/promises';
import * as path from 'path';
import { enqueueCompileCairo } from '../starknetCli';
import { CLIError } from './errors';
import { runStarknetClassHash } from './utils';

export const HASH_SIZE = 8;
export const HASH_OPTION = 'sha256';

/**
  Is used post transpilation to insert the class hash for any contract that can deploy another.
  During transpilation 0 is placed where the class hash would be because cotracts to declare
  have not yet been fully transpiled. At this stage all contracts have been transpiled, so they
  can be  compiled and their class hash computed. Each class hash needed is written into the
  cairo contract
  @param contractPath: The path to the cairo File being processed.
  @param outputDir: Directory where the path is getting stored
  @param contractHashToClassHash: 
    A mapping that holds the contract path with out the pathPrefix and maps 
    it to the contracts class hash.
  @returns cairoFilePath: The path to the cairo File that was processed.
 */
export async function postProcessCairoFile(
  contractPath: string,
  outputDir: string,
  debugInfo: boolean,
  contractHashToClassHash: Map<string, string>,
): Promise<string> {
  // Creates a dependency graph for the file
  const dependencyGraph = await getDependencyGraph(contractPath, outputDir);
  // Gets the files that are dependant on the hash.
  // const fullPath = path.join(outputDir, contractPath);
  const filesToHash = dependencyGraph.get(contractPath);
  // If the file has nothing to hash then we can leave.
  if (filesToHash === undefined || filesToHash.length === 0) {
    return contractPath;
  }
  // If the file does have dependencies then we need to make sure that the dependencies of
  // those files have been calculated and inserted.
  await Promise.all(
    filesToHash.map((file) =>
      hashDependacies(file, outputDir, debugInfo, dependencyGraph, contractHashToClassHash),
    ),
  );

  await setDeclaredAddresses(path.join(outputDir, contractPath), contractHashToClassHash);
  return contractPath;
}

async function hashDependacies(
  contractPath: string,
  outputDir: string,
  debugInfo: boolean,
  dependencyGraph: Map<string, string[]>,
  contractHashToClassHash: Map<string, string>,
): Promise<void> {
  const filesToHash = dependencyGraph.get(contractPath);
  // Base case: If the file has no dependencies to hash then we hash the compiled file
  // and add it to the contractHashToClassHash map
  if (filesToHash === undefined || filesToHash.length === 0) {
    await addClassHash(contractPath, outputDir, debugInfo, contractHashToClassHash);
    return;
  }

  await Promise.all(
    filesToHash.map(async (file) => {
      await hashDependacies(file, outputDir, debugInfo, dependencyGraph, contractHashToClassHash);
      await setDeclaredAddresses(path.join(outputDir, file), contractHashToClassHash);
    }),
  );

  await addClassHash(contractPath, outputDir, debugInfo, contractHashToClassHash);
}

/**
 * Hashes the contract at `contractPath` and stores it in `contractHashToClassHash`
 */
async function addClassHash(
  contractPath: string,
  outputDir: string,
  debugInfo: boolean,
  contractHashToClassHash: Map<string, string>,
): Promise<void> {
  const fileUniqueId = hashFilename(path.resolve(contractPath));
  let classHash = contractHashToClassHash.get(fileUniqueId);
  if (classHash === undefined) {
    classHash = await computeClassHash(path.join(outputDir, contractPath), debugInfo);
    contractHashToClassHash.set(fileUniqueId, classHash);
  }
}

/**
 * Given a cairo contract at `contractPath` returns its classhash
 * @param contractPath path to cairo file
 * @param debugInfo compile cairo file for debug
 * @returns the class hash of the cairo file
 */
async function computeClassHash(contractPath: string, debugInfo: boolean): Promise<string> {
  const { success, resultPath } = await enqueueCompileCairo(
    contractPath,
    path.resolve(__dirname, '..', '..'),
    {
      debugInfo,
    },
  );
  if (!success) {
    throw new CLIError(`Compilation of cairo file ${contractPath} failed`);
  } else {
    assert(resultPath !== undefined && success);
    const classHash = await runStarknetClassHash(resultPath);
    return classHash;
  }
}
/**
 *  Read a cairo file and for each constant of the form `const name = value`
 *  if `name` is of the form   `<contractName>_<contractId>` then it corresponds
 *  to a placeholder waiting to be filled with the corresponding contract class hash
 *  @param contractPath location of cairo file
 *  @param declarationAddresses mapping of: (placeholder hash) => (starknet class hash)
 */
export async function setDeclaredAddresses(
  contractPath: string,
  declarationAddresses: Map<string, string>,
) {
  const plainCairoCode = await fs.readFile(contractPath, 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  let update = false;
  const newCairoCode = cairoCode.map((codeLine) => {
    const [constant, fullName, equal, ...other] = codeLine.split(new RegExp('[ ]+'));
    // if (constant === '//' && fullName === '@declare') return '';
    if (constant !== 'const') return codeLine;

    assert(other.length === 1, `Parsing failure, unexpected extra tokens: ${other.join(' ')}`);

    const name = fullName.slice(0, -HASH_SIZE - 1);
    const uniqueId = fullName.slice(-HASH_SIZE);

    const declaredAddress = declarationAddresses.get(uniqueId);
    assert(
      declaredAddress !== undefined,
      `Cannot find declared address for ${name} with hash ${uniqueId}`,
    );

    // Flag that there are changes that need to be rewritten
    update = true;
    const newLine = [constant, fullName, equal, declaredAddress, ';'].join(' ');
    return newLine;
  });

  if (!update) return;

  const plainNewCairoCode = newCairoCode.join('\n');
  await fs.writeFile(contractPath, plainNewCairoCode);
}

/**
 * Produce a dependency graph among Cairo files. Due to cairo rules this graph is
 * more specifically a Directed Acyclic Graph (DAG)
 * A file A is said to be dependant from a file B if file A needs the class hash
 * of file B.
 * @param root file to explore for dependencies
 * @param outputDir directory where cairo files are stored
 * @returns a map from string to list of strings, where the key is a file and the value are all the dependencies
 */
export async function getDependencyGraph(
  root: string,
  outputDir: string,
): Promise<Map<string, string[]>> {
  const filesToDeclare = await extractContractsToDeclare(root, outputDir);
  const graph = new Map<string, string[]>([[root, filesToDeclare]]);

  const pending = [...filesToDeclare];
  let count = 0;

  while (count < pending.length) {
    const fileSource = pending[count];
    if (graph.has(fileSource)) {
      count++;
      continue;
    }
    const newFilesToDeclare = await extractContractsToDeclare(fileSource, outputDir);
    graph.set(fileSource, newFilesToDeclare);
    pending.push(...newFilesToDeclare);
    count++;
  }

  return graph;
}

/**
 * Read a cairo file and parse all instructions of the form:
 * @declare `location`. All `location` are gathered and then returned
 * @param contractPath cairo file path to read
 * @param outputDir filepath may be different during transpilation and after transpilation. This parameter is appended at the beggining to make them equal
 * @returns list of locations
 */
async function extractContractsToDeclare(
  contractPath: string,
  outputDir: string,
): Promise<string[]> {
  const plainCairoCode = await fs.readFile(path.join(outputDir, contractPath), 'utf8');
  const cairoCode = plainCairoCode.split('\n');

  const contractsToDeclare = cairoCode
    .map((line) => {
      const [comment, declare, location, ...other] = line.split(new RegExp('[ ]+'));
      if (comment !== '//' || declare !== '@declare') return '';

      assert(other.length === 0, `Parsing failure, unexpected extra tokens: ${other.join(' ')}`);

      return location;
    })
    .filter((val) => val !== '');
  return contractsToDeclare;
}

/**
 * Hash function used during transpilation and post-linking so same hash
 * given same input is produced during both phases
 * @param filename filesystem path
 * @returns hashed value
 */
export function hashFilename(filename: string): string {
  return createHash(HASH_OPTION).update(filename).digest('hex').slice(0, HASH_SIZE);
}
