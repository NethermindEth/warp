import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
// import { expect, assert } from 'chai';
// import lodash from 'lodash';
import { describe, it } from 'mocha';
import { BigNumber, Contract, ContractFactory } from 'ethers';
import { ethers } from 'hardhat';
import { transpile, sh, starknet_deploy } from '../util';

describe('Gnosis Safe', function () {
  this.timeout(380_000);
  let Gnosis: ContractFactory;
  let GnosisProxy: ContractFactory;
  let gnosisProxy: Contract;
  let gnosis: Contract;
  // eslint-disable-next-line no-unused-vars
  let owner: SignerWithAddress;
  // eslint-disable-next-line no-unused-vars
  let addr1: SignerWithAddress;
  // eslint-disable-next-line no-unused-vars
  let addrs: SignerWithAddress[];
  // Prepend all Starknet/Cairo variables with c_
  let c_GnosisAddress: string;
  let c_GnosisAddressBN: BigNumber;
  let c_GnosisProxyAddress: string;
  let c_GnosisProxyAddressBN: BigNumber;

  describe('Transpilation & Deployment', async function () {
    // it('Transpile GnosisSafe', async function () {
    //   await transpile('contracts/gnosis-safe/GnosisSafe.sol', 'GnosisSafe');
    //   await sh('mv contracts/gnosis-safe/GnosisSafe.json artifacts/cairo');
    //   await sh('mv contracts/gnosis-safe/GnosisSafe.cairo contracts/cairo');
    // });

    // it('Transpile GnosisSafeProxyFactory', async function () {
    //   await transpile('contracts/gnosis-safe/proxies/GnosisSafeProxy.sol', 'GnosisSafeProxy');
    //   await sh('mv contracts/gnosis-safe/proxies/GnosisSafeProxy.json artifacts/cairo');
    //   await sh('mv contracts/gnosis-safe/proxies/GnosisSafeProxy.cairo contracts/cairo');
    // });

    it('Deploy Solidity & Cairo GnosisSafe', async function () {
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
      c_GnosisAddressBN = BigNumber.from(response.data.contract_address);
      c_GnosisAddress = c_GnosisAddressBN._hex;
      console.log(c_GnosisAddress);
    });

    // it('Deploy Solidity & Cairo GnosisSafeProxy', async function() {
    //   // ========================================================
    //   // Solidity Deployment
    //   // ========================================================
    //   GnosisProxy = await ethers.getContractFactory(
    //     'contracts/gnosis-safe/proxies/GnosisSafeProxy.sol:GnosisSafeProxy',
    //   );
    //   [owner, addr1, ...addrs] = await ethers.getSigners();
    //   gnosisProxy = await GnosisProxy.deploy(gnosis.address);
    //   await gnosisProxy.deployed();

    //   // ========================================================
    //   // StarkNet Deployment
    //   // ========================================================
    //   const response = await starknet_deploy([c_GnosisAddress], 'GnosisSafeProxy.cairo', 'GnosisSafeProxy.json');
    //   c_GnosisProxyAddressBN = BigNumber.from(response.data.contract_address);
    //   c_GnosisProxyAddress = c_GnosisProxyAddressBN._hex;
    //   console.log(c_GnosisProxyAddress);
    // });
  });
});
