import * as path from 'path';
import * as fs from 'fs';
import { describe, it } from 'mocha';
import { expect } from 'chai';
import { sh } from '../util';
import {
  extractFromStdout,
  mintEthToAccount,
  CONTRACT_ADDRESS_REGEX,
  CONTRACT_CLASS_REGEX,
  NETWORK,
  NETWORK_OPTIONS,
  STARKNET_ACCOUNT_DIR,
  TIME_LIMIT,
  TX_FEE_ETH_REGEX,
  TX_FEE_WEI_REGEX,
  TX_HASH_REGEX,
  WALLET,
  WARP_BIN,
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

const ACCOUNT0 = `--account_dir ${STARKNET_ACCOUNT_DIR} --account account_0`;

describe('Manage starknet account', function () {
  this.timeout(TIME_LIMIT);

  it('should create a starknet account', async () => {
    if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'))) {
      fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
    }

    const { stdout } = await sh(
      `${WARP_BIN} new_account ${NETWORK_OPTIONS} --wallet ${WALLET} ${ACCOUNT0}`,
    );

    expect(stdout).to.not.be.empty;

    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    // verify the properties of the created account
    expect(starknet_open_zeppelin_accounts[NETWORK]).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']['private_key']).to.not.be
      .undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']['public_key']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']['salt']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']['address']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['account_0']['deployed']).to.be.false;
  });

  it('mint wei to the generated account', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const address = starknet_open_zeppelin_accounts[NETWORK]['account_0']['address'];

    const { stdout } = await mintEthToAccount(address);

    const response = JSON.parse(stdout);

    expect(response).to.not.be.undefined;
    expect(response['new_balance']).to.be.equal(1000000000000000000);
    expect(response['tx_hash']).to.not.be.undefined;
  });

  it('should deploy the starknet account', async () => {
    let { stdout } = await sh(
      `${WARP_BIN} deploy_account --wallet ${WALLET} ${NETWORK_OPTIONS} ${ACCOUNT0}`,
    );

    expect(stdout).to.not.be.empty;

    const txFeeEth = extractFromStdout(stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(stdout, TX_FEE_WEI_REGEX);
    const contract_address = extractFromStdout(stdout, CONTRACT_ADDRESS_REGEX);
    const txHash = extractFromStdout(stdout, TX_HASH_REGEX);

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;
    expect(contract_address).to.not.be.undefined;
    expect(txHash).to.not.be.undefined;

    const res = await sh(`${WARP_BIN} status ${txHash} ${NETWORK_OPTIONS}`);

    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Transpile & compile constract', function () {
  this.timeout(TIME_LIMIT);

  it('should transpile the NoConstructor contract', async () => {
    const { stdout } = await sh(
      `${WARP_BIN} transpile --dev ${path.resolve(__dirname, 'noArgsConstructor.sol')}`,
    );

    expect(stdout).to.be.empty;

    const res = await sh(`${WARP_BIN} compile ${contractCairoFile}`);

    expect(res.stdout).to.not.be.empty;
  });
});

describe('Declare the NoConstructor contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should declare the ERC20 contract', async () => {
    const { stdout } = await sh(
      `${WARP_BIN} declare ${contractCairoFile} --wallet ${WALLET} ${NETWORK_OPTIONS} ${ACCOUNT0}`,
    );

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
    const res = await sh(`${WARP_BIN} status ${txHash} ${NETWORK_OPTIONS}`);

    expect(res.stdout).to.not.be.empty;

    const { tx_status } = JSON.parse(res.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Deploy the NoConstructor contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should deploy the ERC20 contract', async () => {
    const { stdout } = await sh(
      `${WARP_BIN} deploy ${contractCairoFile} --wallet ${WALLET} ${NETWORK_OPTIONS} ${ACCOUNT0}`,
    );

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
    const res = await sh(`${WARP_BIN} status ${txHash} ${NETWORK_OPTIONS}`);

    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
    expect(contractAddress).to.not.be.empty;
  });
});

describe('Cleanup cli_test directory', function () {
  this.timeout(TIME_LIMIT);

  it('should remove the starknet account', async () => {
    fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
    if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json.backup'))) {
      fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json.backup'));
    }
  });
});
