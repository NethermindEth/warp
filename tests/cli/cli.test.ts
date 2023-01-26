import * as path from 'path';
import fs from 'fs';
import { describe, it } from 'mocha';
import { expect } from 'chai';
import { sh } from '../util';
import {
  STARKNET_ACCOUNT_DIR,
  CONTRACT_ADDRESS_REGEX,
  CONTRACT_CLASS_REGEX,
  extractFromStdout,
  GATEWAY_URL,
  mintEthToAccount,
  NETWORK,
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
  'contract.sol',
  'MyToken.cairo',
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
      `${WARP_BIN} new_account --wallet ${WALLET} --network ${NETWORK} --feeder_gateway_url ${GATEWAY_URL} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    expect(stderr).to.be.empty;
    expect(stdout).to.not.be.empty;

    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    // verify the properties of the created account
    expect(starknet_open_zeppelin_accounts[NETWORK]).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']['private_key']).to.not.be
      .undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']['public_key']).to.not.be
      .undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']['salt']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']['address']).to.not.be.undefined;
    expect(starknet_open_zeppelin_accounts[NETWORK]['__default__']['deployed']).to.be.false;
  });

  it('mint wei to the generated account', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const address = starknet_open_zeppelin_accounts[NETWORK]['__default__']['address'];

    const { stdout } = await mintEthToAccount(address);

    const response = JSON.parse(stdout);

    expect(response).to.not.be.undefined;
    expect(response['new_balance']).to.be.equal(1000000000000000000);
    expect(response['tx_hash']).to.not.be.undefined;
  });

  it('should deploy the starknet account', async () => {
    const { stdout, stderr } = await sh(
      `${WARP_BIN} deploy_account --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
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
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Transpile & compile a ERC20 based contract (MyToken)', function () {
  this.timeout(TIME_LIMIT);

  it('should transpile the MyToken contract', async () => {
    const { stdout, stderr } = await sh(
      `${WARP_BIN} transpile --dev ${path.resolve(__dirname, 'contract.sol')}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout).to.be.empty;

    const res = await sh(`${WARP_BIN} compile ${contractCairoFile}`);

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;
  });
});

describe('Declare the MyToken contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should declare the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${WARP_BIN} declare ${contractCairoFile} --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
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
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const { tx_status } = JSON.parse(res.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Deploy the MyToken contract', function () {
  this.timeout(TIME_LIMIT);

  let txHash: string;

  it('should deploy the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${WARP_BIN} deploy ${contractCairoFile} --inputs 500  --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
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
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Call MyToken contract functions', function () {
  this.timeout(TIME_LIMIT);

  it('get Total Supply', async () => {
    expect(contractAddress).to.not.be.undefined;
    const { stdout, stderr } = await sh(
      `${WARP_BIN} call ${contractCairoFile} --function totalSupply --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout.split('\n')[1].trim()).to.be.equal('500');
  });

  it('balance of owner should equal totalSupply', async () => {
    expect(contractAddress).to.not.be.undefined;
    const accountFile = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const { stdout, stderr } = await sh(
      `${WARP_BIN} call ${contractCairoFile} --function balanceOf  --inputs ${accountFile[NETWORK].__default__.address} --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout.split('\n')[1].trim()).to.be.equal('500');
  });
});

describe('Invoke MyToken contract functions', function () {
  this.timeout(TIME_LIMIT);

  before('create few new accounts & deploy them', async () => {
    // account creation
    await sh(
      `${WARP_BIN} new_account --account user1 --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    await sh(
      `${WARP_BIN} new_account --account user2 --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    //mint some WEIs to these accounts
    const accountJSON = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    await mintEthToAccount(accountJSON[NETWORK].user1.address);
    await mintEthToAccount(accountJSON[NETWORK].user2.address);

    // account deployment
    await sh(
      `${WARP_BIN} deploy_account --account user1 --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
    await sh(
      `${WARP_BIN} deploy_account --account user2 --wallet ${WALLET} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL} --network ${NETWORK} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
  });

  it('Transfer 100 tokens from owner to user1', async () => {
    const accountJSON = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const transferToUser1 = await sh(
      `${WARP_BIN} invoke ${contractCairoFile} --function transfer --inputs ${accountJSON[NETWORK].user1.address} 100  --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    expect(transferToUser1.stderr).to.be.empty;

    const txFeeEth = extractFromStdout(transferToUser1.stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(transferToUser1.stdout, TX_FEE_WEI_REGEX);
    const txHash = extractFromStdout(transferToUser1.stdout, TX_HASH_REGEX);

    const txStatus = await sh(
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;
    expect(txStatus.stderr).to.be.empty;

    const { tx_status } = JSON.parse(txStatus.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });

  it('Approve 200 tokens to user2', async () => {
    const accountJSON = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const approveToUser2 = await sh(
      `${WARP_BIN} invoke ${contractCairoFile} --function approve --inputs ${accountJSON[NETWORK].user2.address} 200  --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    expect(approveToUser2.stderr).to.be.empty;

    const txFeeEth = extractFromStdout(approveToUser2.stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(approveToUser2.stdout, TX_FEE_WEI_REGEX);

    const txHash = extractFromStdout(approveToUser2.stdout, TX_HASH_REGEX);

    const txStatus = await sh(
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;
    expect(txStatus.stderr).to.be.empty;

    const { tx_status } = JSON.parse(txStatus.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });

  it('Transfer 100 tokens from user2 to user1 on behalf of owner', async () => {
    const accountJSON = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const transferFromUser2ToUser1 = await sh(
      `${WARP_BIN} invoke ${contractCairoFile} --function transferFrom --inputs ${accountJSON[NETWORK].__default__.address} ${accountJSON[NETWORK].user1.address} 100  --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR} --account user2`,
    );

    expect(transferFromUser2ToUser1.stderr).to.be.empty;

    const txFeeEth = extractFromStdout(transferFromUser2ToUser1.stdout, TX_FEE_ETH_REGEX);
    const txFeeWei = extractFromStdout(transferFromUser2ToUser1.stdout, TX_FEE_WEI_REGEX);

    const txHash = transferFromUser2ToUser1.stdout.split('\n')[4].split(':')[1].trim();

    const txStatus = await sh(
      `${WARP_BIN} status ${txHash} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL}`,
    );

    expect(txFeeEth).to.not.be.undefined;
    expect(txFeeWei).to.not.be.undefined;
    expect(txStatus.stderr).to.be.empty;

    const { tx_status } = JSON.parse(txStatus.stdout);
    expect(tx_status).to.equal('ACCEPTED_ON_L2');
  });

  this.afterAll('Verify accounts balance', async () => {
    const accountJSON = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const ownerBalance = await sh(
      `${WARP_BIN} call ${contractCairoFile} --function balanceOf  --inputs ${accountJSON[NETWORK].__default__.address} --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
    expect(ownerBalance.stderr).to.be.empty;
    expect(ownerBalance.stdout.split('\n')[1].trim()).to.be.equal('300');

    const user1Balance = await sh(
      `${WARP_BIN} call ${contractCairoFile} --function balanceOf  --inputs ${accountJSON[NETWORK].user1.address} --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );
    expect(user1Balance.stderr).to.be.empty;
    expect(user1Balance.stdout.split('\n')[1].trim()).to.be.equal('200');

    const user2Balance = await sh(
      `${WARP_BIN} call ${contractCairoFile} --function balanceOf  --inputs ${accountJSON[NETWORK].user2.address} --address ${contractAddress} --network ${NETWORK} --gateway_url ${GATEWAY_URL} --feeder_gateway_url ${GATEWAY_URL} --wallet ${WALLET} --account_dir ${STARKNET_ACCOUNT_DIR}`,
    );

    expect(user2Balance.stderr).to.be.empty;
    expect(user2Balance.stdout.split('\n')[1].trim()).to.be.equal('0');
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

  it('remove contract generated files', async () => {
    if (fs.existsSync(path.resolve(__dirname, 'contract.json'))) {
      fs.unlinkSync(path.resolve(__dirname, 'contract.json'));
    }
  });
});
