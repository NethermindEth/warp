<img src="https://raw.githubusercontent.com/NethermindEth/warp/develop/resources/warp.png"/>

# Warp

Warp brings Solidity to Starknet, making it possible to transpile Ethereum
smart contracts to Starknet Cairo Contracts.

:warning: **Note**: Cairo 1 support is being developed at this [branch](https://github.com/NethermindEth/warp/tree/cairo-1.0).

## Quickstart

> **Note:**
> Executing Warp using Docker works only for x86 architecture. If you're using ARM architecture (such as Apple's M1) you can find warp installation instructions [here](https://nethermindeth.github.io/warp/docs/getting_started/a-usage-and-installation).

The easiest way to start with warp is using docker. To do that navigate to the directory where you store your contracts and run command:

```
docker run --rm -v "$PWD:/dapp" nethermind/warp transpile <contract-path>
```

You can find docker installation guide [here](https://docs.docker.com/get-docker/).

## Quick links

<div align="center">

### 📖 [Documentation](https://nethermindeth.github.io/warp/)

### 📦 [Installation](https://nethermindeth.github.io/warp/docs/getting_started/a-usage-and-installation)

### ⚙️ [Installation for contributors](https://nethermindeth.github.io/warp/docs/category/contribution-guidelines/)

### ✍️ [Developing warp](https://nethermindeth.github.io/warp/docs/contribution_guidelines/implementation-and-testing)

### [![Discord](https://img.shields.io/badge/discord-0A66C2?style=for-the-badge&logo=Discord&logoColor=white)](https://discord.com/invite/PaCMRFdvWT)

### [![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/nethermindeth)

</div>

### Libraries

<hr>
Libraries are bundled into the point of use, therefore if you try transpile a standalone library it will result in no output. If you would like to transpile and deploy a standalone library please alter its declaration to `contract`.

<br>

### Unsupported Solidity Features

<hr>
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
