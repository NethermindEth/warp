import * as fs from 'fs/promises';

import { cleanup, transpile, processArgs, compileCluster, removeOutputDir } from '../util';
import { deploy, ensureTestnetContactable, invoke } from '../testnetInterface';

import { describe } from 'mocha';
import chai, { expect } from 'chai';
import chaiAsPromised from 'chai-as-promised';
import Bottleneck from 'bottleneck';
import { getExpectations } from './expectations';
import { AsyncTest, Expect, OUTPUT_DIR } from './expectations/types';
import { DeployResponse } from '../testnetInterface';
import { getDependencyGraph } from '../../src/utils/postCairoWrite';
import { EventItem } from '../../src/utils/event';
import { pathExists } from '../../src/utils/fs';

chai.use(chaiAsPromised);

const PRINT_STEPS = false;
const PARALLEL_COUNT = 8;
const TIME_LIMIT = 2 * 60 * 60 * 1000;

interface AsyncTestCluster {
  asyncTest: AsyncTest;
  dependencies: Map<string, string[]>;
}

const expectations = getExpectations();

// Transpiling the solidity files using the `bin/warp transpile` CLI command.
describe('Transpile solidity', function () {
  this.timeout(TIME_LIMIT);

  let transpileResults: Array<{ success: boolean; result: { stderr: string; stdout: string } }>;

  before(async function () {
    await Promise.all(
      expectations.flatMap((fileTest) => {
        return fileTest.encodingError === undefined
          ? [cleanup(fileTest.cairo), cleanup(fileTest.compiled)]
          : [];
      }),
    );

    const bottleneck = new Bottleneck({ maxConcurrent: PARALLEL_COUNT });

    transpileResults = await Promise.all(
      expectations.map((expectation) =>
        bottleneck.schedule(async () => {
          if (expectation.encodingError === undefined) {
            try {
              return { success: true, result: await transpile(expectation.sol) };
            } catch (err) {
              if (!!err && typeof err === 'object' && 'stdout' in err && 'stderr' in err) {
                const errorData = err as { stdout: string; stderr: string };
                return {
                  success: false,
                  result: { stdout: errorData.stdout, stderr: errorData.stderr },
                };
              }

              throw err;
            }
          } else {
            return {
              success: false,
              result: { stdout: '', stderr: expectation.encodingError },
            };
          }
        }),
      ),
    );
  });

  expectations.forEach((expectation, i) => {
    it(expectation.name, async function () {
      const res = transpileResults[i];

      expect(res.success, `warp execution was not successful: ${JSON.stringify(res.result)}`);
      expect(
        res.result.stderr,
        `warp-ts stderr was not empty: ${JSON.stringify(res.result)}`,
      ).to.be.empty;
      await expect(
        fs.access(expectations[i].cairo),
        `Transpilation failed, cannot find output file. Is the file's contract named WARP or specified in the expectations?`,
      ).to.not.be.rejected;
    });
  });
});

// Compiling the transpiled contracts using the Starknet CLI.
describe('Transpiled contracts are valid cairo', function () {
  this.timeout(TIME_LIMIT);

  let compileResults: Array<
    | { error: null; result: { stdout: string; stderr: string } | null }
    | { error: unknown; result: null }
  >;
  let processedExpectations: (AsyncTestCluster | null)[];

  before(async function () {
    processedExpectations = await Promise.all(
      expectations.map(async (test: AsyncTest): Promise<AsyncTestCluster | null> => {
        if (test.encodingError !== undefined || !(await pathExists(test.cairo))) {
          return null;
        }

        const dependencyGraph = await getDependencyGraph(removeOutputDir(test.cairo), OUTPUT_DIR);

        return { asyncTest: test, dependencies: dependencyGraph };
      }),
    );

    const bottleneck = new Bottleneck({ maxConcurrent: PARALLEL_COUNT });

    compileResults = await Promise.all(
      processedExpectations.map((test) =>
        bottleneck.schedule(async () => {
          if (test === null) return { error: null, result: null };

          try {
            return { error: null, result: await compileCluster(test) };
          } catch (err) {
            return { error: err, result: null };
          }
        }),
      ),
    );
  });

  expectations.forEach((expectation, i) => {
    it(expectation.name, async function () {
      const res = compileResults[i];

      if (res.error === null && res.result === null) {
        this.skip();
        return;
      }

      expect(res.error, `Compilation failed: ${JSON.stringify(res.error)}`).to.be.null;
      expect(res.result?.stderr, `starknet-compile printed errors: ${res.result}`).to.be.empty;
      await expect(
        fs.access(expectation.compiled),
        'Compilation failed, cannot find output file.',
      ).to.not.be.rejected;
    });
  });
});

const deployedAddresses: Map<string, { address: string; hash: string }> = new Map();

// Deploying the tests to the Testnet thought interface commands
// The test net is a flask server that runs and therefor cannot be interacted with
// in the same manner as the Starknet CLI.
describe('Compiled contracts are deployable', function () {
  this.timeout(TIME_LIMIT);

  const deployResults: (DeployResponse | null)[] = [];

  before(async function () {
    const testnetContactable = await ensureTestnetContactable(60000);
    expect(testnetContactable, 'Failed to ping testnet').to.be.true;

    for (const expectation of expectations) {
      try {
        if ((await fs.stat(expectation.compiled)).size === 0) {
          deployResults.push(null);
          continue;
        }
      } catch {
        deployResults.push(null);
        continue;
      }

      deployResults.push(await deploy(expectation.compiled, await expectation.constructorArgs));
    }
  });

  expectations.forEach((expectation, i) => {
    it(expectation.name, async function () {
      const response = deployResults[i];

      if (response === null) {
        this.skip();
        return;
      }

      expect(response.threw, 'Deploy request failed').to.be.false;

      if (!response.threw) {
        deployedAddresses.set(`${expectation.name}.${expectation.contract}`, {
          address: response.contract_address,
          hash: response.class_hash,
        });
      }
    });
  });
});

