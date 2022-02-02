import { expect } from 'chai';
import { describe, it } from 'mocha';
import { step } from 'mocha-steps';
import { transpile } from './util';
import * as fs from 'fs';
import { deploy, invoke } from './testnetInterface';

describe('warp-ts', function () {
  //Set the tests to time out if they take longer than 3 minutes per test
  this.timeout(180000);

  const solPath = 'tests/contracts/example.sol';
  const cairoPath = 'tests/artifacts/example.cairo';
  const jsonPath = 'tests/artifacts/example.json';

  let c_ContractAddress: string;

  before(async function () {
    await transpile(solPath, cairoPath, jsonPath);
  });

  step('Produces a transpiled contract', async function () {
    expect(fs.existsSync(cairoPath));
  });

  step('Produces a compiled contract', async function () {
    expect(fs.existsSync(jsonPath));
  });

  step('Contract is deployable', async function () {
    const response = await deploy(jsonPath);
    expect(response.status).to.equal(200);
    c_ContractAddress = response.address;
  });

  step('Contract member function is invokable', async function () {
    const response = await invoke(c_ContractAddress, 'test_f8a8fd6d');
    expect(response.status).to.equal(200);
    expect(response.return_data).to.deep.equal([]);
  });

  step('Contract member function returns a value', async function () {
    const response = await invoke(c_ContractAddress, 'returnTest_57ecc147');
    expect(response.status).to.equal(200);
    expect(response.return_data).to.deep.equal([12, 0]);
  });
});
