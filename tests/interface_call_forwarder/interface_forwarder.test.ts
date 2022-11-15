import { expect } from 'chai';
import { readFileSync, writeFileSync } from 'fs';
import { describe, it } from 'mocha';
import { gen_interface, starknetCompile, transpile } from '../util';
import path from 'path';
import {
  declare,
  deploy,
  DeployResponse,
  ensureTestnetContactable,
  invoke,
} from '../testnetInterface';
import * as fs from 'fs';

const testPath = path.resolve(__dirname, '..', 'interface_call_forwarder');
const cairoFile = path.resolve(__dirname, '..', 'interface_call_forwarder', 'contract.cairo');
const interfaceSolFile = path.resolve(__dirname, '..', 'interface_call_forwarder', 'interact.sol');
const interfaceCairoFile = path.resolve(
  __dirname,
  '..',
  'interface_call_forwarder',
  'contract_forwarder.cairo',
);
const interfaceTranspiledCairoFile = `${path.resolve(
  __dirname,
  '../..',
  'warp_output',
)}/${path.resolve(__dirname, '..', 'interface_call_forwarder', 'interact.sol', 'itr.cairo')}`;
const contractJsonPath = path.resolve(__dirname, '..', 'interface_call_forwarder', 'contract.json');
const transpiledInterfaceJsonPath = path.resolve(
  __dirname,
  '..',
  'interface_call_forwarder',
  'interface.json',
);

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
    await declare(transpiledInterfaceJsonPath);
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
  it('interact contract should transpile', async function () {
    const { stdout, stderr } = await transpile(interfaceSolFile);
    expect(stderr, 'warp printed errors').to.include('');
    expect(stdout, 'warp printed errors').to.include('');
    expect(
      fs.existsSync(interfaceTranspiledCairoFile),
      `Transpilation failed, cannot find transpiled cairo output file`,
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
      'cairoContractAddress_b0da831b',
      [],
    );
    expect(cairo_contract_address.threw, 'Failed to get cairo contract address').to.be.false;
    expect(cairo_contract_address.return_data, 'Failed to get cairo contract address').to.not.be
      .null;
    expect(
      cairo_contract_address.return_data,
      `Should match ${proxyCairoContractAddress}`,
    ).to.deep.equal([BigInt(proxyCairoContractAddress).toString()]);

    ///---------------------------------- Function call tests ----------------------------------
    // add
    const response_add = await invoke(interfaceContractAddress, 'add_771602f7', [
      '1',
      '0',
      '2',
      '0',
    ]);
    expect(response_add.threw, 'add_771602f7 threw').to.be.false;
    expect(response_add.return_data, 'add_771602f7 return value should match').to.deep.equal([
      '3',
      '0',
    ]);

    // arrayAdd
    const response_array_add = await invoke(interfaceContractAddress, 'arrayAdd_d85a3c39', [
      '2',
      '2',
      '0',
      '3',
      '0',
      '4',
      '0',
    ]);
    expect(response_array_add.threw, 'arrayAdd_d85a3c39 threw').to.be.false;
    expect(
      response_array_add.return_data,
      'arrayAdd_d85a3c39 return value should match',
    ).to.deep.equal(['2', '6', '0', '7', '0']);

    // staticArrayAdd
    const response_static_array_add = await invoke(
      interfaceContractAddress,
      'staticArrayAdd_c20ab944',
      ['2', '0', '3', '0', '4', '0', '67', '0', '66', '0', '65', '0'],
    );
    expect(response_static_array_add.threw, 'staticArrayAdd_c20ab944 threw').to.be.false;
    expect(
      response_static_array_add.return_data,
      'staticArrayAdd_c20ab944 return value should match',
    ).to.deep.equal(['69', '0', '69', '0', '69', '0']);

    // structAdd
    const response_structAdd = await invoke(interfaceContractAddress, 'structAdd_8658db55', [
      '2',
      '0',
      '3',
      '0',
      '4',
      '0',
      '5',
      '0',
      '6',
      '0',
      '66',
      '0',
    ]);
    expect(response_structAdd.threw, 'structAdd_8658db55 threw').to.be.false;
    expect(
      response_structAdd.return_data,
      'structAdd_8658db55 return value should match',
    ).to.deep.equal(['68', '0', '69', '0', '70', '0', '71', '0', '72', '0']);

    // array2DaddStatic
    const response_array2DaddStatic = await invoke(
      interfaceContractAddress,
      'array2DaddStatic_f1962835',
      [
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
        '2',
        '0',
        '3',
        '0',
        '4',
        '0',
      ],
    );
    expect(response_array2DaddStatic.threw, 'array2DaddStatic_f1962835 threw').to.be.false;
    expect(
      response_array2DaddStatic.return_data,
      'array2DaddStatic_f1962835 return value should match',
    ).to.deep.equal([
      '4',
      '0',
      '6',
      '0',
      '8',
      '0',
      '4',
      '0',
      '6',
      '0',
      '8',
      '0',
      '4',
      '0',
      '6',
      '0',
      '8',
      '0',
    ]);
  });
});

describe('Frivoulous file deletion', function () {
  this.timeout(TIME_LIMIT);
  it('should delete files', async function () {
    const files = fs.readdirSync(testPath);
    for (const file of files) {
      if (
        file !== 'contract.cairo' &&
        file !== 'interface_forwarder.test.ts' &&
        file !== 'interact.sol'
      ) {
        fs.unlinkSync(`${testPath}/${file}`);
      }
    }
  });
});
