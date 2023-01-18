import * as path from 'path';
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
} from './utils';

const accountDir = path.resolve(__dirname, 'predeployed_accounts');

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
      `${warpBin} declare ${contractCairoFile} --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${accountDir} --account account_0`,
    );

    console.log(
      `${warpBin} declare ${contractCairoFile} --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${accountDir} --account account_0`,
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
      `${warpBin} deploy ${contractCairoFile} --wallet ${wallet} --feeder_gateway_url ${gatewayURL} --gateway_url ${gatewayURL} --network ${network} --account_dir ${accountDir} --account account_0`,
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
