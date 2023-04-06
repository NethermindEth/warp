# Contributing

You can contribute to Warp by raising issues and PRs. Simply filing issues for problems you encounter is a great way to contribute. Contributing implementations is greatly appreciated.

## DOs and DON'Ts

Please do:

- **DO** give priority to the current style of the project or file you're changing even if it diverges from the general guidelines.
- **DO** include tests for both, new features and bug fixes
- **DO** keep the discussions focused on the initial topic

Please do not:

- **DON'T** raise PRs with style changes
- **DON'T** surprise us with big pull requests. It's better to first raise it as an issue and have it discussed
- **DON'T** commit code that you didn't author. This may breach IP
- **DON'T** submit PRs that alter licensing, contributing guide lines or code of conduct

## Installation

First, please make sure you have all the required external [dependencies](dependencies.md) installed.

Then, with a Python3.9 virtual environment activated, perform the following instructions:

1. Clone this repo and change directory into the `warp` folder.

2. Install the JavaScript dependencies:

```bash
yarn
```

3. Install the Python dependencies:

```bash
pip install -r requirements.txt
```

If you are using a M1 chipped Mac and getting a `'gmp.h' file not found` error when installing Cairo run the following:

```bash
CFLAGS=-I`brew --prefix gmp`/include LDFLAGS=-L`brew --prefix gmp`/lib pip install ecdsa fastecdsa sympy
```

Then run the pip command above again.

4. Compile the project:

```bash
yarn tsc
```

5. Compile Warp libraries

```bash
yarn warplib
```

6. Test the installation worked by transpiling an example ERC20 contract:

```bash
bin/warp transpile example_contracts/ERC20.sol
```

## First steps :feet:

To look what features we are currently working on or tasks that are pending to do, please checkout the [project on github](https://github.com/orgs/NethermindEth/projects/30/views/3).

## Developing tips :honey_pot:

While developing your code, remembering to compile the project every time some minor changes are applied can be annoying. You can start a process to recompile Warp on file changes.

In a separate terminal execute:

```bash
yarn dev
```

You can also run warp instructions using docker to achieve the same. This is an example using `transpile` command:

```bash
docker-compose exec warp npx ts-node src transpile example_contracts/ERC20.sol
```

### Testing for contributors :stethoscope:

Warp includes three sets of tests:

- Compilation Tests: These tests ensure that transpiled contracts are valid Cairo code.

- Behaviour Tests: These tests verify the correct functionality of transpiled contracts.

- Semantic Tests: These tests involve transpiling Solidity's semantic tests and checking that the runtime behaviour remains consistent.

#### Compilation Tests

Start by running the compilation tests to verify that your contribution doesn't break any fundamental features. These tests are also the quickest to execute.

```bash
yarn test:examples
```

#### Behaviour Tests

Behaviour tests involve transpiling a set of Solidity contracts and deploying them to a testnet. Each deployed contract undergoes testing for all of its runtime functionality.

1. Run the setup script (Required only once):

```bash
tests/behaviour/setup.sh
```

2. In a separate terminal, start a StarkNet testnet server (make sure cairo-lang is installed in the environment):

```bash
yarn testnet
```

3. Run the tests:

```bash
yarn test
```

<br>

To generate benchmarks locally during development:

```bash
yarn testnet:benchmark
yarn test
```

```python
python starknet-testnet/generateMarkdown.py
```

This saves the benchmarks at `benchmark/stats/data.md`

#### Semantic Tests

Semantic tests involve transpiling each of Solidity's behaviour tests and deploying them. Each test is executed, and its result is compared to the output of its Solidity counterpart.

Execute instructions _1_ and _2_ from [Behaviour Tests](#behaviour-tests) if you haven't already. Then:

3. Run semantic tests:

```bash
yarn test:semantic
```

## PR - CI Process

The project uses GitHub Actions to build its artifacts and run tests. We do our best to keep the suite fast and stable. For incoming PRs, builds and test runs must be clean.
