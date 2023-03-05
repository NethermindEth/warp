<img src="https://raw.githubusercontent.com/NethermindEth/warp/develop/resources/warp.png"/>

# Warp
Warp brings Solidity to StarkNet, making it possible to transpile Ethereum
smart contracts to StarkNet Cairo Contracts.

## Quickstart

Docker compose provides a ready to use environment featuring warp and devnet.

> **Note:**
> Execute Warp using Docker works only for x86 architecture, x64 architectures will be supported soon.

### Build and run containers

```bash
docker-compose up
```

### Transpile

```bash
docker-compose exec warp warp transpile example_contracts/ERC20.sol
```

It's best to copy the contract/repo to the warp directory so it is available in container via volume. Use contract's paths relative to warp root. For example, assuming you've copied your project to `warp/projects/myproject` you can replace `example_contracts/ERC20.sol` with `projects/myproject/mycontract.sol` in the above command.

### Deploy to devnet

```bash
docker-compose exec warp warp compile warp_output/example__contracts/ERC20__WC__WARP.cairo
docker-compose exec warp starknet deploy --no_wallet --contract warp_output/example__contracts/ERC20__WC__WARP_compiled.json --gateway_url http://devnet:5050
```

## Documentation 📖

You can read the documentation [here](https://nethermindeth.github.io/warp/).

## Installation :gear:

### Dependencies

<hr> 
 
1. You will need [z3](https://github.com/Z3Prover/z3) and [gmp](https://gmplib.org/#DOWNLOAD)
   installed to use Warp.
  
- Install command on macOS:
```bash
brew install z3 gmp
```

If you're on an arm based Apple machine (m1/m2 mac) you'll need to install `gmp` and export some
environment variables

```
export CFLAGS=-I`brew --prefix gmp`/include
export LDFLAGS=-L`brew --prefix gmp`/lib
```

- Install command on Ubuntu:

```bash
sudo apt install libz3-dev libgmp3-dev
```

2. Install Python3.9 with dev dependencies (`python3.9 python3.9-venv python3.9-dev`) into your base env.
   If you do not have the dev dependencies installed the installation will fail.
   <br>

- Install commands on MacOS:

```bash
brew install python@3.9
```

With python3.9 already installed you have venv covered:

> If you are using Python 3.3 or newer (...) venv is included in the Python standard library and requires no additional installation.

Then you can install dev package using pip:

```bash
pip install python-dev-tools
```

- Install commands on Ubuntu:

```bash
sudo apt install python3.9 python3.9-venv python3.9-dev
```

Or you can just install python3.9 and then install python-dev-tools using pip.

### Warp Installation Method 1:

<hr> 
Without any virtual environment activated perform the following in order:

1. Add the warp package from npm.

```bash
yarn global add @nethermindeth/warp
```

2. Ensure the package was added by checking the version number:

```bash
warp version
```

3. Install the dependencies:

```bash
warp install --verbose
```

Use the `--python` flag to pass the path to `python3.9` binary, if the above command complains.

```bash
warp install --python <path/to/python3.9> --verbose
```

4. Test the installation worked by transpiling an example ERC20 contract:

```bash
warp transpile example_contracts/ERC20.sol
```

<br>

### Warp Installation Method 2 (from source/for devs):

<hr>

Make sure you have the [dependencies](#dependencies) installed first.

With a virtual environment (recommended Python3.9) activated:

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

## Usage :computer:

If you have used installation method 1 you can use the `warp` command in any folder. If you have used installation method 2, you will have to specify the path to the warp directory followed by `bin/warp` e.g `path_to_warp_repo/bin/warp ...`

### StarkNet setup

Select your network and wallet types. It's recommended to set these as
environment variables but they can also be passed as explicit arguments to the
Warp CLI and the StarkNet CLI.

```
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export STARKNET_NETWORK=alpha-goerli
```

Make sure you have a StarkNet account set up, if you have not done so yet
please:

```
warp deploy_account
```

### CLI Commands

<hr> 
To transpile a Solidity contract:

```bash
warp transpile <path to Solidity contract>
```

To declare a StarkNet contract:

```bash
warp declare <path to StarkNet contract>
```

_Please note to deploy a contract you will first have to declare it._

To deploy a StarkNet contract:

```bash
warp deploy <path to StarkNet contract>
```

The deploy command will generate the compiled json file as well as the abi json
file. Use `warp deploy --help` command to see more deployment options.

<br>

### Libraries

<hr>
Libraries are bundled into the point of use, therefore if you try transpile a standalone library it will result in no output. If you would like to transpile and deploy a standalone library please alter its declaration to `contract`.

<br>

### Unsupported Solidity Features

<hr>
Several features of Solidity are not supported/do not have analogs in Starknet yet.
We will try our best to add these features as StarkNet supports them, but some may not be
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

Note: We have changed the return of `ecrecover` to be `uint160` because we use the `address` type for StarkNet addresses.

## Docker :whale:

> **Note:**
> Execute Warp using Docker works only for x86 architecture, x64 architectures will be supported soon.

Build the image from source:

```bash
docker build -t warp .
```

Run the container with the same options and arguments as the Warp binary:

```bash
docker run --rm -v $PWD:/dapp --user $(id -u):$(id -g) warp transpile example_contracts/ERC20.sol
```

## Contributing

### First steps :feet:

If you like to contribute, the first step is to install Warp from source for devs [steps here](#warp-installation-method-2-from-sourcefor-devs)

To look what features we are currently working on or tasks that are pending to do, please checkout the project on github [here](https://github.com/orgs/NethermindEth/projects/30/views/3)

Also, please take a look through our [Contribution Guidelines](CONTRIBUTING.md)

### Developing tips :honey_pot:

While developing your code, remembering to compile the project every time some minor changes are applied could be annoying. You could start a process that watch for changes and automatically recompile it.

In a separate terminal execute:

```bash
yarn dev
```

Developers could run warp instructions using docker. This is an example using `transpile` command:

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

## Contact Us :phone:
<img src="{https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white}" />


