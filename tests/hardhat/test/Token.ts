// import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
// import { expect, assert } from 'chai';
// import lodash from 'lodash';
// import { describe, it } from 'mocha';
// import { BigNumber, Contract, ContractFactory } from 'ethers';
// import { ethers } from 'hardhat';
// import { transpile, sh, starknet_invoke } from '../util';
// import axios from 'axios';

// describe('Token contract', function () {
//   this.timeout(180_000);

//   let Token: ContractFactory;
//   let hardhatToken: Contract;
//   let owner: SignerWithAddress;
//   let initialOwnerBalance: BigNumber;
//   let addr1: SignerWithAddress;
//   // eslint-disable-next-line no-unused-vars
//   let addrs: SignerWithAddress[];
//   // Prepend all Starknet/Cairo variables with c_
//   let c_TokenAddress: string;
//   let c_TokenAddressBN: BigNumber;

//   describe('Transpilation & Deployment', async function () {
//     it('Transpile Solidity to Cairo', async function () {
//       await transpile('contracts/Token.sol', 'Token');
//       await sh('mv contracts/Token.json contracts/warp_artifacts');
//     });

//     it('Deploy Solidity & Cairo Contracts', async function () {
//       // ========================================================
//       // Solidity Deployment
//       // ========================================================
//       Token = await ethers.getContractFactory('contracts/Token.sol:Token');
//       [owner, addr1, ...addrs] = await ethers.getSigners();
//       const pHardhatToken = Token.deploy();

//       // ========================================================
//       // StarkNet Deployment
//       // ========================================================
//       const response = await axios.post('http://localhost:5000/gateway/add_transaction', {
//         tx_type: 'deploy',
//         cairo_contract: 'Token.cairo',
//         program_info: 'Token.json',
//         constructor_input: [],
//       });
//       c_TokenAddressBN = BigNumber.from(response.data.contract_address);
//       c_TokenAddress = c_TokenAddressBN._hex;
//       [hardhatToken] = await Promise.all([pHardhatToken]);
//     });

//     it('Test if owner is set', async function () {
//       const response = await starknet_invoke(
//         c_TokenAddress,
//         'owner',
//         [],
//         'Token.cairo',
//         'Token.json',
//       );
//       // If the contract call does not come from a another contract
//       // on StarkNet, the msg.sender will be 0
//       assert(lodash.isEqual(response.data['return_data'], [32, 2, 0, 0]));
//       expect(await hardhatToken.owner()).to.equal(owner.address);
//     });

//     it('Should assign the total supply of tokens to the owner', async function () {
//       initialOwnerBalance = await hardhatToken.balanceOf(owner.address);
//       expect(await hardhatToken.totalSupply()).to.equal(initialOwnerBalance);
//     });
//   });

//   describe('Transactions', function () {
//     it('Should transfer tokens between accounts', async function () {
//       // Transfer 100 tokens from owner to addr1
//       await hardhatToken.transfer(addr1.address, 100);
//       const addr1Balance: BigNumber = await hardhatToken.balanceOf(addr1.address);
//       expect(addr1Balance).to.equal(100);

//       const response = await starknet_invoke(
//         c_TokenAddress,
//         'transfer',
//         [
//           '3037883414322564986729689587584220623778965546622842731090759862740427646728',
//           '100',
//         ],
//         'Token.cairo',
//         'Token.json',
//       );
//       assert(lodash.isEqual(response.data['return_data'], [64, 4, 0, 999900, 0, 100]));
//     });

//     it('Should update balances after transfers', async function () {
//       // Check balances.
//       const response_owner = starknet_invoke(
//         c_TokenAddress,
//         'balanceOf',
//         ['0'],
//         'Token.cairo',
//         'Token.json',
//       );

//       const response_addr1 = starknet_invoke(
//         c_TokenAddress,
//         'balanceOf',
//         ['3037883414322564986729689587584220623778965546622842731090759862740427646728'],
//         'Token.cairo',
//         'Token.json',
//       );
//       const pFinalOwnerBalance = hardhatToken.balanceOf(owner.address);
//       const pAddr1Balance = hardhatToken.balanceOf(addr1.address);
//       const [c_ownerBalance, c_addr1Balance, finalOwnerBalance, addr1Balance] =
//         await Promise.all([
//           response_owner,
//           response_addr1,
//           pFinalOwnerBalance,
//           pAddr1Balance,
//         ]);
//       expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(100));
//       expect(addr1Balance).to.equal(100);
//       assert(lodash.isEqual(c_ownerBalance.data['return_data'], [32, 2, 0, 999900]));
//       assert(lodash.isEqual(c_addr1Balance.data['return_data'], [32, 2, 0, 100]));
//     });
//   });
// });
