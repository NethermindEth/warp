<img src="https://github.com/NethermindEth/warp-ts/blob/develop/resources/WARP.svg" width="900" height="512" />

# Warp

Warp brings Solidity to StarkNet, making it possible to transpile Ethereum
smart contracts to Cairo, and use them on StarkNet.

## Installation :gear:

To get the dependencies:

```bash
yarn
```

Additionally, solc 0.8.11 must be installed and usable via 'solc' Instructions
can be found at
https://docs.soliditylang.org/en/v0.8.11/installing-solidity.html

Compile the project:

```bash
yarn tsc
```

## Usage :computer:

To transpile a contract:

```bash
bin/warp transpile example_contracts/ERC20.sol
```

## Testing

To test run warp on all example contracts:

```bash
bin/warp test
```

For this to work, you must be able to run

```bash
starknet-compile
```

Instructions to set this up can be found at
https://www.cairo-lang.org/docs/quickstart.html

To examine a solidity file in unwarped AST form:

```bash
bin/warp analyse example_contracts/ERC20.sol
```

---New tests---
The old tests check for successfully compiling cairo code
The new tests check for correctly running cairo code

First run the setup script:

```bash
tests/behaviour/setup.sh
```

Second, in a separate terminal, start a starknet-testnet server:

```bash
yarn testnet
```

then to run the tests:

```bash
yarn test
```

In order to generate benchmarks locally during development:

```bash
yarn testnet-b
yarn test
```

```python
python starknet-testnet/generateMarkdown.py
```

This saves the benchmarks at `benchmark/stats/data.md`

## Contribution :hammer_and_pick:

Contributions are welcome but please reach out to the team before attempting
any large modifications to the source. You can get an overview of the project's
progress on [our notion
board](https://nethermind.notion.site/eab63c6df3f7442c8761bc65d7b45e82?v=d9efd18a8a9947e9b760f3959e43a4fc)
along with good starting issues and descriptions of the intended solutions for
a number of others.
