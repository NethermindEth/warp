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
yarn warplib
```

5. Test the installation worked by transpiling an example ERC20 contract:

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

1. Run the setup script:

```bash
tests/behaviour/setup.sh
```

2. In a separate terminal, start a StarkNet testnet server (in an environment with cairo-lang installed):

```bash
yarn testnet
```

3. Run the tests:

```bash
yarn test
```

To generate benchmarks locally during development:

```bash
yarn testnet:benchmark
yarn test
```

```python
python starknet-testnet/generateMarkdown.py
```

This saves the benchmarks at `benchmark/stats/data.md`

## PR - CI Process

The project uses GitHub Actions to build its artifacts and run tests. We do our best to keep the suite fast and stable. For incoming PRs, builds and test runs must be clean.
