import '@nomiclabs/hardhat-waffle';
import '@openzeppelin/hardhat-upgrades';

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
export default {
  solidity: '0.8.0',
  network: 'hardhat',
  hardhat: {
    allowUnlimitedContractSize: true,
    blockGasLimit: 30_000_0000,
    gasPrice: 0,
  },
};
