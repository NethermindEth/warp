<img src="https://raw.githubusercontent.com/NethermindEth/warp/develop/resources/warp.png"/>

# Warp

Warp brings Solidity to Starknet, making it possible to transpile Ethereum
smart contracts to Starknet Cairo Contracts.

:warning: **Note**: Cairo 0 implementation of warp can be found at this [tag](https://github.com/NethermindEth/warp/tree/cairo-0).

## Quickstart

> **Note:**
> Executing Warp using Docker works only for x86 architecture. If you're using ARM architecture (such as Apple's M1) you can find warp installation instructions [here](https://nethermindeth.github.io/warp/docs/getting_started/a-usage-and-installation).

> **Note:**
> The method refers to warp for cairo 0. If you are looking for cairo 1 warp see [installing from source](https://nethermindeth.github.io/warp/docs/contribution_guidelines/a-installing-from-source).You might be also interested in [supported features in cairo 1 warp](https://github.com/NethermindEth/warp/tree/cairo-1.0#supported-features).

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

### Supported features

**Solidity**: Warp supports Solidity 0.8 and. In order to support newer versions [nethersolc](https://github.com/NethermindEth/nethersolc) has to be updated, and [nethersolc binaries](https://github.com/NethermindEth/warp/tree/develop/nethersolc) within warp repository have to be updated.

**Cairo**: The latest version of Cairo compiler supported by warp is 1.1. You can find compiler binaries together with warp plugin executable [in cairo1 directory](cairo1/). Warp plugin repository is located [here](https://github.com/NethermindEth/warp-plugin).

Warp doesn't support all features of Cairo 1 yet. You can find an example contract supported by warp in [tests/behaviour/contracts/if/localVariables.sol](tests/behaviour/contracts/if/localVariables.sol):

https://github.com/NethermindEth/warp/blob/321bfe76b27790327e5574c0d5c86c2acf95d750/tests/behaviour/contracts/if/localVariables.sol#L5-L25

For more fully working examples see [here](tests/behaviour/expectations/behaviour.ts). Uncommented lines are Solidity files that are passing tests. Those files are located in [tests/behaviour/contracts/](tests/behaviour/contracts/). There is also a list of compilation tests [here](tests/compilation/compilation.test.ts). It contains contracts that are partially working ie. they are compiling, but the code might not yield correct results in runtime.

You can find a list of missing features [here](github.com/NethermindEth/warp/issues/1083). Feel free to pick one of those and implement it yourself!
