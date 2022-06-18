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

### Installation Method 1:

Without any virtual environment activated run the following in order:

```bash
yarn global add @nethermindeth/warp
```

Run the following to see the version and that it was installed:

```bash
warp version
```

Finally run the following to install the dependencies:

```bash
warp install
```

Test installation works by transpiling an example ERC20 contract:

```bash
warp transpile example_contracts/ERC20.sol
```

### Installation Method 2 (from source/for devs):

To get the dependencies:

```bash
yarn
```

Compile the project:

```bash
yarn tsc
yarn warplib
```

Get python dev dependencies:
(recommended to create a python3.7 venv for this)

```bash
pip install -r requirements.txt
```

## Usage :computer:

To transpile a contract:

```bash
warp transpile example_contracts/ERC20.sol
```

To transpile a contract and then cairo compile run:

```bash
warp transpile example_contracts/ERC20.sol --compile-cairo
```

Please note that transpiling a library by itself and not a contract will result in no output.
Libraries are bundled into point of use.

### Solidity Features Not Supported

There are a number of features that are not supported/do not have analogs in Starknet yet.
We will try our best to add these features as Starknet supports them, but some may not be
possible due to fundamental differences in the platforms.

Please see the list below:

|           Support Status            |      Symbol       |
| :---------------------------------: | :---------------: |
|   Will likely never be supported    |        :x:        |
|    Being developed/investigated     | :hammer_and_pick: |
| Currently Unknown/If added in Cairo |    :question:     |

|                      Solidity                      |  Support Status   |
| :------------------------------------------------: | :---------------: |
|            fallback functions with args            | :hammer_and_pick: |
|                   delagate calls                   | :hammer_and_pick: |
| contract creation from contracts (new, new w/salt) | :hammer_and_pick: |
|                  low level calls                   |        :x:        |
|              abi methods (abi.encode)              |        :x:        |
|              nested tuple expressions              |    :question:     |
|                typeName expressions                |    :question:     |
|                     gasleft()                      |    :question:     |
|                     msg.value                      |    :question:     |
|                      msg.sig                       |    :question:     |
|                      msg.data                      |    :question:     |
|                    tx.gasprice                     |    :question:     |
|                     tx.origin                      |    :question:     |
|                     try/catch                      |    :question:     |
|                   block.coinbase                   |    :question:     |
|                   block.gaslimit                   |    :question:     |
|                   block.basefee                    |    :question:     |
|                   block.chainid                    |    :question:     |
|                  block.difficulty                  |        :x:        |
|        precompiles (appart from ecrecover)         |    :question:     |
|                    selfdestruct                    |    :question:     |
|                     blockHash                      |    :question:     |
|                 functions as data                  |    :question:     |
|           sha256 (use keccak256 instead)           |        :x:        |
|                       addmod                       |        :x:        |
|                       mulmod                       |        :x:        |

## Testing for contributors :stethoscope:

To test that your contribution doesn't break any features you can test that all previous example contracts transpile and then cairo compile by running the following:

```bash
warp test
```

For this to work, you must have the cairo-lang package installed.
To test try:

```bash
starknet-compile -v
```

Instructions to set this up can be found at
https://www.cairo-lang.org/docs/quickstart.html

Then to see that your contribution doesn't break the behaviour tests follow these steps:

First run the setup script:

```bash
tests/behaviour/setup.sh
```

Second, in a separate terminal, start a starknet-testnet server (in an environment with cairo-lang installed):

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

## Contact Us :phone:

If you run into any problems please raise an issue or contact us on our Nethermind discord server: https://discord.com/invite/PaCMRFdvWT
