import { expect } from 'chai';
import { sh } from '../util';
import { describe, it } from 'mocha';
import * as path from 'path';
import fs from 'fs';

const starknet_wallet = 'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount';
const gateway_url = 'http://127.0.0.1:5050';
const network = 'alpha-goerli';
const account_dir = path.resolve(__dirname, '.');

const TIME_LIMIT = 10 * 60 * 1000;

const warpBin = path.resolve(__dirname, '..', '..', '..', 'bin', 'warp');

const contractCairoFile = path.resolve(
  __dirname,
  '..',
  '..',
  '..',
  'warp_output',
  'src',
  'cli',
  'tests',
  'contract.sol',
  'MyToken.cairo',
);

let contract_class_hash: string;
let contract_address: string;

async function mintEthToAccount(address: string): Promise<{ stdout: string; stderr: string }> {
  const res = await sh(
    `curl localhost:5050/mint -H "Content-Type: application/json" -d "{ \\"address\\": \\"${address}\\", \\"amount\\": 1000000000000000000, \\"lite\\": false }"`,
  );
  return res;
}

describe('Manage starknet account', function () {
  this.timeout(TIME_LIMIT);
  it('should create a starknet account', async () => {
    if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'))) {
      fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
    }

    const { stdout, stderr } = await sh(
      `${warpBin} new_account --wallet ${starknet_wallet} --network ${network} --feeder_gateway_url ${gateway_url} --account_dir ${account_dir}`,
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
    expect(response['new_balance']).to.not.be.undefined;
    expect(response['new_balance']).to.equal(1000000000000000000);
    expect(response['tx_hash']).to.not.be.undefined;
  });

  it('should deploy the starknet account', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} deploy_account --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

    expect(stderr).to.be.empty;
    expect(stdout).to.not.be.empty;

    const tx_fee_eth = stdout.split('\n')[0].split(':')[1].split('ETH')[0].trim();
    const tx_fee_wei = stdout
      .split('\n')[0]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    const contract_address = stdout.split('\n')[3].split(':')[1].trim();
    const tx_hash = stdout.split('\n')[4].split(':')[1].trim();

    expect(stdout).to.be.equal(
      [
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Sent deploy account contract transaction.\n`,
        `Contract address: ${contract_address}`,
        `Transaction hash: ${tx_hash}`,
        '\n',
      ].join('\n'),
    );

    expect(contract_address).to.not.be.undefined;
    expect(tx_hash).to.not.be.undefined;

    const res = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
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
      `${warpBin} transpile --dev ${path.resolve(__dirname, 'contract.sol')}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout).to.be.empty;

    const res = await sh(`${warpBin} compile ${contractCairoFile}`);

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;
  });
});

