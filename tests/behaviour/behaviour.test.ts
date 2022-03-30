import * as fs from 'fs';

import { SafePromise, cleanupSync, starknetCompile, transpile, wrapPromise } from '../util';
import { deploy, ensureTestnetContactable, invoke } from '../testnetInterface';

import { describe } from 'mocha';
import { expect } from 'chai';
import { expectations } from './expectations';

describe('Transpile solidity', function () {
  this.timeout(1800000);

  let transpileResults: SafePromise<{ stderr: string }>[];

  before(function () {
    for (const fileTest of expectations) {
      cleanupSync(fileTest.cairo);
      cleanupSync(fileTest.compiled);
    }

    transpileResults = expectations.map((fileTest) => wrapPromise(transpile(fileTest.sol)));
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      const res = await transpileResults[i];
      expect(res.result, 'warp-ts printed errors').to.include({ stderr: '' });
      expect(
        fs.existsSync(expectations[i].cairo),
        'Transpilation failed, cannot find output file',
      ).to.be.true;
      expect(res.success, `${res.result}`);
    });
  }
});

describe('Transpiled contracts are valid cairo', function () {
  this.timeout(1800000);

  let compileResults: (SafePromise<{ stderr: string }> | null)[];

  before(function () {
    compileResults = expectations.map((fileTest) =>
      fs.existsSync(fileTest.cairo)
        ? wrapPromise(starknetCompile(fileTest.cairo, fileTest.compiled))
        : null,
    );
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      const unresolvedResult = compileResults[i];
      if (unresolvedResult === null) {
        this.skip();
      } else {
        const res = await unresolvedResult;
        expect(res.result, 'starknet-compile printed errors').to.include({ stderr: '' });
        expect(fs.existsSync(expectations[i].compiled), 'Compilation failed').to.be.true;
        expect(res.success, `${res.result}`);
      }
    });
  }
});

const deployedAddresses: Map<string, string> = new Map();

describe('Compiled contracts are deployable', function () {
  this.timeout(1800000);

  // let deployResults: SafePromise<string>[];
  const deployResults: (
    | { success: true; result: string }
    | { success: false; result: unknown }
    | null
  )[] = [];

  before(async function () {
    const testnetContactable = await ensureTestnetContactable(20000);
    expect(testnetContactable, 'Failed to ping testnet').to.be.true;
    // deployResults = expectations.map(async (fileTest) =>
    //   wrapPromise(deploy(fileTest.compiled, [])),
    // );
    for (const fileTest of expectations) {
      if (fs.existsSync(fileTest.compiled) && fs.readFileSync(fileTest.compiled).length > 0) {
        deployResults.push(await wrapPromise(deploy(fileTest.compiled, [])));
      } else {
        deployResults.push(null);
      }
    }
  });

  for (let i = 0; i < expectations.length; ++i) {
    it(expectations[i].name, async function () {
      // const response = await deployResults[i];
      const response = deployResults[i];
      if (response === null) {
        this.skip();
      } else {
        expect(response.success, 'Deploy request failed').to.be.true;
        if (response.success) {
          deployedAddresses.set(expectations[i].name, response.result);
        }
      }
    });
  }
});

describe('Deployed contracts have correct behaviour', function () {
  this.timeout(1800000);

  for (const fileTest of expectations) {
    describe(fileTest.name, function () {
      for (const functionExpectation of fileTest.expectations) {
        it(functionExpectation.name, async function () {
          for (const [
            funcName,
            inputs,
            expectedResult,
            caller_address,
            error_message,
          ] of functionExpectation.steps) {
            const address = deployedAddresses.get(fileTest.name);

            if (address === undefined) this.skip();

            const mangledFuncName = findMethod(funcName, fileTest.compiled);
            if (mangledFuncName === null) {
              expect(mangledFuncName, `Unable to find function ${funcName}`).to.not.be.null;
            } else {
              const response = await invoke(address, mangledFuncName, inputs, caller_address);

              console.log(`${fileTest.name} - ${mangledFuncName}: ${response.steps} steps`);

              expect(response.status, 'Unhandled starknet-testnet error').to.equal(200);

              if (expectedResult === null) {
                expect(response.threw, 'Function should throw').to.be.true;
                error_message !== undefined &&
                  response.error_message !== undefined &&
                  expect(response.error_message.includes(error_message)).to.be.true;
              } else {
                expect(
                  response.threw,
                  `Function should not throw, but threw with message: ${response.error_message}`,
                ).to.be.false;
                expect(response.return_data, 'Return data should match expectation').to.deep.equal(
                  expectedResult,
                );
              }
            }
          }
        });
      }
    });
  }

  after(function () {
    for (const fileTest of expectations) {
      cleanupSync(fileTest.compiled);
    }
  });
});

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
