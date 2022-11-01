import * as fs from 'fs';

import {
  SafePromise,
  cleanupSync,
  transpile,
  batchPromises,
  processArgs,
  compileCluster,
  removeOutputDir,
} from '../util';
import { deploy, ensureTestnetContactable, invoke } from '../testnetInterface';

import { describe } from 'mocha';
import { assert, expect } from 'chai';
import { expectations } from './expectations';
import { AsyncTest, Expect, OUTPUT_DIR } from './expectations/types';
import { DeployResponse } from '../testnetInterface';
import { getDependencyGraph } from '../../src/utils/postCairoWrite';

const PRINT_STEPS = false;
const PARALLEL_COUNT = 8;
const TIME_LIMIT = 2 * 60 * 60 * 1000;

interface AsyncTestCluster {
  asyncTest: AsyncTest;
  dependencies: Map<string, string[]>;
}

// Transpiling the solidity files using the `bin/warp transpile` CLI command.
describe('Transpile solidity', function () {
  this.timeout(TIME_LIMIT);

  let transpileResults: SafePromise<{ stderr: string }>[];

  before(async function () {
    for (const fileTest of expectations) {
      if (fileTest.encodingError === undefined) {
        cleanupSync(fileTest.cairo);
        cleanupSync(fileTest.compiled);
      }
    }

    transpileResults = batchPromises(
      expectations.map((e) =>
        e.encodingError === undefined ? e.sol : { stderr: e.encodingError },
      ),
      PARALLEL_COUNT,
      (input) => (typeof input === 'string' ? transpile(input) : Promise.resolve(input)),
    );
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      const res = await transpileResults[i];
      expect(res.result, `warp-ts printed errors: ${res.result}`).to.include({ stderr: '' });
      expect(
        fs.existsSync(expectations[i].cairo),
        `Transpilation failed, cannot find output file. Is the file's contract named WARP or specified in the expectations?`,
      ).to.be.true;
      expect(res.success, `${res.result}`);
    });
  }
});

// Compiling the transpiled contracts using the StarkNet CLI.
describe('Transpiled contracts are valid cairo', function () {
  this.timeout(TIME_LIMIT);

  let compileResults: SafePromise<{ stderr: string } | null>[];
  let processedExpectations: (AsyncTestCluster | null)[];

  before(function () {
    processedExpectations = expectations.map((test: AsyncTest): AsyncTestCluster | null => {
      if (test.encodingError !== undefined || !fs.existsSync(test.cairo)) {
        return null;
      }
      const dependencyGraph = getDependencyGraph(removeOutputDir(test.cairo), OUTPUT_DIR);
      return { asyncTest: test, dependencies: dependencyGraph };
    });

    compileResults = batchPromises(
      processedExpectations,
      PARALLEL_COUNT,
      (test: AsyncTestCluster | null): Promise<{ stderr: string } | null> => {
        if (test === null) {
          return Promise.resolve(null);
        }
        // This is will compile the test and declare all of the dependencies that it needs.
        return compileCluster(test);
      },
    );
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      const res = await compileResults[i];
      if (res.result === null) {
        this.skip();
      } else {
        expect(res.result, `starknet-compile printed errors: ${res.result}`).to.include({
          stderr: '',
        });
        expect(fs.existsSync(expectations[i].compiled), 'Compilation failed').to.be.true;
        expect(res.success, `${res.result}`);
      }
    });
  }
});

const deployedAddresses: Map<string, { address: string; hash: string }> = new Map();

// Deploying the tests to the Testnet thought interface commands
// The test net is a flask server that runs and therefor cannot be interacted with
// in the same manner as the StarkNet CLI.
describe('Compiled contracts are deployable', function () {
  this.timeout(TIME_LIMIT);

  const deployResults: (DeployResponse | null)[] = [];

  before(async function () {
    const testnetContactable = await ensureTestnetContactable(60000);
    expect(testnetContactable, 'Failed to ping testnet').to.be.true;

    for (const fileTest of expectations) {
      const fileSize = fs.statSync(fileTest.compiled, { throwIfNoEntry: false })?.size;
      if (fileSize !== undefined && fileSize > 0) {
        deployResults.push(await deploy(fileTest.compiled, await fileTest.constructorArgs));
      } else {
        deployResults.push(null);
      }
    }
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      const response = deployResults[i];
      if (response === null) {
        this.skip();
      } else {
        expect(response.threw, 'Deploy request failed').to.be.false;
        if (!response.threw) {
          deployedAddresses.set(`${expectations[i].name}.${expectations[i].contract}`, {
            address: response.contract_address,
            hash: response.class_hash,
          });
        }
      }
    });
  }
});

/* 
 Test that the contracts that have been deployed have the correct output given a
 corresponding input. These inputs are received from the test/expectations/index.ts
 file which processes inputs and outputs from behaviour.ts and semantic.ts
*/
describe('Deployed contracts have correct behaviour', function () {
  this.timeout(TIME_LIMIT);

  for (const fileTest of expectations) {
    if (fileTest.expectations instanceof Promise) {
      it(fileTest.name, async function () {
        const address = deployedAddresses.get(`${fileTest.name}.${fileTest.contract}`)?.address;
        if (address === undefined) this.skip();
        const expects = await fileTest.expectations;
        for (let i = 0; i < expects.length; ++i) {
          await behaviourTest(expects[i], fileTest, address);
        }
      });
    } else {
      const expects = fileTest.expectations;
      describe(fileTest.name, async function () {
        for (const functionExpectation of expects) {
          it(functionExpectation.name, async function () {
            const address = deployedAddresses.get(`${fileTest.name}.${fileTest.contract}`)?.address;
            if (address === undefined) this.skip();
            await behaviourTest(functionExpectation, fileTest, address);
          });
        }
      });
    }
  }

  after(function () {
    for (const fileTest of expectations) {
      cleanupSync(fileTest.compiled);
    }
  });
});

async function behaviourTest(
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
  ] of functionExpectation.steps) {
    const name = functionExpectation.name;
    const mangledFuncName =
      funcName !== 'constructor' ? findMethod(funcName, fileTest.compiled) : 'constructor';
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

function findMethod(functionName: string, fileName: string): string | null {
  if (!fs.existsSync(fileName)) {
    throw new Error(`Couldn't find compiled contract ${fileName}`);
  }

  const data: CompiledCairo = JSON.parse(fs.readFileSync(fileName, 'utf-8'));
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
