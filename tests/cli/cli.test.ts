import { expect } from 'chai';
import { sh } from '../util';
import { describe, it } from 'mocha';
import * as path from 'path';
import fs from 'fs';

const starknet_wallet = 'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount';
const gateway_url = 'http://127.0.0.1:5050';
const network = 'alpha-goerli';
const account_dir = path.resolve(__dirname, '.');
const MAX_FEE = 1000000;

const TIME_LIMIT = 10 * 60 * 1000;

const warpBin = path.resolve(__dirname, '..', '..', '..', 'bin', 'warp');
const warpVenvPrefix = `PATH=${path.resolve(
  __dirname,
  '..',
  '..',
  '..',
  'warp_venv',
  'bin',
)}:$PATH`;

describe('Manage starknet account', function () {
  this.timeout(TIME_LIMIT);
  it('should create a starknet account', async () => {
    if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'))) {
      fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
    }

    await sh(
      `${warpVenvPrefix} starknet new_account --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir}`,
    );

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

    const { stdout } = await sh(
      `curl localhost:5050/mint -H "Content-Type: application/json" -d "{ \\"address\\": \\"${address}\\", \\"amount\\": 1000000000000000000, \\"lite\\": false }"`,
    );

    const response = JSON.parse(stdout);

    expect(response).to.not.be.undefined;
    expect(response['new_balance']).to.not.be.undefined;
    expect(response['new_balance']).to.equal(1000000000000000000);
    expect(response['tx_hash']).to.not.be.undefined;
  });

  it('should deploy the starknet account', async () => {
    console.log(warpBin, process.cwd());
    const { stdout, stderr } = await sh(
      `${warpBin} deploy_account --wallet ${starknet_wallet} --feeder_gateway_url ${gateway_url} --gateway_url ${gateway_url} --network ${network} --account_dir ${account_dir} --max_fee ${MAX_FEE}`,
    );
    console.log(stdout, stderr);
  });
});

// describe('Cleanup cli_test directory', function () {
//   this.timeout(TIME_LIMIT);
//   it('should remove the starknet account', async () => {
//     fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json'));
//     if (fs.existsSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json.backup'))) {
//       fs.unlinkSync(path.resolve(__dirname, 'starknet_open_zeppelin_accounts.json.backup'));
//     }
//   });
// });
