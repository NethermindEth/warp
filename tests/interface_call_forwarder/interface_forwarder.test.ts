import { expect } from 'chai';
import { readFileSync, writeFileSync } from 'fs';
import { describe, it } from 'mocha';
import { gen_interface, starknetCompile, transpile } from '../util';
import path from 'path';
import { deploy, DeployResponse, ensureTestnetContactable, invoke } from '../testnetInterface';
import * as fs from 'fs';

const testPath = `${path.resolve(__dirname, '..')}/interface_call_forwarder`;
const cairoFile = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.cairo`;
const interfaceFile = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.sol`;
const interfaceTranspiledCairoFile = `${path.resolve(__dirname, '../..')}/warp_output${path.resolve(
  __dirname,
  '..',
)}/interface__call__forwarder/contract__WC__WARP.cairo`;
const contractJsonPath = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.json`;
const transpiledInterfaceJsonPath = `${path.resolve(
  __dirname,
  '..',
)}/interface_call_forwarder/interface.json`;

const TIME_LIMIT = 10 * 60 * 1000;

describe('Solidity interface generation from cairo contract should succeed', function () {
  it('should generate interface', async function () {
    const { stdout, stderr } = await gen_interface(cairoFile);
    expect(stdout).to.include('Running starknet compile with cairoPath /Users/rohit/nmd/warp');
    expect(stderr).to.include('');
  }).timeout(TIME_LIMIT);
});

describe('Interface solidity file should transpile', function () {
  before(async function () {
    const interfaceFileContent = readFileSync(interfaceFile, 'utf-8');

    const newInterfaceFileContent = interfaceFileContent.replace(
      [`contract WARP {`, `    // Write your logic here`, `}`].join('\n'),
      [
        `contract WARP {`,
        `   function add(address cairo_contract, uint256 a, uint256 b) public returns (uint256) {`,
        `       return add_771602f7(cairo_contract, a, b);`,
        `   }`,
        `   function sub(address cairo_contract, uint256 a, uint256 b) public returns (uint256) {`,
        `       return sub_b67d77c5(cairo_contract, a, b);`,
        `   }`,
        `}`,
      ].join('\n'),
    );
    writeFileSync(interfaceFile, newInterfaceFileContent);
  });

  it('should transpile', async function () {
    const { stdout, stderr } = await transpile(interfaceFile);
    expect(stderr, 'warp printed errors').to.include('');
    expect(stdout, 'warp printed errors').to.include('');
    expect(
      fs.existsSync(interfaceTranspiledCairoFile),
      `Transpilation failed, cannot find output file`,
    ).to.be.true;
  }).timeout(TIME_LIMIT);
});

describe('Transpiled contract is valid', function () {
  it('interface cair file is valid', async function () {
    await starknetCompile(cairoFile, contractJsonPath);
    await starknetCompile(interfaceTranspiledCairoFile, transpiledInterfaceJsonPath);
  }).timeout(TIME_LIMIT);
});

describe('Interaction between two cairo contracts', function () {
  before('testnet is reachable', async function () {
    const testnetContactable = await ensureTestnetContactable(60000);
    expect(testnetContactable, 'Failed to ping testnet').to.be.true;
  });

  let contractAddress: string | null;
  let interfaceContractAddress: string | null;

  it('interface contract should deploy', async function () {
    const deployContractResult: DeployResponse | null = await deploy(contractJsonPath, []);
    const deployInterfaceContractResult: DeployResponse | null = await deploy(
      transpiledInterfaceJsonPath,
      [],
    );
    expect(deployContractResult === null, 'Contract Deploy request failed').to.be.false;
    expect(deployContractResult.threw, 'Contract Deploy request failed').to.be.false;
    expect(deployInterfaceContractResult === null, 'Interface Contract Deploy request failed').to.be
      .false;
    expect(deployInterfaceContractResult.threw, 'Interface Contract Deploy request failed').to.be
      .false;
    expect(deployContractResult.contract_address, 'Contract Deploy request failed').to.not.be.null;
    expect(
      deployInterfaceContractResult.contract_address,
      'Interface Contract Deploy request failed',
    ).to.not.be.null;
    contractAddress = deployContractResult.contract_address;
    interfaceContractAddress = deployInterfaceContractResult.contract_address;
  }).timeout(TIME_LIMIT);
  it('interaction should succeed', async function () {
    if (contractAddress === null || interfaceContractAddress === null) this.skip();
    const response_add = await invoke(interfaceContractAddress, 'add_5101e128', [
      BigInt(contractAddress).toString(),
      '1',
      '0',
      '2',
      '0',
    ]);
    const response_sub = await invoke(interfaceContractAddress, 'sub_dff59cfe', [
      BigInt(contractAddress).toString(),
      '2',
      '0',
      '1',
      '0',
    ]);
    expect(response_add.threw, 'add_5101e128 threw').to.be.false;
    expect(response_sub.threw, 'sub_dff59cfe threw').to.be.false;
    expect(response_add.return_data, 'add_5101e128 return value should match [3, 0]').to.deep.equal(
      ['3', '0'],
    );
    expect(response_sub.return_data, 'sub_dff59cfe return value should match [1, 0]').to.deep.equal(
      ['1', '0'],
    );
  }).timeout(TIME_LIMIT);
});

describe('Frivoulous file deletion', function () {
  it('should delete files', async function () {
    const files = fs.readdirSync(testPath);
    for (const file of files) {
      if (file !== 'contract.cairo' && file !== 'interface_forwarder.test.ts') {
        fs.unlinkSync(`${testPath}/${file}`);
      }
    }
  });
});