// Test that the contracts that have been deployed have the correct output given a
// corresponding input. These inputs are received from the test/expectations/index.ts
// file which processes inputs and outputs from behaviour.ts and semantic.ts
describe('Deployed contracts have correct behaviour', function () {
  this.timeout(TIME_LIMIT);

  expectations.forEach((expectation) => {
    let expects = expectation.expectations;

    if (expects instanceof Promise) {
      it(expectation.name, async function () {
        const address = deployedAddresses.get(
          `${expectation.name}.${expectation.contract}`,
        )?.address;

        if (address === undefined) {
          this.skip();
          return;
        }

        expects = await expects;

        for (const expect of expects) {
          await behaviourTest(deployedAddresses, expect, expectation, address);
        }
      });
    } else {
      describe(expectation.name, function () {
        (expects as Expect[]).forEach((expect) => {
          it(expect.name, async function () {
            const address = deployedAddresses.get(
              `${expectation.name}.${expectation.contract}`,
            )?.address;

            if (address === undefined) this.skip();

            await behaviourTest(deployedAddresses, expect, expectation, address);
          });
        });
      });
    }
  });

  after(async function () {
    await Promise.all(expectations.map((fileTest) => cleanup(fileTest.compiled)));
  });
});

async function behaviourTest(
  deployedAddresses: Map<string, { address: string; hash: string }>,
  functionExpectation: Expect,
  fileTest: AsyncTest,
  address: string,
): Promise<void> {
  for (const [
    funcName,
    inputs,
    expectedResult,
    caller_address,
    error_message,
    events,
  ] of functionExpectation.steps) {
    const name = functionExpectation.name;
    const mangledFuncName =
      funcName !== 'constructor' ? await findMethod(funcName, fileTest.compiled) : 'constructor';
    const replaced_inputs = processArgs(name, inputs, deployedAddresses);
    const replaced_expectedResult =
      expectedResult !== null ? processArgs(name, expectedResult, deployedAddresses) : null;

    if (funcName === 'constructor') {
      // Failing tests for constructor
      const response = await deploy(fileTest.compiled, replaced_inputs);
      expect(response.threw, 'Deploy request should not succeed').to.be.true;
      error_message !== undefined &&
        response.error_message !== undefined &&
        expect(response.error_message).to.include(error_message);
    } else if (mangledFuncName === null) {
      expect(mangledFuncName, `${name} - Unable to find function ${funcName}`).to.not.be.null;
    } else {
      const response = await invoke(address, mangledFuncName, replaced_inputs, caller_address);
      if (PRINT_STEPS) {
        console.log(`${fileTest.name} - ${mangledFuncName}: ${response.steps} steps`);
      }

      expect(response.status, `${name} - Unhandled starknet-testnet error`).to.equal(200);

      if (expectedResult === null) {
        expect(response.threw, `${name} - Function should throw`).to.be.true;
        error_message !== undefined &&
          response.error_message !== undefined &&
          expect(response.error_message).to.include(error_message);
      } else {
        expect(
          response.threw,
          `${name} - Function should not throw, but threw with message: ${response.error_message}`,
        ).to.be.false;
        expect(
          response.return_data,
          `${name} - Return data should match expectation`,
        ).to.deep.equal(replaced_expectedResult);
        if (events !== undefined) {
          expect(
            response.events as EventItem[],
            `${name} - Events should match events expectation`,
          ).to.deep.equal(events);
        }
      }
    }
  }
}

// This is specifically the part of the type of the output data findMethod is interested in
type CompiledCairo = {
  abi: {
    type: string;
    name: string;
    inputs: { name: string; type: string }[] | undefined;
  }[];
};

async function findMethod(functionName: string, fileName: string): Promise<string | null> {
  if (!(await pathExists(fileName))) {
    throw new Error(`Couldn't find compiled contract ${fileName}`);
  }

  const data: CompiledCairo = JSON.parse(await fs.readFile(fileName, 'utf-8'));
  const functions = data.abi.filter((abiEntry) => abiEntry.type === 'function');
  const exactMatches = functions.filter((func) => func.name === functionName);
  if (exactMatches.length > 1) {
    console.error(`Found multiple functions called ${functionName}`);
    return null;
  } else if (exactMatches.length === 1) {
    return exactMatches[0].name;
  }

  const mangledMatches = functions.filter(
    (func) =>
      func.name.startsWith(functionName) &&
      /^_[a-zA-Z0-9]*$/.test(func.name.slice(functionName.length)),
  );

  if (mangledMatches.length === 1) {
    return mangledMatches[0].name;
  } else if (mangledMatches.length === 0 && functions.some((func) => func.name === '__default__')) {
    // If no function is found try default entry point (fallback) function
    return functionName;
  } else {
    console.error(
      [
        `Unable to automatically select a function matching ${functionName}`,
        'Candidates are:',
        ...mangledMatches.map((func) => `    ${func.name}(${func.inputs})`),
        '    -',
      ].join('\n'),
    );
    return null;
  }
}
