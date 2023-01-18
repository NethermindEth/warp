import * as path from 'path';
import * as fs from 'fs';
import { describe, it } from 'mocha';
import { expect } from 'chai';
import { sh } from '../util';
import {
  CONTRACT_ADDRESS_REGEX,
  CONTRACT_CLASS_REGEX,
  extractFromStdout,
  gatewayURL,
  network,
  TIME_LIMIT,
  TX_FEE_ETH_REGEX,
  TX_FEE_WEI_REGEX,
  TX_HASH_REGEX,
  wallet,
  warpBin,
  starkNetAccountDir,
  mintEthToAccount,
} from './utils';

const contractCairoFile = path.resolve(
  __dirname,
  '..',
  '..',
  'warp_output',
  'tests',
  'cli',
  'noArgsConstructor.sol',
  'NoConstructor.cairo',
);

let contractClassHash: string;
let contractAddress: string;

describe('Manage starknet account', function () {
  this.timeout(TIME_LIMIT);

  it('should create a starknet account', async () => {
    if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'))) {
      fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
    }

    const { stdout, stderr } = await sh(
      `${warpBin} new_account --wallet ${wallet} --network ${network} --feeder_gateway_url ${gatewayURL} --account_dir ${starkNetAccountDir}`,
    );

    expect(stderr).to.be.empty;
    expect(stdout).to.not.be.empty;

    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    // verify the properties of the created account
    expect(starknet_open_zeppelin_accounts[network]).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']['private_key']).to.not.be
      .undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']['public_key']).to.not.be
      .undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']['salt']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']['address']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[network]['__default__']['deployed']).to.be.false;
  });

  it('mint wei to the generated account', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const address = starknet_open_zeppelin_accounts[network]['__default__']['address'];

    const { stdout } = await mintEthToAccount(address);

    const response = JSON.parse(stdout);

    expect(response).to.not.be.undefined;
    expect(response['new_balance']).to.be.equal(1000000000000000000);
    expect(response['tx_hash']).to.not.be.undefined;
  });

  it('should deploy the starknet account', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} deploy_account --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${starkNetAccountDir}`,
    );

    expect(stderr).to.be.empty;
    expect(stdout).to.not.be.empty;

    const txFeeEth = extractFromStdout(stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(stdout, TX_FEE_WEI_REGEX);
    const contract_address = extractFromStdout(stdout, CONTRACT_ADDRESS_REGEX);
    const txHash = extractFromStdout(stdout, TX_HASH_REGEX);

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;
    expect(contract_address).to.not.be.undefined;
    expect(txHash).to.not.be.undefined;

    const res = await sh(
      `${warpBin} status ${txHash} --network ${network} --gateway_url ${gatewayURL} --feeder_gateway_url ${gatewayURL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Transpile & compile constract', function () {
  this.timeout(TIME_LIMIT);

  it('should transpile the NoConstructor contract', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} transpile --dev ${path.resolve(__dirname, 'noArgsConstructor.sol')}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout).to.be.empty;

    const res = await sh(`${warpBin} compile ${contractCairoFile}`);

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;
  });
});

describe('Declare the NoConstructor contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should declare the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} declare ${contractCairoFile} --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${starkNetAccountDir}`,
    );

    expect(stderr).to.be.empty;

    const txFeeEth = extractFromStdout(stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(stdout, TX_FEE_WEI_REGEX);

    contractClassHash = extractFromStdout(stdout, CONTRACT_CLASS_REGEX);
    txHash = extractFromStdout(stdout, TX_HASH_REGEX);

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;

    expect(contractClassHash).to.not.be.undefined;
    expect(txHash).to.not.be.undefined;
  });

  this.afterAll('Declare transaction status', async () => {
    const res = await sh(
      `${warpBin} status ${txHash} --network ${network} --gateway_url ${gatewayURL} --feeder_gateway_url ${gatewayURL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const { tx_status } = JSON.parse(res.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Deploy the NoConstructor contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should deploy the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} deploy ${contractCairoFile} --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${starkNetAccountDir}`,
    );

    expect(stderr).to.be.empty;

    const txFeeEth = extractFromStdout(stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(stdout, TX_FEE_WEI_REGEX);
    contractAddress = extractFromStdout(stdout, CONTRACT_ADDRESS_REGEX);
    txHash = extractFromStdout(stdout, TX_HASH_REGEX);

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;

    expect(contractClassHash).to.not.be.undefined;
    expect(txHash).to.not.be.undefined;
  });

  this.afterAll('Deploy transaction status', async () => {
    const res = await sh(
      `${warpBin} status ${txHash} --network ${network} --gateway_url ${gatewayURL} --feeder_gateway_url ${gatewayURL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
    expect(contractAddress).to.not.be.empty;
  });
});
