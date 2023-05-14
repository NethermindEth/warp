---
title: QuickStart
sidebar_position: 1
---

<!-- # Welcome to Warp 2.0

We are excited to announce the second version of Warp, now designed to transpile your Solidity code directly into Cairo.

Warp 1 set out to show that compiling Solidity code into Cairo was possible, and paved the way for developers to access the benefits of Starknet without needing to master Cairo. Using everything we learned from Warp 1, we have written a new version adding vast improvements to contract efficiency and user experience. In this blog, we will talk through the improvements made to Warp, transpile OpenZeppelin’s ERC20 contract, and describe future plans for the project.

#### Want to know more on Warp 2.0? Read the blog [here](https://medium.com/nethermind-eth/warp-2-0-transpiling-directly-from-solidity-to-cairo-9bf41a6d26ee). -->

<!-- ## Quickstart -->

Docker compose provides a ready to use environment featuring warp and devnet.

> **Note:**
> Executing Warp using Docker works only for x86 architecture, ARM architectures (such as Apple's M1) will be supported soon.

### Build and run containers

```bash
docker-compose up
```

### Transpile

```bash
docker-compose exec warp warp transpile exampleContracts/ERC20.sol
```

It's best to copy the contract/repo to the warp directory so it is available in container via volume. Use contract's paths relative to warp root. For example, assuming you've copied your project to `warp/projects/myproject` you can replace `exampleContracts/ERC20.sol` with `projects/myproject/mycontract.sol` in the above command.

### Deploy to devnet

```bash
docker-compose exec warp warp compile warp_output/example__contracts/ERC20__WC__WARP.cairo
docker-compose exec warp starknet deploy --no_wallet --contract warp_output/example__contracts/ERC20__WC__WARP_compiled.json --gateway_url http://devnet:5050
```

## Documentation 📖

You can read the documentation [here](https://nethermindeth.github.io/warp/).

## Installation :gear:

To install Warp follow the installation instructions [here](./getting_started/a-usage-and-installation.mdx).

To build Warp for development see the [contributing guidelines](https://github.com/NethermindEth/warp/blob/develop/contributing.md).

## Usage :computer:

If you have used installation method 1 you can use the `warp` command in any folder. If you have used installation method 2, you will have to specify the path to the warp directory followed by `bin/warp` e.g `path_to_warp_repo/bin/warp ...`

### Starknet setup

Select your network and wallet types. It's recommended to set these as
environment variables but they can also be passed as explicit arguments to the
Warp CLI and the Starknet CLI.

```
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export STARKNET_NETWORK=alpha-goerli
```

Make sure you have a Starknet account set up, if you have not done so yet
please:

```
warp deploy_account
```

### CLI Commands

To transpile a Solidity contract:

```bash
warp transpile <path to Solidity contract>
```

To declare a Starknet contract:

```bash
warp declare <path to Starknet contract>
```

_Please note to deploy a contract you will first have to declare it._

To deploy a Starknet contract:

```bash
warp deploy <path to Starknet contract>
```

The deploy command will generate the compiled json file as well as the abi json
file. Use `warp deploy --help` command to see more deployment options.

### Libraries

Libraries are bundled into the point of use, therefore if you try transpile a standalone library it will result in no output. If you would like to transpile and deploy a standalone library please alter its declaration to `contract`.

### Unsupported Solidity Features

Several features of Solidity are not supported/do not have analogs in Starknet yet.
We will try our best to add these features as Starknet supports them, but some may not be
possible due to fundamental differences in the platforms.

Please see the list below:

|           Support Status            |      Symbol       |
| :---------------------------------: | :---------------: |
|   Will likely never be supported    |        :x:        |
|    Being developed/investigated     | :hammer_and_pick: |
| Currently Unknown/If added in Cairo |    :question:     |

|                      Solidity                       |  Support Status   |
| :-------------------------------------------------: | :---------------: |
|            fallback functions with args             | :hammer_and_pick: |
|                   delegate calls                    | :hammer_and_pick: |
|               indexed arrays in event               | :hammer_and_pick: |
|                   low level calls                   |        :x:        |
|              nested tuple expressions               |    :question:     |
|                      gasleft()                      |    :question:     |
|                      msg.value                      |    :question:     |
|                       msg.sig                       |    :question:     |
|                      msg.data                       |    :question:     |
|                     tx.gasprice                     |    :question:     |
|                      tx.origin                      |    :question:     |
|                      try/catch                      |    :question:     |
|                   block.coinbase                    |    :question:     |
|                   block.gaslimit                    |    :question:     |
|                    block.basefee                    |    :question:     |
|                    block.chainid                    |    :question:     |
|                  block.difficulty                   |        :x:        |
|         precompiles (apart from ecrecover)          |    :question:     |
|                    selfdestruct                     |    :question:     |
|                      blockhash                      |    :question:     |
|            functions pointers in storage            |    :question:     |
|           sha256 (use keccak256 instead)            |        :x:        |
|                       receive                       |    :question:     |
|  Inline Yul Assembly - (memory, calldata, storage)  |    :question:     |
|                 user defined errors                 |    :question:     |
|   function call options e.g x.f{gas: 10000}(arg1)   |    :question:     |
| member access of address object e.g address.balance |    :question:     |
|              nested tuple assignments               |    :question:     |

Note: We have changed the return of `ecrecover` to be `uint160` because we use the `address` type for Starknet addresses.

## Docker :whale:

> **Note:**
> Executing Warp using Docker works only for x86 architecture, ARM architectures (such as Apple's M1) will be supported soon.

Build the image from source:

```bash
docker build -t warp .
```

Run the container with the same options and arguments as the Warp binary:

```bash
docker run --rm -v $PWD:/dapp --user $(id -u):$(id -g) warp transpile exampleContracts/ERC20.sol
```

## Contributing

You can read about contributing, first steps, development tips and testing for contributors [here](https://github.com/NethermindEth/warp/blob/develop/contributing.md)

## Contact Us :phone:

[![Discord](https://img.shields.io/badge/discord-0A66C2?style=for-the-badge&logo=Discord&logoColor=white)](https://discord.com/invite/PaCMRFdvWT) [![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/nethermindeth)
