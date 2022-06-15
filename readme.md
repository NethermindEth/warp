<img src="https://github.com/NethermindEth/warp-ts/blob/develop/resources/WARP.svg" width="900" height="512" />

# Warp

Warp brings Solidity to StarkNet, making it possible to transpile Ethereum
smart contracts to StarkNet Cairo Contracts.

## Installation :gear:

You will also need [z3](https://github.com/Z3Prover/z3) to use warp,
installation instructions:

On macos:

```bash
brew install z3
```

On ubuntu:

```bash
sudo apt install libz3-dev
```

Make sure that you have the [`venv`](https://docs.python.org/3/library/venv.html)
module for your python installation.


### Installation from source

To get the dependencies:

```bash
yarn
```

Compile the project:

```bash
yarn tsc
```

Get python dev dependencies:
(recommended to create a python3.7 venv for this)

```bash
pip install -r requirements.txt
```

```bash
bin/warp
```

## Usage :computer:

To transpile a contract:

```bash
bin/warp transpile example_contracts/ERC20.sol
```

## Contributing :hammer_and_pick:


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
yarn testnet:benchmark
yarn test
```

```python
python starknet-testnet/generateMarkdown.py
```

This saves the benchmarks at `benchmark/stats/data.md`