describe('Declare the MyToken contract', function () {
  this.timeout(TIME_LIMIT);

  let tx_hash: string;

  it('should declare the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} declare ${contractCairoFile} --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

    expect(stderr).to.be.empty;

    const tx_fee_eth = stdout.split('\n')[1].split(':')[1].split('ETH')[0].trim();
    const tx_fee_wei = stdout
      .split('\n')[1]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    contract_class_hash = stdout.split('\n')[3].split(':')[1].trim();
    tx_hash = stdout.split('\n')[4].split(':')[1].trim();

    expect(stdout).to.be.equal(
      [
        `Running starknet compile with cairoPath ${path.resolve(__dirname, '..', '..', '..')}`,
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Declare transaction was sent.`,
        `Contract class hash: ${contract_class_hash}`,
        `Transaction hash: ${tx_hash}\n`,
      ].join('\n'),
    );

    expect(contract_class_hash).to.not.be.undefined;
    expect(tx_hash).to.not.be.undefined;
  });

  this.afterAll('Declare transaction status', async () => {
    const res = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
    );

    expect(res.stderr).to.be.empty;
    expect(res.stdout).to.not.be.empty;

    const response = JSON.parse(res.stdout);
    expect(response.tx_status).to.equal('ACCEPTED_ON_L2');
  });
});

describe('Deploy the MyToken contract', function () {
  this.timeout(TIME_LIMIT);

  let tx_hash: string;

  it('should deploy the ERC20 contract', async () => {
    const { stdout, stderr } = await sh(
      `${warpBin} deploy ${contractCairoFile} --inputs 500 0 --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

    expect(stderr).to.be.empty;

    const tx_fee_eth = stdout.split('\n')[1].split(':')[1].split('ETH')[0].trim();
    const tx_fee_wei = stdout
      .split('\n')[1]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    contract_address = stdout.split('\n')[3].split(':')[1].trim();
    tx_hash = stdout.split('\n')[4].split(':')[1].trim();

    expect(stdout).to.be.equal(
      [
        `Running starknet compile with cairoPath ${path.resolve(__dirname, '..', '..', '..')}`,
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Invoke transaction for contract deployment was sent.`,
        `Contract address: ${contract_address}`,
        `Transaction hash: ${tx_hash}\n`,
      ].join('\n'),
    );

    expect(contract_class_hash).to.not.be.undefined;
    expect(tx_hash).to.not.be.undefined;
  });

  this.afterAll('Deploy transaction status', async () => {
    const res = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
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
    expect(contract_address).to.not.be.undefined;
    const { stdout, stderr } = await sh(
      `${warpBin} call ${contractCairoFile} --function totalSupply --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout.split('\n')[1].trim()).to.be.equal('500');
  });
  it('get Total Supply call using cairo ABI', async () => {
    expect(contract_address).to.not.be.undefined;
    const { stdout, stderr } = await sh(
      `${warpBin} call ${contractCairoFile} --use_cairo_abi --function totalSupply_18160ddd --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );
    expect(stderr).to.be.empty;
    expect(stdout.split('\n')[1].trim()).to.be.equal('500 0');
  });
  it('balance of owner should equal totalSupply', async () => {
    expect(contract_address).to.not.be.undefined;
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const { stdout, stderr } = await sh(
      `${warpBin} call ${contractCairoFile} --function balanceOf  --inputs ${starknet_open_zeppelin_accounts[network].__default__.address} --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
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
      `${warpBin} new_account --account user1 --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

    await sh(
      `${warpBin} new_account --account user2 --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

    //mint some WEIs to these accounts
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    await mintEthToAccount(starknet_open_zeppelin_accounts[network].user1.address);
    await mintEthToAccount(starknet_open_zeppelin_accounts[network].user2.address);

    // account deployment
    await sh(
      `${warpBin} deploy_account --account user1 --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );
    await sh(
      `${warpBin} deploy_account --account user2 --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );
  });

  it('Transfer 100 tokens from owner to user1', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const transferToUser1 = await sh(
      `${warpBin} invoke ${contractCairoFile} --function transfer --inputs ${starknet_open_zeppelin_accounts[network].user1.address} 100 0 --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );

    expect(transferToUser1.stderr).to.be.empty;

    const tx_fee_eth = transferToUser1.stdout.split('\n')[1].split(':')[1].split('ETH')[0].trim();
    const tx_fee_wei = transferToUser1.stdout
      .split('\n')[1]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    const tx_hash = transferToUser1.stdout.split('\n')[4].split(':')[1].trim();

    expect(transferToUser1.stdout).to.be.equal(
      [
        `Running starknet compile with cairoPath ${path.resolve(__dirname, '..', '..', '..')}`,
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Invoke transaction was sent.`,
        `Contract address: ${contract_address}`,
        `Transaction hash: ${tx_hash}`,
        '\n',
      ].join('\n'),
    );

    const tx_status = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
    );

    expect(tx_status.stderr).to.be.empty;

    const tx_status_json = JSON.parse(tx_status.stdout);
    expect(tx_status_json.tx_status).to.equal('ACCEPTED_ON_L2');
  });

  it('Approve 200 tokens to user2', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const approveToUser2 = await sh(
      `${warpBin} invoke ${contractCairoFile} --function approve --inputs ${starknet_open_zeppelin_accounts[network].user2.address} 200 0 --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );

    expect(approveToUser2.stderr).to.be.empty;

    const tx_fee_eth = approveToUser2.stdout.split('\n')[1].split(':')[1].split('ETH')[0].trim();
    const tx_fee_wei = approveToUser2.stdout
      .split('\n')[1]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    const tx_hash = approveToUser2.stdout.split('\n')[4].split(':')[1].trim();

    expect(approveToUser2.stdout).to.be.equal(
      [
        `Running starknet compile with cairoPath ${path.resolve(__dirname, '..', '..', '..')}`,
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Invoke transaction was sent.`,
        `Contract address: ${contract_address}`,
        `Transaction hash: ${tx_hash}`,
        '\n',
      ].join('\n'),
    );

    const tx_status = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
    );

    expect(tx_status.stderr).to.be.empty;
    const tx_status_json = JSON.parse(tx_status.stdout);
    expect(tx_status_json.tx_status).to.equal('ACCEPTED_ON_L2');
  });

  it('Transfer 100 tokens from user2 to user1 on behalf of owner', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );

    const transferFromUser2ToUser1 = await sh(
      `${warpBin} invoke ${contractCairoFile} --function transferFrom --inputs ${starknet_open_zeppelin_accounts[network].__default__.address} ${starknet_open_zeppelin_accounts[network].user1.address} 100 0 --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir} --account user2`,
    );

    expect(transferFromUser2ToUser1.stderr).to.be.empty;

    const tx_fee_eth = transferFromUser2ToUser1.stdout
      .split('\n')[1]
      .split(':')[1]
      .split('ETH')[0]
      .trim();
    const tx_fee_wei = transferFromUser2ToUser1.stdout
      .split('\n')[1]
      .split(':')[1]
      .trim()
      .split('(')[1]
      .split('WEI')[0]
      .trim();

    const tx_hash = transferFromUser2ToUser1.stdout.split('\n')[4].split(':')[1].trim();

    expect(transferFromUser2ToUser1.stdout).to.be.equal(
      [
        `Running starknet compile with cairoPath ${path.resolve(__dirname, '..', '..', '..')}`,
        `Sending the transaction with max_fee: ${tx_fee_eth} ETH (${tx_fee_wei} WEI).`,
        `Invoke transaction was sent.`,
        `Contract address: ${contract_address}`,
        `Transaction hash: ${tx_hash}`,
        '\n',
      ].join('\n'),
    );

    const tx_status = await sh(
      `${warpBin} status ${tx_hash} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url}`,
    );

    expect(tx_status.stderr).to.be.empty;

    const tx_status_json = JSON.parse(tx_status.stdout);
    expect(tx_status_json.tx_status).to.equal('ACCEPTED_ON_L2');
  });

  this.afterAll('Verify accounts balance', async () => {
    const starknet_open_zeppelin_accounts = JSON.parse(
      fs.readFileSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'), 'utf-8'),
    );
    const ownerBalance = await sh(
      `${warpBin} call ${contractCairoFile} --function balanceOf  --inputs ${starknet_open_zeppelin_accounts[network].__default__.address} --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );
    expect(ownerBalance.stderr).to.be.empty;
    expect(ownerBalance.stdout.split('\n')[1].trim()).to.be.equal('300');

    const user1Balance = await sh(
      `${warpBin} call ${contractCairoFile} --function balanceOf  --inputs ${starknet_open_zeppelin_accounts[network].user1.address} --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
    );
    expect(user1Balance.stderr).to.be.empty;
    expect(user1Balance.stdout.split('\n')[1].trim()).to.be.equal('200');

    const user2Balance = await sh(
      `${warpBin} call ${contractCairoFile} --function balanceOf  --inputs ${starknet_open_zeppelin_accounts[network].user2.address} --address ${contract_address} --network ${network} --gateway_url ${gateway_url} --feeder_gateway_url ${gateway_url} --wallet ${starknet_wallet} --account_dir ${account_dir}`,
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
