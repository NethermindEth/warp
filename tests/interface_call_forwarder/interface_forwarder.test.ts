import { expect } from 'chai';
import { readFileSync, writeFileSync } from 'fs';
import { describe, it } from 'mocha';
import { gen_interface, starknetCompile, transpile } from '../util';
import path from 'path';
import { deploy, DeployResponse, ensureTestnetContactable, invoke } from '../testnetInterface';
import * as fs from 'fs';

const testPath = `${path.resolve(__dirname, '..')}/interface_call_forwarder`;
const cairoFile = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.cairo`;
const interfaceSolFile = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.sol`;
const interfaceCairoFile = `${path.resolve(
  __dirname,
  '..',
)}/interface_call_forwarder/contract_forwarder.cairo`;
const interfaceTranspiledCairoFile = `${path.resolve(__dirname, '../..')}/warp_output${path.resolve(
  __dirname,
  '..',
)}/interface__call__forwarder/contract__WC__contract_forwarder.cairo`;
const contractJsonPath = `${path.resolve(__dirname, '..')}/interface_call_forwarder/contract.json`;
const transpiledInterfaceJsonPath = `${path.resolve(
  __dirname,
  '..',
)}/interface_call_forwarder/interface.json`;

const TIME_LIMIT = 10 * 60 * 1000;

let cairoContractAddress: string | undefined;
let proxyCairoContractAddress: string | null;

describe('contract.cairo should compile & deploy', function () {
  this.timeout(TIME_LIMIT);
  it('contract.cairo should compile', async function () {
    await starknetCompile(cairoFile, contractJsonPath);
  });
  it('contract.cairo should deploy', async () => {
    const deployContractResult: DeployResponse | null = await deploy(contractJsonPath, []);
    expect(deployContractResult === null, 'Contract Deploy request failed').to.be.false;
    expect(deployContractResult.threw, 'Contract Deploy request failed').to.be.false;
    expect(deployContractResult.contract_address, 'Contract Deploy request failed').to.not.be.null;
    if (deployContractResult.contract_address)
      cairoContractAddress = deployContractResult.contract_address;
  });
});

describe('Solidity & Cairo interface generation from cairo contract should succeed', function () {
  this.timeout(TIME_LIMIT);
  it('should generate interface files', async function () {
    const { stdout, stderr } = await gen_interface(cairoFile, cairoContractAddress);
    expect(stdout).to.include(
      `Running starknet compile with cairoPath ${path.resolve(__dirname, '../..')}`,
    );
    expect(stderr).to.include('');
  });
});

describe('Cairo Proxy contract is valid and deployable', async function () {
  this.timeout(TIME_LIMIT);
  it('cairo proxy contract should compile', async function () {
    await starknetCompile(interfaceCairoFile, transpiledInterfaceJsonPath);
  });
  it('cairo proxy contract should deploy', async function () {
    const deployContractResult: DeployResponse | null = await deploy(
      transpiledInterfaceJsonPath,
      [],
    );
    expect(deployContractResult === null, 'Contract Deploy request failed').to.be.false;
    expect(deployContractResult.threw, 'Contract Deploy request failed').to.be.false;
    expect(deployContractResult.contract_address, 'Contract Deploy request failed').to.not.be.null;
    proxyCairoContractAddress = deployContractResult.contract_address;
  });
});

