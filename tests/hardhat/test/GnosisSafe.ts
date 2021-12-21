import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { readFileSync } from 'fs';
import { expect, assert } from 'chai';
import lodash from 'lodash';
import { describe, it } from 'mocha';
import { BigNumber, Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';
import { transpile, sh, starknet_deploy, starknet_invoke } from '../util';

describe('Token contract', function () {
  this.timeout(380_000);

  let Gnosis: ContractFactory;
  let gnosis: Contract;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  // eslint-disable-next-line no-unused-vars
  let addrs: SignerWithAddress[];
  // Prepend all Starknet/Cairo variables with c_
  let c_TokenAddress: string;
  let c_TokenAddressBN: BigNumber;

  describe('Transpilation & Deployment', async function () {
    it('Transpile Solidity to Cairo', async function () {
      await transpile('contracts/gnosis-safe/GnosisSafe.sol', 'GnosisSafe');
      await sh('mv contracts/gnosis-safe/GnosisSafe.json contracts/warp_artifacts');
      await sh('mv contracts/gnosis-safe/GnosisSafe.cairo contracts/cairo');
    });

    it('Deploy Solidity & Cairo Contracts', async function () {
      // ========================================================
      // Solidity Deployment
      // ========================================================
      Gnosis = await ethers.getContractFactory(
        'contracts/gnosis-safe/GnosisSafe.sol:GnosisSafe',
      );
      [owner, addr1, ...addrs] = await ethers.getSigners();
      gnosis = await Gnosis.deploy();
      await gnosis.deployed();

      // ========================================================
      // StarkNet Deployment
      // ========================================================
      const response = await starknet_deploy([], 'GnosisSafe.cairo', 'GnosisSafe.json');
      c_TokenAddressBN = BigNumber.from(response.data.contract_address);
      c_TokenAddress = c_TokenAddressBN._hex;
      console.log(c_TokenAddress);
    });
  });
});