describe('Interface solidity file should transpile', function () {
  this.timeout(TIME_LIMIT);
  it('Add interactive contract', async function () {
    const interfaceSolFileContent = readFileSync(interfaceSolFile, 'utf-8');

    const newInterfaceSolFileContent = interfaceSolFileContent.concat(
      [
        '\n',
        `contract itr{`,
        `    address cairoContractAddress;`,
        `    constructor(address contractAddress) {`,
        `        cairoContractAddress = contractAddress;`,
        `    }`,
        `    function add(uint256 a, uint256 b) external returns (uint256 res) {`,
        `        return Forwarder_contract(cairoContractAddress).add(a, b);`,
        `    }`,
        `    function sub(uint256 a, uint256 b) external returns (uint256 res) {`,
        `        return Forwarder_contract(cairoContractAddress).sub(a, b);`,
        `    }`,
        `}`,
      ].join('\n'),
    );
    writeFileSync(interfaceSolFile, newInterfaceSolFileContent);
  });

  it('should transpile', async function () {
    const { stdout, stderr } = await transpile(interfaceSolFile);
    expect(stderr, 'warp printed errors').to.include('');
    expect(stdout, 'warp printed errors').to.include('');
    expect(
      fs.existsSync(interfaceTranspiledCairoFile),
      `Transpilation failed, cannot find output file`,
    ).to.be.true;
  });
});

describe('Transpiled interface solidity contract is valid', function () {
  this.timeout(TIME_LIMIT);
  it('interface cairo file is valid', async function () {
    await starknetCompile(interfaceTranspiledCairoFile, transpiledInterfaceJsonPath);
  });
});

describe('Interaction between two cairo contracts', function () {
  this.timeout(TIME_LIMIT);
  before('testnet is reachable', async function () {
    const testnetContactable = await ensureTestnetContactable(TIME_LIMIT);
    expect(testnetContactable, 'Failed to ping testnet').to.be.true;
  });

  let interfaceContractAddress: string | null;

  it('Transpiled interface solidity contract should deploy', async function () {
    if (proxyCairoContractAddress === null) this.skip();
    const deployInterfaceContractResult: DeployResponse | null = await deploy(
      transpiledInterfaceJsonPath,
      [BigInt(proxyCairoContractAddress).toString()],
    );
    expect(deployInterfaceContractResult === null, 'Interface Contract Deploy request failed').to.be
      .false;
    expect(deployInterfaceContractResult.threw, 'Interface Contract Deploy request failed').to.be
      .false;
    expect(
      deployInterfaceContractResult.contract_address,
      'Interface Contract Deploy request failed',
    ).to.not.be.null;
    interfaceContractAddress = deployInterfaceContractResult.contract_address;
  });

  it('interaction should succeed', async function () {
    if (interfaceContractAddress === null || proxyCairoContractAddress === null) this.skip();
    const cairo_contract_address = await invoke(
      interfaceContractAddress,
      '__fwd_contract_address_5f4aa1ae',
      [],
    );
    expect(cairo_contract_address.threw, 'Failed to get cairo contract address').to.be.false;
    expect(cairo_contract_address.return_data, 'Failed to get cairo contract address').to.not.be
      .null;
    expect(
      cairo_contract_address.return_data,
      `Should match ${proxyCairoContractAddress}`,
    ).to.deep.equal([BigInt(proxyCairoContractAddress).toString()]);
    const response_add = await invoke(interfaceContractAddress, 'add_771602f7', [
      '1',
      '0',
      '2',
      '0',
    ]);
    expect(response_add.threw, 'add_771602f7 threw').to.be.false;
    expect(response_add.return_data, 'add_771602f7 return value should match [3, 0]').to.deep.equal(
      ['3', '0'],
    );
    const response_sub = await invoke(interfaceContractAddress, 'sub_b67d77c5', [
      '2',
      '0',
      '1',
      '0',
    ]);
    expect(response_sub.threw, 'sub_b67d77c5 threw').to.be.false;
    expect(response_sub.return_data, 'sub_b67d77c5 return value should match [1, 0]').to.deep.equal(
      ['1', '0'],
    );
  });
});

describe('Frivoulous file deletion', function () {
  this.timeout(TIME_LIMIT);
  it('should delete files', async function () {
    const files = fs.readdirSync(testPath);
    for (const file of files) {
      if (file !== 'contract.cairo' && file !== 'interface_forwarder.test.ts') {
        fs.unlinkSync(`${testPath}/${file}`);
      }
    }
  });
});
